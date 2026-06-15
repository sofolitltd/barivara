import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../models/renter.dart';
import '../repositories/renter_repository.dart';
import '/shared/widgets/responsive_layout.dart';
import '/shared/providers/home_providers.dart';
import '/shared/services/cloudinary_service.dart';
import '../widgets/document_dialog.dart';
import '../widgets/document_viewer.dart';
import 'add_family_member_page.dart';

class RenterDetailsPage extends ConsumerWidget {
  final String propertyId;
  final String unitId;
  final String renterId;

  const RenterDetailsPage({
    super.key,
    required this.propertyId,
    required this.unitId,
    required this.renterId,
  });

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openDocument(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => DocumentViewerPage(url: url, title: title),
        transitionsBuilder: (_, animation, _, child) => child,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Widget _buildDocIcon(Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.picture_as_pdf, color: Color(0xFF6366F1), size: 20),
    );
  }

  Future<void> _showVacateDialog(
    BuildContext context,
    WidgetRef ref,
    Renter renter,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vacate Renter?'),
        content: Text(
          'Are you sure you want to mark ${renter.name} as vacated? This will move them to history and mark the unit as vacant.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm Vacate'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final repository = ref.read(renterRepositoryProvider);
        await repository.vacateRenter(
          propertyId,
          unitId,
          renterId,
          DateTime.now(),
        );
        if (context.mounted) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              duration: const Duration(minutes: 5),
              content: const Text('Renter marked as vacated.'),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: '✕',
                textColor: Colors.white,
                onPressed: () => messenger.hideCurrentSnackBar(),
              ),
            ),
          );
          context.pop(); // Return to unit details
        }
      } catch (e) {
        if (context.mounted) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              duration: const Duration(minutes: 5),
              content: Text('Error vacating: $e'),
              action: SnackBarAction(
                label: '✕',
                textColor: Colors.white,
                onPressed: () => messenger.hideCurrentSnackBar(),
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteRenter(
    BuildContext context,
    WidgetRef ref,
    Renter renter,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Renter?',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'This will PERMANENTLY delete the renter, their photos, all uploaded documents, and all associated bills/invoices. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;

      // Show progress dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Deleting renter and related data...'),
            ],
          ),
        ),
      );

      try {
        // 1. Delete Images from Cloudinary
        final List<String> urlsToDelete = [];
        if (renter.photoUrl != null) urlsToDelete.add(renter.photoUrl!);

        for (final member in renter.familyMembers) {
          if (member.photoUrl != null) urlsToDelete.add(member.photoUrl!);
          for (final doc in member.documents) {
            urlsToDelete.add(doc.url);
          }
        }

        for (final doc in renter.documents) {
          urlsToDelete.add(doc.url);
        }

        for (final url in urlsToDelete) {
          await CloudinaryService.deleteImage(url);
        }

        // 2. Delete from Database (Renter, Invoices, Unit Status)
        final repository = ref.read(renterRepositoryProvider);
        await repository.deleteRenter(propertyId, unitId, renter.id);

        if (context.mounted) {
          Navigator.pop(context); // Close progress dialog
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              duration: const Duration(minutes: 5),
              content: const Text('Renter and all related data deleted.'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: '✕',
                textColor: Colors.white,
                onPressed: () => messenger.hideCurrentSnackBar(),
              ),
            ),
          );
          context.pop(); // Return to unit details
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context); // Close progress dialog
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              duration: const Duration(minutes: 5),
              content: Text('Error deleting: $e'),
              action: SnackBarAction(
                label: '✕',
                textColor: Colors.white,
                onPressed: () => messenger.hideCurrentSnackBar(),
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _navigateToAddFamilyMember(
    BuildContext context,
    WidgetRef ref,
    Renter renter,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddFamilyMemberPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      if (!context.mounted) return;
      _saveFamilyMember(context, ref, renter, result, null);
    }
  }

  Future<void> _editFamilyMember(
    BuildContext context,
    WidgetRef ref,
    Renter renter,
    FamilyMember member,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFamilyMemberPage(initialMember: member),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      if (!context.mounted) return;
      _saveFamilyMember(context, ref, renter, result, member);
    }
  }

  Future<void> _deleteFamilyMember(
    BuildContext context,
    WidgetRef ref,
    Renter renter,
    FamilyMember member,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Family Member'),
        content: Text('Remove "${member.name}" from family members?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(minutes: 5),
        content: const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Removing family member...'),
          ],
        ),
        action: SnackBarAction(label: '✕', textColor: Colors.white, onPressed: () => messenger.hideCurrentSnackBar()),
      ),
    );

    try {
      // Clean up Cloudinary resources
      if (member.photoUrl != null) {
        await CloudinaryService.deleteImage(member.photoUrl!);
      }
      for (final doc in member.documents) {
        if (doc.url.startsWith('http')) {
          await CloudinaryService.deleteImage(doc.url);
        }
      }

      final updatedMembers = List<FamilyMember>.from(renter.familyMembers)..remove(member);
      final repository = ref.read(renterRepositoryProvider);
      await repository.updateRenter(
        propertyId,
        unitId,
        renter.copyWith(familyMembers: updatedMembers),
      );
      ref.invalidate(renterFutureProvider(renterId));

      messenger.hideCurrentSnackBar();

      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text('"${member.name}" removed'),
            action: SnackBarAction(label: '✕', textColor: Colors.white, onPressed: () => messenger.hideCurrentSnackBar()),
          ),
        );
      }
    } catch (e) {
      messenger.hideCurrentSnackBar();
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text('Error removing: $e'),
            action: SnackBarAction(label: '✕', textColor: Colors.white, onPressed: () => messenger.hideCurrentSnackBar()),
          ),
        );
      }
    }
  }

  Future<void> _saveFamilyMember(
    BuildContext context,
    WidgetRef ref,
    Renter renter,
    Map<String, dynamic> result,
    FamilyMember? oldMember,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(minutes: 5),
        content: const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Saving family member...'),
          ],
        ),
        action: SnackBarAction(label: '✕', textColor: Colors.white, onPressed: () => messenger.hideCurrentSnackBar()),
      ),
    );

    try {
      var member = result['member'] as FamilyMember;
      final photoFile = result['photoFile'] as XFile?;
      final documentFiles = result['documentFiles'] as List<XFile?>;
      final List<String> uploadErrors = [];

      // Delete old Cloudinary resources before replacing
      if (oldMember != null) {
        if (photoFile != null && oldMember.photoUrl != null) {
          await CloudinaryService.deleteImage(oldMember.photoUrl!);
        }
        for (int i = 0; i < oldMember.documents.length && i < documentFiles.length; i++) {
          if (documentFiles[i] != null && oldMember.documents[i].url.startsWith('http')) {
            await CloudinaryService.deleteImage(oldMember.documents[i].url);
          }
        }
      }

      // 1. Upload photo if new
      if (photoFile != null) {
        final url = await CloudinaryService.uploadImage(photoFile);
        if (url != null) {
          member = member.copyWith(photoUrl: url);
        } else {
          uploadErrors.add('Failed to upload photo');
        }
      }

      // 2. Upload documents if new
      final updatedDocs = <RenterDocument>[];
      for (int i = 0; i < member.documents.length; i++) {
        var doc = member.documents[i];
        if (i < documentFiles.length && documentFiles[i] != null) {
          final url = await CloudinaryService.uploadImage(documentFiles[i]!);
          if (url != null) {
            doc = doc.copyWith(url: url);
          } else {
            uploadErrors.add('Failed to upload document "${doc.title}"');
          }
        }
        if (doc.url.startsWith('http')) {
          updatedDocs.add(doc);
        }
      }
      member = member.copyWith(documents: updatedDocs);

      // 3. Update Renter in Firestore
      final List<FamilyMember> updatedMembers = List.from(renter.familyMembers);
      if (oldMember != null) {
        final index = updatedMembers.indexOf(oldMember);
        if (index != -1) {
          updatedMembers[index] = member;
        }
      } else {
        updatedMembers.add(member);
      }

      final repository = ref.read(renterRepositoryProvider);
      await repository.updateRenter(
        propertyId,
        unitId,
        renter.copyWith(familyMembers: updatedMembers),
      );
      ref.invalidate(renterFutureProvider(renterId));

      messenger.hideCurrentSnackBar();

      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text(
              uploadErrors.isNotEmpty
                  ? 'Saved with ${uploadErrors.length} upload error(s)'
                  : 'Family member saved successfully!',
            ),
            backgroundColor: uploadErrors.isNotEmpty
                ? const Color(0xFFF59E0B)
                : null,
            action: SnackBarAction(
              label: '✕',
              textColor: Colors.white,
              onPressed: () => messenger.hideCurrentSnackBar(),
            ),
          ),
        );
      }
    } catch (e) {
      messenger.hideCurrentSnackBar();
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text('Error saving: $e'),
            action: SnackBarAction(
              label: '✕',
              textColor: Colors.white,
              onPressed: () => messenger.hideCurrentSnackBar(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final renterAsync = ref.watch(renterFutureProvider(renterId));

    return renterAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Error: $err')),
      ),
      data: (renter) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final primaryColor = const Color(0xFF6366F1);

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: isDark
                ? const Color(0xFF0F172A)
                : const Color(0xFFF8FAFC),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: MaxWidthContainer(
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  renter.name,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () => context.push(
                      '/landlord/properties/$propertyId/units/$unitId/edit-renter/${renter.id}',
                    ),
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    tooltip: 'Edit Renter',
                  ),
                  IconButton(
                    onPressed: () => _deleteRenter(context, ref, renter),
                    icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    tooltip: 'Delete Renter',
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TabBar(
                      tabs: const [
                        Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.info_outline, size: 16), SizedBox(width: 4), Text('Info')])),
                        Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.description_outlined, size: 16), SizedBox(width: 4), Text('Docs')])),
                        Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.people_outline, size: 16), SizedBox(width: 4), Text('Family')])),
                        Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.receipt_outlined, size: 16), SizedBox(width: 4), Text('Billing')])),
                      ],
                      labelColor: primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: primaryColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: MaxWidthContainer(
            child: TabBarView(
              children: [
                _buildInfoTab(context, ref, renter, isDark, primaryColor),
                _buildDocumentsTab(context, ref, renter, isDark, primaryColor),
                _buildFamilyTab(context, ref, renter, isDark, primaryColor),
                _buildBillingTab(context, ref, renter, isDark, primaryColor),
              ],
            ),
          ),
        ),
      );
      },
    );
  }

  Widget _buildInfoTab(
    BuildContext context,
    WidgetRef ref,
    Renter renter,
    bool isDark,
    Color primaryColor,
  ) {
    final invoicesAsync = ref.watch(invoicesStreamProvider((propertyId, unitId)));

    return invoicesAsync.when(
      data: (invoices) {
        final totalPaid = invoices
            .where((i) => i.status == 'paid')
            .fold(0.0, (sum, i) => sum + i.totalAmount);
        final totalDue = invoices
            .where((i) => i.status != 'paid')
            .fold(0.0, (sum, i) => sum + i.totalAmount);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(renter, isDark, primaryColor),
              const SizedBox(height: 24),
              _sectionHeader('Profile Information'),
              _infoCard([
                _infoRow(Icons.badge_outlined, 'NID Number', renter.nid),
                _infoRow(
                  Icons.calendar_today_outlined,
                  'Move-in Date',
                  DateFormat('dd MMMM yyyy').format(renter.moveInDate),
                ),
                _infoRow(Icons.phone_outlined, 'Phone', renter.phone),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      _compactActionButton(Icons.phone, 'Call', Colors.green, () => _launchURL('tel:${renter.phone}')),
                      const SizedBox(width: 8),
                      _compactActionButton(Icons.message, 'SMS', Colors.orange, () => _launchURL('sms:${renter.phone}')),
                      if (renter.email != null) ...[
                        const SizedBox(width: 8),
                        _compactActionButton(Icons.email, 'Email', Colors.blue, () => _launchURL('mailto:${renter.email}')),
                      ],
                      const SizedBox(width: 8),
                      _compactActionButton(Icons.receipt_long, 'Bill', primaryColor, () => context.push(
                        '/landlord/properties/$propertyId/units/$unitId/add-bill',
                      )),
                    ],
                  ),
                ),
              ], isDark),
              const SizedBox(height: 24),
              _sectionHeader('Financial Details'),
              _infoCard([
                _infoRow(Icons.account_balance_wallet_outlined, 'Advance Deposit', '৳${renter.advanceDeposit}', isBoldValue: true),
                _infoRow(Icons.check_circle_outline, 'Total Paid', '৳$totalPaid', isBoldValue: true),
                _infoRow(Icons.error_outline, 'Total Due', '৳$totalDue', isBoldValue: true),
              ], isDark),
              if (renter.landlordNotes != null && renter.landlordNotes!.isNotEmpty) ...[
                const SizedBox(height: 24),
                _sectionHeader('Landlord Notes'),
                _infoCard([
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      renter.landlordNotes!,
                      style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]),
                    ),
                  ),
                ], isDark),
              ],
              const SizedBox(height: 24),
              _sectionHeader('Actions'),
              _infoCard([
                ElevatedButton.icon(
                  onPressed: () => _showVacateDialog(context, ref, renter),
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text('Vacate Renter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withValues(alpha: 0.1),
                    foregroundColor: Colors.red,
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ], isDark),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildProfileCard(Renter renter, bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: primaryColor.withValues(alpha: 0.1),
              image: renter.photoUrl != null
                  ? DecorationImage(image: NetworkImage(renter.photoUrl!), fit: BoxFit.cover)
                  : null,
            ),
            child: renter.photoUrl == null
                ? Icon(Icons.person, size: 35, color: primaryColor)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  renter.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    renter.occupation ?? 'Resident',
                    style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab(
    BuildContext context,
    WidgetRef ref,
    Renter renter,
    bool isDark,
    Color primaryColor,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionHeader('Documents & IDs'),
              if (renter.isActive)
                TextButton.icon(
                  onPressed: () => _addDocument(context, ref, renter),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Document'),
                  style: TextButton.styleFrom(foregroundColor: primaryColor),
                ),
            ],
          ),
          if (renter.documents.isEmpty)
            _infoCard([
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No documents uploaded', style: TextStyle(color: Colors.grey)),
                ),
              ),
            ], isDark)
          else
            _infoCard(
              renter.documents
                  .asMap()
                  .entries
                  .map((entry) {
                    final doc = entry.value;
                    final index = entry.key;
                    return Material(
                      type: MaterialType.transparency,
                      child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: isImageUrl(doc.url)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      doc.url,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => _buildDocIcon(primaryColor),
                                    ),
                                  )
                                : _buildDocIcon(primaryColor),
                            title: Text(doc.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Text(
                              'Uploaded: ${DateFormat('dd MMM yyyy').format(doc.uploadedAt)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18),
                                  color: Colors.red,
                                  onPressed: () => _deleteDocument(context, ref, renter, doc, index),
                                ),
                                const Icon(Icons.chevron_right, size: 20),
                              ],
                            ),
                            onTap: () => _openDocument(context, doc.url, doc.title),
                          ),
                        );
                  })
                  .toList(),
              isDark,
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _addDocument(
    BuildContext context,
    WidgetRef ref,
    Renter renter,
  ) async {
    RenterDocument? capturedDoc;
    XFile? capturedFile;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ProfessionalDocumentDialog(
        onAdd: (doc, file) {
          capturedDoc = doc;
          capturedFile = file;
        },
      ),
    );

    if (capturedDoc == null || capturedFile == null || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(minutes: 5),
        content: const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Uploading document...'),
          ],
        ),
        action: SnackBarAction(label: '✕', textColor: Colors.white, onPressed: () => messenger.hideCurrentSnackBar()),
      ),
    );

    try {
      final url = await CloudinaryService.uploadImage(capturedFile!);

      messenger.hideCurrentSnackBar();

      if (url == null) {
        if (context.mounted) {
          messenger.showSnackBar(
            SnackBar(
              duration: const Duration(minutes: 5),
              content: const Text('Failed to upload document. Please try again.'),
              action: SnackBarAction(label: '✕', textColor: Colors.white, onPressed: () => messenger.hideCurrentSnackBar()),
            ),
          );
        }
        return;
      }

      final uploadedDoc = capturedDoc!.copyWith(url: url);
      final repository = ref.read(renterRepositoryProvider);
      final updatedRenter = renter.copyWith(
        documents: [...renter.documents, uploadedDoc],
      );
      await repository.updateRenter(propertyId, unitId, updatedRenter);
      ref.invalidate(renterFutureProvider(renterId));

      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: const Text('Document added successfully!'),
            backgroundColor: const Color(0xFF10B981),
            action: SnackBarAction(label: '✕', textColor: Colors.white, onPressed: () => messenger.hideCurrentSnackBar()),
          ),
        );
      }
    } catch (e) {
      messenger.hideCurrentSnackBar();
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text('Error: $e'),
            action: SnackBarAction(label: '✕', textColor: Colors.white, onPressed: () => messenger.hideCurrentSnackBar()),
          ),
        );
      }
    }
  }

  Future<void> _deleteDocument(
    BuildContext context,
    WidgetRef ref,
    Renter renter,
    RenterDocument doc,
    int index,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Delete "${doc.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final updatedDocs = [...renter.documents]..removeAt(index);
    final repository = ref.read(renterRepositoryProvider);
    final updatedRenter = renter.copyWith(documents: updatedDocs);
    await repository.updateRenter(propertyId, unitId, updatedRenter);
    ref.invalidate(renterFutureProvider(renterId));

    await CloudinaryService.deleteImage(doc.url);

    if (context.mounted) {
      messenger.showSnackBar(
        SnackBar(
          duration: const Duration(minutes: 5),
          content: Text('"${doc.title}" deleted'),
          action: SnackBarAction(label: '✕', textColor: Colors.white, onPressed: () => messenger.hideCurrentSnackBar()),
        ),
      );
    }
  }

  Widget _buildFamilyTab(
    BuildContext context,
    WidgetRef ref,
    Renter renter,
    bool isDark,
    Color primaryColor,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionHeader('Family Members'),
              if (renter.isActive)
                TextButton.icon(
                  onPressed: () => _navigateToAddFamilyMember(context, ref, renter),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Member'),
                  style: TextButton.styleFrom(foregroundColor: primaryColor),
                ),
            ],
          ),
          if (renter.familyMembers.isEmpty)
            _infoCard([
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No family members listed', style: TextStyle(color: Colors.grey)),
                ),
              ),
            ], isDark)
          else
            _infoCard(
              renter.familyMembers
                  .map((member) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: primaryColor.withValues(alpha: 0.1),
                                    image: member.photoUrl != null
                                        ? DecorationImage(image: NetworkImage(member.photoUrl!), fit: BoxFit.cover)
                                        : null,
                                  ),
                                  child: member.photoUrl == null
                                      ? Icon(Icons.person_outline, color: primaryColor)
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                          if (member.isEmergencyContact) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Text('EMERGENCY', style: TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ],
                                      ),
                                      Text(
                                        member.relation,
                                        style: TextStyle(fontSize: 13, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                                if (renter.isActive) ...[
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 20),
                                    onPressed: () => _editFamilyMember(context, ref, renter, member),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                    onPressed: () => _deleteFamilyMember(context, ref, renter, member),
                                  ),
                                ],
                              ],
                            ),
                            if (member.documents.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: member.documents
                                      .map((doc) => Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: ActionChip(
                                              avatar: Icon(isImageUrl(doc.url) ? Icons.image_outlined : Icons.picture_as_pdf, size: 14),
                                              label: Text(doc.title, style: const TextStyle(fontSize: 11)),
                                              onPressed: () => _openDocument(context, doc.url, doc.title),
                        ),
                      ))
                  .toList(),

                                ),
                              ),
                            ],
                          ],
                        ),
                      ))
                  .toList(),
              isDark,
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBillingTab(
    BuildContext context,
    WidgetRef ref,
    Renter renter,
    bool isDark,
    Color primaryColor,
  ) {
    final invoicesAsync = ref.watch(invoicesStreamProvider((propertyId, unitId)));

    return invoicesAsync.when(
      data: (invoices) {
        final sorted = invoices.toList()..sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
        final totalPaid = sorted.where((i) => i.status == 'paid').fold<double>(0, (sum, i) => sum + i.totalAmount);
        final totalDue = sorted.where((i) => i.status != 'paid').fold<double>(0, (sum, i) => sum + i.totalAmount);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader('Financial Summary'),
              Row(
                children: [
                  Expanded(child: _compactSummaryCard(Icons.account_balance_wallet_outlined, 'Deposit', '৳${renter.advanceDeposit}', isDark)),
                  const SizedBox(width: 10),
                  Expanded(child: _compactSummaryCard(Icons.check_circle_outline, 'Paid', '৳$totalPaid', isDark)),
                  const SizedBox(width: 10),
                  Expanded(child: _compactSummaryCard(Icons.error_outline, 'Due', '৳$totalDue', isDark)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionHeader('Billing History'),
                  if (renter.isActive)
                    TextButton.icon(
                      onPressed: () => context.push(
                        '/landlord/properties/$propertyId/units/$unitId/add-bill',
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('New Bill'),
                      style: TextButton.styleFrom(foregroundColor: primaryColor),
                    ),
                ],
              ),
              if (sorted.isEmpty)
                _infoCard([
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text('No billing history available', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                ], isDark)
              else ...[
                _infoCard(
                  sorted.map((invoice) {
                    final isPaid = invoice.status == 'paid';
                    return InkWell(
                      onTap: () => context.push(
                        '/landlord/properties/$propertyId/units/$unitId/invoice-details/${invoice.id}',
                      ),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: (isPaid ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isPaid ? Icons.check_circle_outline : Icons.pending_actions,
                                color: isPaid ? Colors.green : Colors.orange,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(invoice.monthYear, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text(
                                    DateFormat('dd MMM yyyy').format(invoice.createdAt ?? DateTime.now()),
                                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('৳${invoice.totalAmount}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                                Text(
                                  invoice.status.toUpperCase(),
                                  style: TextStyle(
                                    color: isPaid ? Colors.green : Colors.orange,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  isDark,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(
                      '/landlord/properties/$propertyId/units/$unitId/bill-history',
                    ),
                    child: const Text('See more →'),
                  ),
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }





  Widget _compactActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _infoCard(List<Widget> children, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.1),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _compactSummaryCard(IconData icon, String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    bool isBoldValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
