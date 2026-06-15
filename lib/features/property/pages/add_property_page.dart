import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barivara/features/property/models/property.dart';
import 'package:barivara/features/property/repositories/property_repository.dart';
import 'package:barivara/shared/providers/home_providers.dart';
import 'package:barivara/shared/widgets/responsive_layout.dart';
import 'package:barivara/shared/services/cloudinary_service.dart';

class AddPropertyPage extends ConsumerStatefulWidget {
  final String? propertyId;
  const AddPropertyPage({super.key, this.propertyId});

  @override
  ConsumerState<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends ConsumerState<AddPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _mapLinkController = TextEditingController();
  final _videoUrlController = TextEditingController();
  String? _selectedPropertyType;
  bool _isSubmitting = false;
  bool _isUploadingImage = false;

  final _imagePicker = ImagePicker();
  XFile? _selectedImage;
  Property? _loadedProperty;
  bool _isInitialized = false;

  final _propertyTypes = [
    'Apartment Building',
    'Commercial Building',
    'Standalone House',
    'Studio Complex',
    'Mixed Use',
    'Other'
  ];

  void _initializeWithProperty(Property property) {
    if (_isInitialized) return;
    _loadedProperty = property;
    _nameController.text = property.name;
    _addressController.text = property.address;
    _selectedPropertyType = property.propertyType;
    _imageUrlController.text = property.imageUrl ?? '';
    _mapLinkController.text = property.googleMapsUrl ?? '';
    _videoUrlController.text = property.videoUrl ?? '';
    _isInitialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _imageUrlController.dispose();
    _mapLinkController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
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

    // Get the real logged-in user's UID
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) context.go('/login');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(propertyRepositoryProvider);

      if (_selectedImage != null) {
        setState(() => _isUploadingImage = true);
        final url = await CloudinaryService.uploadImage(_selectedImage!);
        setState(() => _isUploadingImage = false);
        
        if (url != null) {
          if (_loadedProperty != null && 
              _loadedProperty!.imageUrl != null && 
              _loadedProperty!.imageUrl!.contains('cloudinary.com')) {
            await CloudinaryService.deleteImage(_loadedProperty!.imageUrl!);
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
        // If no new image was picked, but the existing image was cleared
        if (_loadedProperty != null && 
            _loadedProperty!.imageUrl != null && 
            _loadedProperty!.imageUrl!.contains('cloudinary.com') &&
            _imageUrlController.text.trim().isEmpty) {
          await CloudinaryService.deleteImage(_loadedProperty!.imageUrl!);
        }
      }
      
      if (_loadedProperty != null) {
        final updatedProperty = _loadedProperty!.copyWith(
          name: _nameController.text.trim(),
          address: _addressController.text.trim(),
          propertyType: _selectedPropertyType,
          imageUrl: _imageUrlController.text.trim().isEmpty ? '' : _imageUrlController.text.trim(),
          googleMapsUrl: _mapLinkController.text.trim().isEmpty ? null : _mapLinkController.text.trim(),
          videoUrl: _videoUrlController.text.trim().isEmpty ? null : _videoUrlController.text.trim(),
        );
        await repository.updateProperty(updatedProperty);
      } else {
        final newProperty = Property(
          id: '',
          name: _nameController.text.trim(),
          address: _addressController.text.trim(),
          ownerId: currentUser.uid,
          propertyType: _selectedPropertyType,
          imageUrl: _imageUrlController.text.trim().isEmpty ? '' : _imageUrlController.text.trim(),
          googleMapsUrl: _mapLinkController.text.trim().isEmpty ? null : _mapLinkController.text.trim(),
          videoUrl: _videoUrlController.text.trim().isEmpty ? null : _videoUrlController.text.trim(),
        );
        await repository.addProperty(newProperty);
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text('Error adding property: $e'),
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
    if (widget.propertyId != null) {
      final propertyAsync = ref.watch(propertyFutureProvider(widget.propertyId!));
      return propertyAsync.when(
        data: (property) {
          _initializeWithProperty(property);
          return _buildContent(context);
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, s) => Scaffold(body: Center(child: Text('Error: $e'))),
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
          child: AppBar(title: Text(_loadedProperty != null ? 'Edit Property' : 'Add New Property')),
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
                if (!isDark) BoxShadow(
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
                    'Property Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the basic information about your property.',
                    style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                  const SizedBox(height: 32),
                  _buildField(
                    label: 'Property Name',
                    controller: _nameController,
                    icon: Icons.home_work_outlined,
                    hint: 'e.g. Al-Amin Villa',
                    validator: (v) => v!.isEmpty ? 'Please enter a name' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    label: 'Address',
                    controller: _addressController,
                    icon: Icons.location_on_outlined,
                    hint: 'e.g. House 12, Road 5, Sector 7, Uttara',
                    validator: (v) => v!.isEmpty ? 'Please enter an address' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildDropdown(
                    label: 'Property Type',
                    value: _selectedPropertyType,
                    items: _propertyTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) => setState(() => _selectedPropertyType = v),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Property Image',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickImage,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? Colors.white10 : Colors.grey[300]!,
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
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add_photo_alternate_outlined,
                                                  size: 40, color: Colors.grey[400]),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Tap to upload image',
                                                style: TextStyle(color: Colors.grey[500], fontSize: 13),
                                              ),
                                            ],
                                          ),
                              ),
                              if (_selectedImage != null || _imageUrlController.text.isNotEmpty)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: InkWell(
                                    onTap: _removeImage,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.5),
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
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    label: 'Google Maps Link (Optional)',
                    controller: _mapLinkController,
                    icon: Icons.map_outlined,
                    hint: 'https://maps.app.goo.gl/...',
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    label: 'Property Video URL (Optional)',
                    controller: _videoUrlController,
                    icon: Icons.videocam_outlined,
                    hint: 'https://youtube.com/...',
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: SizedBox(
                      width: ResponsiveLayout.isDesktop(context) ? 300 : double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(_loadedProperty != null ? 'Update Property' : 'Save Property', 
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
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
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
