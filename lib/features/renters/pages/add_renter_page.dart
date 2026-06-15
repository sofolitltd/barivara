import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '/features/renters/models/renter.dart';
import '/features/renters/repositories/renter_repository.dart';
import '/shared/widgets/responsive_layout.dart';
import '/shared/services/cloudinary_service.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../shared/providers/home_providers.dart'
    show rentersStreamProvider;

class AddRenterPage extends ConsumerStatefulWidget {
  final String propertyId;
  final String unitId;
  final String? renterId;

  const AddRenterPage({
    super.key,
    required this.propertyId,
    required this.unitId,
    this.renterId,
  });

  @override
  ConsumerState<AddRenterPage> createState() => _AddRenterPageState();
}

class _AddRenterPageState extends ConsumerState<AddRenterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nidController = TextEditingController();
  final _occupationController = TextEditingController();
  final _depositController = TextEditingController();

  // Notes
  final _notesController = TextEditingController();

  DateTime _moveInDate = DateTime.now();
  DateTime? _moveOutDate;
  bool _isSubmitting = false;

  XFile? _renterImage;
  String? _existingPhotoUrl;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.renterId != null) {
      // Use a post-frame callback to read the current renter data from the stream
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final rentersAsync = ref.read(
          rentersStreamProvider((widget.propertyId, widget.unitId)),
        );
        rentersAsync.whenData((renters) {
          final renter = renters.cast<Renter?>().firstWhere(
            (r) => r?.id == widget.renterId,
            orElse: () => null,
          );
          if (renter == null) return;
          setState(() {
            _nameController.text = renter.name;
            _phoneController.text = renter.phone;
            _altPhoneController.text = renter.alternatePhone ?? '';
            _emailController.text = renter.email ?? '';
            _nidController.text = renter.nid;
            _occupationController.text = renter.occupation ?? '';
            _depositController.text = renter.advanceDeposit.toString();
            _existingPhotoUrl = renter.photoUrl;
            _notesController.text = renter.landlordNotes ?? '';
            _moveInDate = renter.moveInDate;
            _moveOutDate = renter.moveOutDate;
          });
        });
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _emailController.dispose();
    _nidController.dispose();
    _occupationController.dispose();
    _depositController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isMoveIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isMoveIn ? _moveInDate : (_moveOutDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isMoveIn) {
          _moveInDate = picked;
        } else {
          _moveOutDate = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    final renterRepo = ref.read(renterRepositoryProvider);

    try {
      // Delete old renter photo if replacing
      if (_renterImage != null && _existingPhotoUrl != null) {
        await CloudinaryService.deleteImage(_existingPhotoUrl!);
      }

      // Upload Renter Image
      String? renterPhotoUrl = _existingPhotoUrl;
      if (_renterImage != null) {
        final url = await CloudinaryService.uploadImage(_renterImage!);
        if (url != null) renterPhotoUrl = url;
      }

      final renter = Renter(
        id: widget.renterId ?? '',
        propertyId: widget.propertyId,
        unitId: widget.unitId,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        alternatePhone: _altPhoneController.text.trim().isEmpty
            ? null
            : _altPhoneController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        nid: _nidController.text.trim(),
        occupation: _occupationController.text.trim().isEmpty
            ? null
            : _occupationController.text.trim(),
        photoUrl: (renterPhotoUrl == null || renterPhotoUrl.isEmpty)
            ? null
            : renterPhotoUrl,
        advanceDeposit: int.parse(_depositController.text.trim()),
        moveInDate: _moveInDate,
        moveOutDate: _moveOutDate,
        landlordNotes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      if (widget.renterId != null) {
        await renterRepo.updateRenter(widget.propertyId, widget.unitId, renter);
      } else {
        await renterRepo.addRenter(widget.propertyId, widget.unitId, renter);
      }

      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text(
              widget.renterId != null
                  ? 'Renter updated successfully!'
                  : 'Renter added successfully!',
            ),
            backgroundColor: const Color(0xFF10B981),
            action: SnackBarAction(
              label: '✕',
              textColor: Colors.white,
              onPressed: () => messenger.hideCurrentSnackBar(),
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text('Error: $e'),
            action: SnackBarAction(
              label: '✕',
              textColor: Colors.white,
              onPressed: () => messenger.hideCurrentSnackBar(),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MaxWidthContainer(
          child: AppBar(
            title: Text(widget.renterId != null ? 'Edit Renter' : 'Add Renter'),
          ),
        ),
      ),
      body: MaxWidthContainer(
        maxWidth: 800,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Renter Information',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.renterId != null
                        ? 'Update the details of your tenant.'
                        : 'Enter the details of your new tenant.',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),

                  _sectionLabel('Personal Details'),
                  _buildImagePicker(
                    'Renter Photo',
                    _renterImage,
                    _existingPhotoUrl,
                    (file) => setState(() => _renterImage = file),
                    isDark,
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    label: 'Full Name',
                    controller: _nameController,
                    icon: Icons.person_outline,
                    hint: 'e.g. Md. Karim Hossain',
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildResponsiveRow(
                    isMobile: isMobile,
                    children: [
                      _buildField(
                        label: 'Occupation',
                        controller: _occupationController,
                        icon: Icons.work_outline,
                        hint: 'e.g. Software Engineer',
                      ),
                      _buildField(
                        label: 'NID Number',
                        controller: _nidController,
                        icon: Icons.badge_outlined,
                        hint: 'e.g. 1234567890',
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildResponsiveRow(
                    isMobile: isMobile,
                    children: [
                      _buildField(
                        label: 'Phone Number',
                        controller: _phoneController,
                        icon: Icons.phone_outlined,
                        hint: 'e.g. 01711223344',
                        keyboardType: TextInputType.phone,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      _buildField(
                        label: 'Alternate Phone',
                        controller: _altPhoneController,
                        icon: Icons.phone_android_outlined,
                        hint: 'Optional',
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  _sectionLabel('Contact Information'),
                  _buildField(
                    label: 'Email Address',
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    hint: 'e.g. karim@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),

                  _sectionLabel('Financial & Move-In'),
                  _buildField(
                    label: 'Advance Deposit (৳)',
                    controller: _depositController,
                    icon: Icons.payments_outlined,
                    hint: 'e.g. 30000',
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v!.isEmpty) return 'Required';
                      if (int.tryParse(v) == null) return 'Number only';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildResponsiveRow(
                    isMobile: isMobile,
                    children: [
                      _buildSingleDatePicker(
                        isDark: isDark,
                        label: 'Move-in Date',
                        date: _moveInDate,
                        onTap: () => _pickDate(true),
                      ),
                      _buildSingleDatePicker(
                        isDark: isDark,
                        label: 'Move-out Date',
                        date: _moveOutDate,
                        onTap: () => _pickDate(false),
                        isOptional: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  _sectionLabel('Internal Notes (Landlord Only)'),
                  _buildField(
                    label: 'Landlord Notes',
                    controller: _notesController,
                    icon: Icons.note_rounded,
                    hint: 'Private notes about this tenant...',
                  ),

                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              widget.renterId != null
                                  ? 'Update Renter'
                                  : 'Add Renter',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6366F1),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildResponsiveRow({
    required List<Widget> children,
    required bool isMobile,
    double spacing = 16,
  }) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.asMap().entries.map((entry) {
          final idx = entry.key;
          final child = entry.value;
          return Padding(
            padding:
                EdgeInsets.only(bottom: idx == children.length - 1 ? 0 : 20),
            child: child,
          );
        }).toList(),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((entry) {
        final idx = entry.key;
        final child = entry.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: idx == 0 ? 0 : spacing),
            child: child,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSingleDatePicker({
    required bool isDark,
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isOptional ? '$label (Optional)' : label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: Color(0xFF6366F1),
                ),
                const SizedBox(width: 12),
                Text(
                  date != null
                      ? "${date.day}/${date.month}/${date.year}"
                      : 'Select Date',
                  style: const TextStyle(fontSize: 15),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker(
    String label,
    XFile? file,
    String? currentUrl,
    Function(XFile?) onPicked,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final picked = await _picker.pickImage(source: ImageSource.gallery);
            if (picked != null) onPicked(picked);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey[300]!,
              ),
              image: file != null
                  ? (kIsWeb
                        ? DecorationImage(
                            image: NetworkImage(file.path),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: FileImage(File(file.path)),
                            fit: BoxFit.cover,
                          ))
                  : (currentUrl != null && currentUrl.isNotEmpty)
                  ? DecorationImage(
                      image: NetworkImage(currentUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: file == null && (currentUrl == null || currentUrl.isEmpty)
                ? Icon(Icons.add_a_photo_outlined, color: Colors.grey[400])
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
          ),
        ),
      ],
    );
  }

}
