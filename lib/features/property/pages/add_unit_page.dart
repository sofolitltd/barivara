import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barivara/features/property/models/unit.dart';
import 'package:barivara/features/property/repositories/property_repository.dart';
import 'package:barivara/shared/services/cloudinary_service.dart';
import 'package:barivara/shared/providers/home_providers.dart';
import 'package:barivara/shared/widgets/responsive_layout.dart';

class AddUnitPage extends ConsumerStatefulWidget {
  final String propertyId;
  final String? unitId;
  const AddUnitPage({super.key, required this.propertyId, this.unitId});

  @override
  ConsumerState<AddUnitPage> createState() => _AddUnitPageState();
}

class _AddUnitPageState extends ConsumerState<AddUnitPage> {
  final _formKey = GlobalKey<FormState>();
  final _unitNumberController = TextEditingController();
  final _rentController = TextEditingController();
  final _floorController = TextEditingController();
  final _unitSizeController = TextEditingController();
  final _depositController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _videoUrlController = TextEditingController();
  String? _selectedUnitType;
  String _selectedStatus = 'vacant';
  final List<UtilityEntry> _utilities = [];
  final List<MeterEntry> _meters = [];
  bool _isSubmitting = false;
  bool _isUploadingImage = false;

  final _imagePicker = ImagePicker();
  XFile? _selectedImage;
  Unit? _loadedUnit;
  bool _isInitialized = false;

  final _unitTypes = [
    '1BHK',
    '2BHK',
    '3BHK',
    '4BHK',
    'Commercial',
    'Studio',
    'Other',
  ];
  final _statusOptions = ['vacant', 'occupied', 'maintenance', 'reserved', 'owner'];
  final _utilityTypes = [
    'Electricity',
    'Gas',
    'Water',
    'Internet',
    'Security',
    'Parking',
    'Service',
    'Other',
  ];
  final _meterTypes = [
    'Electricity',
    'Gas',
    'Water',
    'Other',
  ];
  void _initializeWithUnit(Unit unit) {
    if (_isInitialized) return;
    _loadedUnit = unit;
    _unitNumberController.text = unit.unitNumber;
    _rentController.text = unit.baseRent.toString();
    _floorController.text = unit.floorLevel?.toString() ?? '';
    _unitSizeController.text = unit.unitSize ?? '';
    _depositController.text = unit.securityDeposit?.toString() ?? '';
    _imageUrlController.text = unit.imageUrl ?? '';
    _videoUrlController.text = unit.videoUrl ?? '';
    _selectedUnitType = unit.unitType;
    _selectedStatus = unit.status;
    _utilities.clear();
    for (var entry in unit.defaultUtilities.entries) {
      final isCustom = !_utilityTypes.contains(entry.key);
      _utilities.add(
        UtilityEntry(name: entry.key, value: entry.value.toString(), isCustom: isCustom),
      );
    }
    _meters.clear();
    for (var entry in unit.meters.entries) {
      final isCustom = !_meterTypes.contains(entry.key);
      _meters.add(
        MeterEntry(type: entry.key, number: entry.value, isCustom: isCustom),
      );
    }
    _isInitialized = true;
  }

  @override
  void initState() {
    super.initState();
    if (widget.unitId == null) {
      // No defaults — user starts with empty fields
    }
  }

