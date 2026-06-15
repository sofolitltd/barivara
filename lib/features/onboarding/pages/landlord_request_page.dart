import 'package:barivara/shared/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:barivara/features/onboarding/models/landlord_request.dart';
import 'package:barivara/features/auth/repositories/auth_repository.dart';
import 'package:barivara/features/admin/repositories/admin_repository.dart';

class LandlordRequestPage extends ConsumerStatefulWidget {
  const LandlordRequestPage({super.key});

  @override
  ConsumerState<LandlordRequestPage> createState() => _LandlordRequestPageState();
}

class _LandlordRequestPageState extends ConsumerState<LandlordRequestPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Profile Info
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nidController = TextEditingController();
  
  // Security Info
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SelectionArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          
          child: MaxWidthContainer(
            child: AppBar(
              title: const Text('Landlord Registration'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.canPop() ? context.pop() : context.go('/login'),
              ),
            ),
          ),
        ),
      body: MaxWidthContainer(
        maxWidth: 800,

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[300]!), color: Colors.white),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Start your Journey',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create an account and submit your documents for verification.',
                    style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  
                  // --- SECTION 1: PERSONAL PROFILE ---
                  _sectionHeader('Personal Profile'),
                  _buildField('Full Name', _nameController, Icons.person_outline),
                  const SizedBox(height: 20),
                  _buildField('Phone Number', _phoneController, Icons.phone_outlined),
                  const SizedBox(height: 20),
                  _buildField('NID Number', _nidController, Icons.badge_outlined),
                  const SizedBox(height: 32),
            
                  // --- SECTION 2: EVIDENCE ---
                  _sectionHeader('Property Evidence'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.1)),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.cloud_upload_outlined, size: 48, color: Color(0xFF6366F1)),
                        SizedBox(height: 12),
                        Text('Upload Property Proof (Optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Text('Electricity bill or tax document', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
            
                  // --- SECTION 3: ACCOUNT SECURITY ---
                  _sectionHeader('Account Security'),
                  _buildField('Email Address', _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),
                  _buildField('Password', _passwordController, Icons.lock_outline, isPassword: true),
                  
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Create Account & Submit'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6366F1),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildField(
    String label, 
    TextEditingController controller, 
    IconData icon, {
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: 'Enter your $label',
          ),
          validator: (v) {
            if (v?.isEmpty ?? true) return 'Required';
            if (label.contains('Password') && v!.length < 6) return 'Min 6 characters';
            if (label.contains('Email') && !v!.contains('@')) return 'Invalid email';
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final adminRepo = ref.read(adminRepositoryProvider);
      
      // 1. Create Firebase Auth Account Immediately
      final userCredential = await authRepo.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      final userId = userCredential.user!.uid;

      // 2. Submit Landlord Request Linked to this UID
      final request = LandlordRequest(
        userId: userId,
        userName: _nameController.text,
        phone: _phoneController.text,
        nidNumber: _nidController.text,
        ownerProofImageUrl: '', // Optional for now
        createdAt: DateTime.now(),
      );

      await adminRepo.submitLandlordRequest(request, _emailController.text.trim());

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Account Created!'),
            content: const Text('Your account has been created and your documents are under review. You can now log in, but dashboard access will be granted after verification.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  context.go('/landlord/dashboard'); // Go to dashboard (shows pending status)
                },
                child: const Text('Got it'),
              ),
            ],
          ),
        );
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
}
