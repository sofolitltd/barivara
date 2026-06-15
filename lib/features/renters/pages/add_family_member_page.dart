import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/features/renters/models/renter.dart';
import '/shared/widgets/responsive_layout.dart';
import '../widgets/document_dialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddFamilyMemberPage extends StatefulWidget {
  final FamilyMember? initialMember;

  const AddFamilyMemberPage({super.key, this.initialMember});

  @override
  State<AddFamilyMemberPage> createState() => _AddFamilyMemberPageState();
}

class _AddFamilyMemberPageState extends State<AddFamilyMemberPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _relationController;
  late TextEditingController _phoneController;
  late TextEditingController _nidController;
  late TextEditingController _occupationController;

  bool _isEmergencyContact = false;
  XFile? _photo;
  String? _existingPhotoUrl;
  final List<RenterDocument> _documents = [];
  final List<XFile?> _documentFiles = [];
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final m = widget.initialMember;
    _nameController = TextEditingController(text: m?.name ?? '');
    _relationController = TextEditingController(text: m?.relation ?? '');
    _phoneController = TextEditingController(text: m?.phone ?? '');
    _nidController = TextEditingController(text: m?.nid ?? '');
    _occupationController = TextEditingController(text: m?.occupation ?? '');
    _isEmergencyContact = m?.isEmergencyContact ?? false;
    _existingPhotoUrl = m?.photoUrl;
    if (m?.documents != null) {
      _documents.addAll(m!.documents);
      for (var i = 0; i < m.documents.length; i++) {
        _documentFiles.add(null); // No new file for existing documents
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    _nidController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _photo = image);
    }
  }

  void _showAddDocumentDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfessionalDocumentDialog(
        onAdd: (doc, file) {
          setState(() {
            _documents.add(doc);
            _documentFiles.add(file);
          });
        },
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final member = FamilyMember(
      name: _nameController.text.trim(),
      relation: _relationController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      nid: _nidController.text.trim().isEmpty ? null : _nidController.text.trim(),
      occupation: _occupationController.text.trim().isEmpty ? null : _occupationController.text.trim(),
      photoUrl: _existingPhotoUrl,
      isEmergencyContact: _isEmergencyContact,
      documents: _documents,
    );

    // We return the member AND the files to be uploaded by the main AddRenterPage
    Navigator.pop(context, {
      'member': member,
      'photoFile': _photo,
      'documentFiles': _documentFiles,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF6366F1);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MaxWidthContainer(
          child: AppBar(
            title: Text(widget.initialMember == null ? 'Add Family Member' : 'Edit Family Member'),
            actions: [
              TextButton(
                onPressed: _submit,
                child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
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
                  Text(
                    widget.initialMember == null ? 'Family Member Details' : 'Edit Member Details',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the personal and document information of the family member.',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: primaryColor.withValues(alpha: 0.2), width: 2),
                          image: _photo != null
                              ? (kIsWeb 
                                  ? DecorationImage(image: NetworkImage(_photo!.path), fit: BoxFit.cover)
                                  : DecorationImage(image: AssetImage(_photo!.path), fit: BoxFit.cover)) // Focus on Wasm for now
                              : (_existingPhotoUrl != null
                                  ? DecorationImage(image: NetworkImage(_existingPhotoUrl!), fit: BoxFit.cover)
                                  : null),
                        ),
                        child: (_photo == null && _existingPhotoUrl == null)
                            ? Icon(Icons.person_outline, size: 50, color: Colors.grey[400])
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickPhoto,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionLabel('Basic Information'),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Full Name',
                        controller: _nameController,
                        icon: Icons.person_outline,
                        hint: 'e.g. John Doe',
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Relation',
                        controller: _relationController,
                        icon: Icons.people_outline,
                        hint: 'e.g. Spouse',
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  icon: Icons.phone_outlined,
                  hint: 'Optional',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'NID Number',
                  controller: _nidController,
                  icon: Icons.badge_outlined,
                  hint: 'Optional',
                ),
                const SizedBox(height: 32),
                
                _buildSectionLabel('Documents'),
                _buildDocumentList(isDark),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: _showAddDocumentDialog,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add Identity Document'),
                ),
                
                const SizedBox(height: 32),
                _buildSectionLabel('Settings'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.emergency_outlined, color: _isEmergencyContact ? Colors.red : Colors.grey),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Emergency Contact', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Mark this member as primary emergency contact', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isEmergencyContact,
                        onChanged: (v) => setState(() => _isEmergencyContact = v),
                        activeThumbColor: Colors.red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: -0.5),
      ),
    );
  }

  Widget _buildTextField({
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
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentList(bool isDark) {
    if (_documents.isEmpty) return const SizedBox.shrink();
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _documents.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1)),
        itemBuilder: (context, index) {
          final doc = _documents[index];
          return ListTile(
            leading: const Icon(Icons.description_outlined, color: Colors.blue),
            title: Text(doc.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
              onPressed: () => setState(() {
                _documents.removeAt(index);
                _documentFiles.removeAt(index);
              }),
            ),
          );
        },
      ),
    );
  }
}