  @override
  void dispose() {
    _unitNumberController.dispose();
    _rentController.dispose();
    _floorController.dispose();
    _unitSizeController.dispose();
    _depositController.dispose();
    _imageUrlController.dispose();
    _videoUrlController.dispose();
    for (var u in _utilities) {
      u.dispose();
    }
    for (var m in _meters) {
      m.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageUrlController.text = '';
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(propertyRepositoryProvider);

      final utilities = <String, int>{};
      for (var u in _utilities) {
        final name = u.isCustom
            ? u.customController.text.trim().toLowerCase()
            : u.name.toLowerCase();
        if (name.isNotEmpty) {
          utilities[name] =
              int.tryParse(u.valueController.text.trim()) ?? 0;
        }
      }

      final meters = <String, String>{};
      for (var m in _meters) {
        final type =
            m.isCustom ? m.customController.text.trim() : m.type;
        if (type.isNotEmpty && m.numberController.text.trim().isNotEmpty) {
          meters[type] = m.numberController.text.trim();
        }
      }

      if (_selectedImage != null) {
        setState(() => _isUploadingImage = true);
        final url = await CloudinaryService.uploadImage(_selectedImage!);
        setState(() => _isUploadingImage = false);

        if (url != null) {
          if (_loadedUnit != null &&
              _loadedUnit!.imageUrl != null &&
              _loadedUnit!.imageUrl!.contains('cloudinary.com')) {
            await CloudinaryService.deleteImage(_loadedUnit!.imageUrl!);
          }
          _imageUrlController.text = url;
        } else {
          setState(() => _isSubmitting = false);
          if (mounted) {
            final messenger = ScaffoldMessenger.of(context);
            messenger.showSnackBar(
              SnackBar(
                duration: const Duration(minutes: 5),
                content: const Text('Failed to upload image. Please try again.'),
                action: SnackBarAction(
                  label: '✕',
                  textColor: Colors.white,
                  onPressed: () => messenger.hideCurrentSnackBar(),
                ),
              ),
            );
          }
          return;
        }
      } else {
        if (_loadedUnit != null &&
            _loadedUnit!.imageUrl != null &&
            _loadedUnit!.imageUrl!.contains('cloudinary.com') &&
            _imageUrlController.text.trim().isEmpty) {
          await CloudinaryService.deleteImage(_loadedUnit!.imageUrl!);
        }
      }

      if (_loadedUnit != null) {
        final isOwner = _selectedStatus == 'owner';
        final newRent = isOwner ? 0 : int.parse(_rentController.text.trim());
        var history = List<RentConfig>.from(_loadedUnit!.rentHistory);

        if (newRent != _loadedUnit!.baseRent) {
          history.add(
            RentConfig(
              amount: newRent,
              startDate: DateTime.now(),
              reason: 'Manual Update',
            ),
          );
        }

        final newDeposit = int.tryParse(_depositController.text.trim());
        var depositHistory = List<DepositConfig>.from(_loadedUnit!.depositHistory);
        if (newDeposit != _loadedUnit!.securityDeposit && newDeposit != null) {
          depositHistory.add(
            DepositConfig(
              amount: newDeposit,
              startDate: DateTime.now(),
              reason: 'Manual Update',
            ),
          );
        }

        final updatedUnit = _loadedUnit!.copyWith(
          unitNumber: _unitNumberController.text.trim(),
          baseRent: newRent,
          isOccupied: _selectedStatus == 'occupied' || _selectedStatus == 'owner',
          defaultUtilities: utilities,
          meters: meters,
          rentHistory: history,
          depositHistory: depositHistory,
          floorLevel: int.tryParse(_floorController.text.trim()),
          unitSize: _unitSizeController.text.trim().isEmpty
              ? null
              : _unitSizeController.text.trim(),
          unitType: _selectedUnitType,
          securityDeposit: int.tryParse(_depositController.text.trim()),
          status: _selectedStatus,
          imageUrl: _imageUrlController.text.trim().isEmpty
              ? null
              : _imageUrlController.text.trim(),
          videoUrl: _videoUrlController.text.trim().isEmpty
              ? null
              : _videoUrlController.text.trim(),
        );
        await repository.updateUnit(updatedUnit);
      } else {
        final isOwner = _selectedStatus == 'owner';
        final rent = isOwner ? 0 : int.parse(_rentController.text.trim());
        final newUnit = Unit(
          id: '',
          propertyId: widget.propertyId,
          unitNumber: _unitNumberController.text.trim(),
          baseRent: rent,
          isOccupied: _selectedStatus == 'occupied' || _selectedStatus == 'owner',
          defaultUtilities: utilities,
          meters: meters,
          rentHistory: [
            RentConfig(
              amount: rent,
              startDate: DateTime.now(),
              reason: 'Initial Rent',
            ),
          ],
          depositHistory: [
            DepositConfig(
              amount: int.tryParse(_depositController.text.trim()) ?? 0,
              startDate: DateTime.now(),
              reason: 'Initial Deposit',
            ),
          ],
          floorLevel: int.tryParse(_floorController.text.trim()),
          unitSize: _unitSizeController.text.trim().isEmpty
              ? null
              : _unitSizeController.text.trim(),
          unitType: _selectedUnitType,
          securityDeposit: int.tryParse(_depositController.text.trim()),
          status: _selectedStatus,
          imageUrl: _imageUrlController.text.trim().isEmpty
              ? null
              : _imageUrlController.text.trim(),
          videoUrl: _videoUrlController.text.trim().isEmpty
              ? null
              : _videoUrlController.text.trim(),
        );
        await repository.addUnit(newUnit);
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text('Error adding unit: $e'),
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
    if (widget.unitId != null) {
      final unitAsync = ref.watch(unitFutureProvider((widget.propertyId, widget.unitId!)));
      return unitAsync.when(
        data: (unit) {
          _initializeWithUnit(unit);
          return _buildContent(context);
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, s) => Scaffold(body: Center(child: Text('Error loading unit: $e'))),
      );
    }
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MaxWidthContainer(
          child: AppBar(
            title: Text(
              _loadedUnit != null ? 'Edit Unit' : 'Add New Unit',
            ),
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
                    'Unit Information',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a new unit to your property.',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildField(
                    label: 'Unit Number / Name',
                    controller: _unitNumberController,
                    icon: Icons.door_front_door_outlined,
                    hint: 'e.g. 2A or Unit-101',
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter unit number' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildDropdown(
                    label: 'Current Status',
                    value: _selectedStatus,
                    items: _statusOptions
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(s[0].toUpperCase() + s.substring(1)),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedStatus = v!),
                    isDark: isDark,
                  ),
                  if (_selectedStatus != 'owner') ...[
                    const SizedBox(height: 20),
                    _buildField(
                      label: 'Base Rent (Monthly)',
                      controller: _rentController,
                      icon: Icons.payments_outlined,
                      hint: 'e.g. 15000',
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v!.isEmpty ? 'Please enter rent amount' : null,
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          label: 'Floor Level',
                          controller: _floorController,
                          icon: Icons.layers_outlined,
                          hint: 'e.g. 2',
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildField(
                          label: 'Unit Size',
                          controller: _unitSizeController,
                          icon: Icons.square_foot_outlined,
                          hint: 'e.g. 1200 sq.ft',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'Unit Type',
                          value: _selectedUnitType,
                          items: _unitTypes
                              .map(
                                (t) =>
                                    DropdownMenuItem(value: t, child: Text(t)),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedUnitType = v),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (_selectedStatus != 'owner')
                        Expanded(
                          child: _buildField(
                            label: 'Security Deposit',
                            controller: _depositController,
                            icon: Icons.savings_outlined,
                            hint: 'e.g. 30000',
                            keyboardType: TextInputType.number,
                          ),
                        )
                      else
                        const Expanded(child: SizedBox.shrink()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Unit Image',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      InkWell(
                        onTap: _pickImage,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white10
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: _selectedImage != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          _selectedImage!.path,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : _imageUrlController.text.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          _imageUrlController.text,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: 40,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tap to upload image',
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              if (_selectedImage != null ||
                                  _imageUrlController.text.isNotEmpty)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: InkWell(
                                    onTap: _removeImage,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (_isUploadingImage) ...[
                        const SizedBox(height: 12),
                        const LinearProgressIndicator(),
                        const SizedBox(height: 8),
                        Text(
                          'Uploading image to Cloudinary...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    label: 'Video Walkthrough URL (Optional)',
                    controller: _videoUrlController,
                    icon: Icons.videocam_outlined,
                    hint: 'https://youtube.com/...',
                  ),
                  const SizedBox(height: 32),

                  // --- UTILITIES ---
                  const Text(
                    'Default Monthly Utilities',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add utility type and monthly amount.',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),

                  ..._utilities.asMap().entries.map((entry) {
                    final index = entry.key;
                    final utility = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: utility.isCustom
                                ? _buildField(
                                    label: index == 0 ? 'Utility Name' : '',
                                    controller: utility.customController,
                                    hint: 'Enter utility name',
                                  )
                                : _buildDropdown(
                                    label: index == 0 ? 'Utility Name' : '',
                                    value: utility.name.isEmpty
                                        ? null
                                        : utility.name,
                                    items: _utilityTypes
                                        .map(
                                          (t) => DropdownMenuItem(
                                            value: t,
                                            child: Text(t),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      if (v == 'Other') {
                                        setState(() {
                                          utility.name = '';
                                          utility.isCustom = true;
                                        });
                                      } else if (v != null) {
                                        setState(() => utility.name = v);
                                      }
                                    },
                                    isDark: isDark,
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildField(
                              label: index == 0 ? 'Amount (৳)' : '',
                              controller: utility.valueController,
                              hint: '0',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() {
                              utility.dispose();
                              _utilities.removeAt(index);
                            }),
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            padding: const EdgeInsets.only(bottom: 12),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () =>
                        setState(() => _utilities.add(UtilityEntry(name: ''))),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Utility'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  // --- METERS ---
                  const SizedBox(height: 32),
                  const Text(
                    'Utility Meters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add meter type and meter number.',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),

                  ..._meters.asMap().entries.map((entry) {
                    final index = entry.key;
                    final meter = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: meter.isCustom
                                ? _buildField(
                                    label: index == 0 ? 'Meter Type' : '',
                                    controller: meter.customController,
                                    hint: 'Enter meter type',
                                  )
                                : _buildDropdown(
                                    label: index == 0 ? 'Meter Type' : '',
                                    value: meter.type.isEmpty
                                        ? null
                                        : meter.type,
                                    items: _meterTypes
                                        .map(
                                          (t) => DropdownMenuItem(
                                            value: t,
                                            child: Text(t),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      if (v == 'Other') {
                                        setState(() {
                                          meter.type = '';
                                          meter.isCustom = true;
                                        });
                                      } else if (v != null) {
                                        setState(() => meter.type = v);
                                      }
                                    },
                                    isDark: isDark,
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildField(
                              label: index == 0 ? 'Meter Number' : '',
                              controller: meter.numberController,
                              hint: 'e.g. M-12345',
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() {
                              meter.dispose();
                              _meters.removeAt(index);
                            }),
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            padding: const EdgeInsets.only(bottom: 12),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () =>
                        setState(() => _meters.add(MeterEntry(type: ''))),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Meter'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: SizedBox(
                      width: ResponsiveLayout.isDesktop(context)
                          ? 300
                          : double.infinity,
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
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                _loadedUnit != null
                                    ? 'Update Unit'
                                    : 'Add Unit',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

}

class UtilityEntry {
  String name;
  bool isCustom;
  final TextEditingController valueController;
  final TextEditingController customController;

  UtilityEntry({required String name, String value = '0', bool isCustom = false})
    : name = name,
      isCustom = isCustom,
      valueController = TextEditingController(text: value),
      customController = TextEditingController(text: isCustom ? name : '');

  void dispose() {
    valueController.dispose();
    customController.dispose();
  }
}

class MeterEntry {
  String type;
  bool isCustom;
  final TextEditingController numberController;
  final TextEditingController customController;

  MeterEntry({String type = '', String number = '', bool isCustom = false})
    : type = type,
      isCustom = isCustom,
      numberController = TextEditingController(text: number),
      customController = TextEditingController(text: isCustom ? type : '');

  void dispose() {
    numberController.dispose();
    customController.dispose();
  }
}
