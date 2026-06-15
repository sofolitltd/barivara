import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:barivara/features/landing/models/rent_post.dart';
import 'package:barivara/features/landing/repositories/listing_repository.dart';
import 'package:barivara/shared/widgets/responsive_layout.dart';
import 'package:barivara/shared/providers/home_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddListingPage extends ConsumerStatefulWidget {
  final String? initialPostId;
  final RentPost? initialPost;
  final String? propertyId;
  final String? unitId;

  const AddListingPage({
    super.key,
    this.initialPostId,
    this.initialPost,
    this.propertyId,
    this.unitId,
  });

  @override
  ConsumerState<AddListingPage> createState() => _AddListingPageState();
}

class _AddListingPageState extends ConsumerState<AddListingPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _rentController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialPost?.title);
    _descController = TextEditingController(
      text: widget.initialPost?.description,
    );
    _locationController = TextEditingController(
      text: widget.initialPost?.location,
    );
    _rentController = TextEditingController(
      text: widget.initialPost?.rentAmount.toString() ?? '',
    );

    // Pre-fill from unit data if creating a new listing
    if (widget.initialPost == null && widget.initialPostId == null &&
        widget.propertyId != null &&
        widget.unitId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Import providers from shared
        final propertyAsync = ref.read(
          propertyFutureProvider(widget.propertyId!),
        );
        final unitsAsync = ref.read(unitsStreamProvider(widget.propertyId!));

        propertyAsync.whenData((property) {
          if (_locationController.text.isEmpty) {
            _locationController.text = property.address;
          }

          unitsAsync.whenData((units) {
            try {
              final unit = units.firstWhere((f) => f.id == widget.unitId);
              setState(() {
                if (_titleController.text.isEmpty) {
                  _titleController.text =
                      'Unit ${unit.unitNumber} at ${property.name}';
                }
                if (_descController.text.isEmpty) {
                  _descController.text =
                      'Beautiful ${unit.unitType ?? "apartment"} located on the ${unit.floorLevel ?? "N/A"} floor. '
                      'Total size: ${unit.unitSize ?? "N/A"}. Comes with ${unit.defaultUtilities.length} utility items.';
                }
                if (_rentController.text.isEmpty) {
                  _rentController.text = unit.baseRent.toString();
                }
              });
            } catch (_) {}
          });
        });
      });
    } else if (widget.initialPostId != null && widget.initialPost == null) {
      // Fetch post for editing on web refresh
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final post = await ref.read(rentPostFutureProvider(widget.initialPostId!).future);
        if (post != null) {
          setState(() {
            _titleController.text = post.title;
            _descController.text = post.description;
            _locationController.text = post.location;
            _rentController.text = post.rentAmount.toString();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _rentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(listingRepositoryProvider);

      if (widget.initialPost != null || widget.initialPostId != null) {
        final existingPost = widget.initialPost ?? 
            await ref.read(rentPostFutureProvider(widget.initialPostId!).future);
        
        if (existingPost == null) throw 'Listing not found';

        final updatedPost = existingPost.copyWith(
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          location: _locationController.text.trim(),
          rentAmount: int.parse(_rentController.text.trim()),
        );
        await repository.updateRentPost(updatedPost);
      } else {
        // Fetch unit and property to get extra info
        final property = await ref.read(
          propertyFutureProvider(widget.propertyId!).future,
        );
        final units = await ref.read(
          unitsStreamProvider(widget.propertyId!).future,
        );
        final unit = units.firstWhere((f) => f.id == widget.unitId);

        // Extract beds from unitType (e.g., "3BHK" -> 3)
        int beds = 0;
        if (unit.unitType != null) {
          final match = RegExp(r'(\d+)').firstMatch(unit.unitType!);
          if (match != null) beds = int.parse(match.group(1)!);
        }

        final newPost = RentPost(
          id: '', // Set by repo
          propertyId: widget.propertyId!,
          unitId: widget.unitId!,
          landlordId: user.uid,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          location: _locationController.text.trim(),
          rentAmount: int.parse(_rentController.text.trim()),
          createdAt: DateTime.now(),
          isActive: true,
          imageUrls: unit.imageUrl != null
              ? [unit.imageUrl!]
              : [
                  'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&q=80&w=1000',
                ],
          propertyType: property.propertyType,
          beds: beds,
          baths: 2, // Default or fetch if available
          areaSqft: unit.unitSize,
        );
        await repository.createRentPost(newPost);
      }
      if (mounted) context.pop();
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

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MaxWidthContainer(
          child: AppBar(
            title: Text(
              (widget.initialPost != null || widget.initialPostId != null) ? 'Edit Listing' : 'Create Listing',
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
                    'Listing Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create a public post to attract new tenants.',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildField(
                    'Listing Title',
                    _titleController,
                    Icons.title,
                    'e.g. Luxury 3BHK in Uttara',
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    'Description',
                    _descController,
                    Icons.description,
                    'Tell us about the unit...',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    'Location',
                    _locationController,
                    Icons.location_on,
                    'e.g. Sector 7, Uttara',
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    'Monthly Rent',
                    _rentController,
                    Icons.payments,
                    'e.g. 15000',
                    keyboardType: TextInputType.number,
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
                                (widget.initialPost != null || widget.initialPostId != null)
                                    ? 'Update Listing'
                                    : 'Publish Listing',
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

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon,
    String hint, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (v) => v!.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }
}
