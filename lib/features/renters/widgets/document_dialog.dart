import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/features/renters/models/renter.dart';
import 'package:file_picker/file_picker.dart';

class ProfessionalDocumentDialog extends StatefulWidget {
  final Function(RenterDocument, XFile) onAdd;

  const ProfessionalDocumentDialog({super.key, required this.onAdd});

  @override
  State<ProfessionalDocumentDialog> createState() => _ProfessionalDocumentDialogState();
}

class _ProfessionalDocumentDialogState extends State<ProfessionalDocumentDialog> {
  final _titleController = TextEditingController();
  XFile? _selectedFile;
  String _selectedType = 'NID Front';
  
  final List<String> _commonTypes = ['NID Front', 'NID Back', 'Passport', 'Visiting Card', 'Birth Certificate', 'Other'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF6366F1);

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Add Document', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Document Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _commonTypes.map((type) {
                final isSelected = _selectedType == type;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = type;
                      if (type != 'Other') _titleController.text = type;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : (isDark ? Colors.white10 : Colors.grey[100]),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? primaryColor : Colors.transparent),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            if (_selectedType == 'Other') ...[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Custom Title',
                  hintText: 'e.g. Employee ID',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
            ],
            GestureDetector(
              onTap: () async {
                final result = await FilePicker.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                  withData: true,
                );
                if (result != null) {
                  setState(() => _selectedFile = result.files.single.xFile);
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.3), style: BorderStyle.solid),
                ),
                child: Column(
                  children: [
                    Icon(
                      _selectedFile == null 
                        ? Icons.cloud_upload_outlined 
                        : (_selectedFile!.name.toLowerCase().endsWith('.pdf') ? Icons.picture_as_pdf : Icons.check_circle),
                      size: 40,
                      color: _selectedFile == null ? primaryColor : (_selectedFile!.name.toLowerCase().endsWith('.pdf') ? Colors.red : Colors.green),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _selectedFile == null ? 'Tap to select Image or PDF' : 'Document Selected!',
                      style: TextStyle(fontWeight: FontWeight.bold, color: _selectedFile == null ? Colors.grey : Colors.green),
                    ),
                    if (_selectedFile != null)
                      Text(_selectedFile!.name, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_selectedFile != null && (_selectedType != 'Other' || _titleController.text.isNotEmpty))
                    ? () {
                        widget.onAdd(
                          RenterDocument(
                            title: _selectedType == 'Other' ? _titleController.text.trim() : _selectedType,
                            url: _selectedFile!.path,
                            uploadedAt: DateTime.now(),
                          ),
                          _selectedFile!,
                        );
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Add Document', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
