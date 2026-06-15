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

  Future<void> _saveFamilyMember(
    BuildContext context,
    WidgetRef ref,
    Renter renter,
    Map<String, dynamic> result,
    FamilyMember? oldMember,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Saving family member...'),
          ],
        ),
      ),
    );

    try {
      var member = result['member'] as FamilyMember;
      final photoFile = result['photoFile'] as XFile?;
      final documentFiles = result['documentFiles'] as List<XFile?>;

      // 1. Upload photo if new
      if (photoFile != null) {
        final url = await CloudinaryService.uploadImage(photoFile);
        if (url != null) member = member.copyWith(photoUrl: url);
      }

      // 2. Upload documents if new
      final updatedDocs = <RenterDocument>[];
      for (int i = 0; i < member.documents.length; i++) {
        var doc = member.documents[i];
        if (i < documentFiles.length && documentFiles[i] != null) {
          final url = await CloudinaryService.uploadImage(documentFiles[i]!);
          if (url != null) doc = doc.copyWith(url: url);
        }
        updatedDocs.add(doc);
      }
      member = member.copyWith(documents: updatedDocs);

      // 3. Update Renter in Firestore
      final List<FamilyMember> updatedMembers = List.from(renter.familyMembers);
      if (oldMember != null) {
        final index = updatedMembers.indexWhere(
          (m) => m.name == oldMember.name && m.relation == oldMember.relation,
        );
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

      if (context.mounted) {
        Navigator.pop(context); // Close progress
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: const Text('Family member saved successfully!'),
            action: SnackBarAction(
              label: '✕',
              textColor: Colors.white,
              onPressed: () => messenger.hideCurrentSnackBar(),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close progress
        final messenger = ScaffoldMessenger.of(context);
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

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF0F172A)
              : const Color(0xFFF8FAFC),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
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
                  'Renter Details',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                actions: const [SizedBox(width: 8)],
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: MaxWidthContainer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Builder(
                      builder: (context) {
                        final isDesktop = ResponsiveLayout.isDesktop(context);

                        final profileCard = Container(
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
                                      ? DecorationImage(
                                          image: NetworkImage(renter.photoUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: renter.photoUrl == null
                                    ? Icon(
                                        Icons.person,
                                        size: 35,
                                        color: primaryColor,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            renter.name,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: -0.5,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => context.push(
                                            '/landlord/properties/$propertyId/units/$unitId/edit-renter/${renter.id}',
                                          ),
                                          icon: Icon(
                                            Icons.edit_outlined,
                                            size: 20,
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                          ),
                                          tooltip: 'Edit Renter',
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              _deleteRenter(context, ref, renter),
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                          tooltip: 'Delete Renter',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        renter.occupation ?? 'Resident',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );

                        if (isDesktop) {
                          return Row(
                            children: [
                              Expanded(flex: 3, child: profileCard),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              profileCard,
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: MaxWidthContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Builder(
                      builder: (context) {
                        final isDesktop = ResponsiveLayout.isDesktop(context);
                        final invoicesAsync = ref.watch(
                          invoicesStreamProvider((propertyId, unitId)),
                        );

                        return invoicesAsync.when(
                          data: (invoices) {
                            final totalPaid = invoices
                                .where((i) => i.status == 'paid')
                                .fold(0.0, (sum, i) => sum + i.totalAmount);
                            final totalDue = invoices
                                .where((i) => i.status != 'paid')
                                .fold(0.0, (sum, i) => sum + i.totalAmount);

                            final leftColumn = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader('Profile Information'),
                                _infoCard([
                                  _infoRow(
                                    Icons.badge_outlined,
                                    'NID Number',
                                    renter.nid,
                                  ),
                                  _infoRow(
                                    Icons.calendar_today_outlined,
                                    'Move-in Date',
                                    DateFormat(
                                      'dd MMMM yyyy',
                                    ).format(renter.moveInDate),
                                  ),
                                  _infoRow(
                                    Icons.phone_outlined,
                                    'Phone',
                                    renter.phone,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        _compactActionButton(
                                          Icons.phone,
                                          'Call',
                                          Colors.green,
                                          () => _launchURL('tel:${renter.phone}'),
                                        ),
                                        const SizedBox(width: 8),
                                        _compactActionButton(
                                          Icons.message,
                                          'SMS',
                                          Colors.orange,
                                          () => _launchURL('sms:${renter.phone}'),
                                        ),
                                        if (renter.email != null) ...[
                                          const SizedBox(width: 8),
                                          _compactActionButton(
                                            Icons.email,
                                            'Email',
                                            Colors.blue,
                                            () => _launchURL('mailto:${renter.email}'),
                                          ),
                                        ],
                                        const SizedBox(width: 8),
                                        _compactActionButton(
                                          Icons.receipt_long,
                                          'Bill',
                                          primaryColor,
                                          () => context.push(
                                            '/landlord/properties/$propertyId/units/$unitId/add-bill',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ], isDark),
                                const SizedBox(height: 24),

                                if (renter.landlordNotes != null &&
                                    renter.landlordNotes!.isNotEmpty) ...[
                                  const SizedBox(height: 24),
                                  _sectionHeader('Landlord Notes'),
                                  _infoCard([
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        renter.landlordNotes!,
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.grey[300]
                                              : Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ], isDark),
                                ],
                                const SizedBox(height: 24),
                                _sectionHeader('Documents & IDs'),
                                if (renter.documents.isEmpty)
                                  _infoCard([
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          'No documents uploaded',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ], isDark)
                                else
                                  _infoCard(
                                    renter.documents
                                        .map(
                                          (doc) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            child: ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: primaryColor.withValues(
                                                    alpha: 0.1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.description,
                                                  color: Color(0xFF6366F1),
                                                  size: 20,
                                                ),
                                              ),
                                              title: Text(
                                                doc.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              subtitle: Text(
                                                'Uploaded: ${DateFormat('dd MMM yyyy').format(doc.uploadedAt)}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              trailing: IconButton(
                                                icon: const Icon(
                                                  Icons.open_in_new,
                                                  size: 18,
                                                ),
                                                onPressed: () =>
                                                    _launchURL(doc.url),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    isDark,
                                  ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _sectionHeader('Family Members'),
                                    if (renter.isActive)
                                      TextButton.icon(
                                        onPressed: () => _navigateToAddFamilyMember(
                                          context,
                                          ref,
                                          renter,
                                        ),
                                        icon: const Icon(Icons.add, size: 18),
                                        label: const Text('Add Member'),
                                        style: TextButton.styleFrom(
                                          foregroundColor: primaryColor,
                                        ),
                                      ),
                                  ],
                                ),
                                if (renter.familyMembers.isEmpty)
                                  _infoCard([
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          'No family members listed',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ], isDark)
                                else
                                  _infoCard(
                                    renter.familyMembers
                                        .map(
                                          (member) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 48,
                                                      width: 48,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        color: primaryColor
                                                            .withValues(alpha: 0.1),
                                                        image:
                                                            member.photoUrl != null
                                                            ? DecorationImage(
                                                                image: NetworkImage(
                                                                  member.photoUrl!,
                                                                ),
                                                                fit: BoxFit.cover,
                                                              )
                                                            : null,
                                                      ),
                                                      child: member.photoUrl == null
                                                          ? Icon(
                                                              Icons.person_outline,
                                                              color: primaryColor,
                                                            )
                                                          : null,
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                member.name,
                                                                style:
                                                                    const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize: 16,
                                                                    ),
                                                              ),
                                                              if (member
                                                                  .isEmergencyContact) ...[
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            6,
                                                                        vertical: 2,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .red
                                                                        .withValues(
                                                                          alpha:
                                                                              0.1,
                                                                        ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          4,
                                                                        ),
                                                                  ),
                                                                  child: const Text(
                                                                    'EMERGENCY',
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize: 9,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ],
                                                          ),
                                                          Text(
                                                            member.relation,
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color: isDark
                                                                  ? Colors.grey[400]
                                                                  : Colors
                                                                        .grey[600],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (renter.isActive)
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.edit_outlined,
                                                          size: 20,
                                                        ),
                                                        onPressed: () =>
                                                            _editFamilyMember(
                                                              context,
                                                              ref,
                                                              renter,
                                                              member,
                                                            ),
                                                      ),
                                                  ],
                                                ),
                                                if (member
                                                    .documents
                                                    .isNotEmpty) ...[
                                                  const SizedBox(height: 12),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: member.documents
                                                          .map(
                                                            (doc) => Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    right: 8,
                                                                  ),
                                                              child: ActionChip(
                                                                avatar: const Icon(
                                                                  Icons
                                                                      .description_outlined,
                                                                  size: 14,
                                                                ),
                                                                label: Text(
                                                                  doc.title,
                                                                  style:
                                                                      const TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                      ),
                                                                ),
                                                                onPressed: () =>
                                                                    _launchURL(
                                                                      doc.url,
                                                                    ),
                                                              ),
                                                            ),
                                                          )
                                                          .toList(),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    isDark,
                                  ),
                                const SizedBox(height: 24),
                                _sectionHeader('Actions'),
                                _infoCard([
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        _showVacateDialog(context, ref, renter),
                                    icon: const Icon(Icons.exit_to_app),
                                    label: const Text('Vacate Renter'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.withValues(
                                        alpha: 0.1,
                                      ),
                                      foregroundColor: Colors.red,
                                      elevation: 0,
                                      minimumSize: const Size(double.infinity, 56),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ], isDark),
                              ],
                            );

                            final rightColumn = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader('Financial Details'),
                                _infoCard([
                                  _infoRow(
                                    Icons.account_balance_wallet_outlined,
                                    'Advance Deposit',
                                    '৳${renter.advanceDeposit}',
                                    isBoldValue: true,
                                  ),
                                  _infoRow(
                                    Icons.check_circle_outline,
                                    'Total Paid',
                                    '৳$totalPaid',
                                    isBoldValue: true,
                                  ),
                                  _infoRow(
                                    Icons.error_outline,
                                    'Total Due',
                                    '৳$totalDue',
                                    isBoldValue: true,
                                  ),
                                ], isDark),
                                const SizedBox(height: 24),
                                _sectionHeader('Billing History'),
                                if (invoices.isEmpty)
                                  _infoCard([
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20),
                                        child: Text(
                                          'No billing history available',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ], isDark)
                                else ...[
                                  _infoCard(
                                    (invoices.toList()..sort(
                                          (a, b) => (b.createdAt ?? DateTime.now())
                                              .compareTo(
                                                a.createdAt ?? DateTime.now(),
                                              ),
                                        ))
                                        .take(5)
                                        .map((invoice) {
                                          final isPaid = invoice.status == 'paid';
                                          return InkWell(
                                            onTap: () => context.push(
                                              '/landlord/properties/$propertyId/units/$unitId/invoice-details/${invoice.id}',
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          (isPaid
                                                                  ? Colors.green
                                                                  : Colors.orange)
                                                              .withValues(alpha: 0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(12),
                                                    ),
                                                    child: Icon(
                                                      isPaid
                                                          ? Icons.check_circle_outline
                                                          : Icons.pending_actions,
                                                      color: isPaid
                                                          ? Colors.green
                                                          : Colors.orange,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          invoice.monthYear,
                                                          style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                            'dd MMM yyyy',
                                                          ).format(
                                                            invoice.createdAt ??
                                                                DateTime.now(),
                                                          ),
                                                          style: TextStyle(
                                                            color: Colors.grey[500],
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '৳${invoice.totalAmount}',
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w900,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      Text(
                                                        invoice.status.toUpperCase(),
                                                        style: TextStyle(
                                                          color: isPaid
                                                              ? Colors.green
                                                              : Colors.orange,
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
                                        })
                                        .toList(),
                                    isDark,
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () => context.push(
                                        '/landlord/properties/$propertyId/units/$unitId?tab=billing',
                                      ),
                                      child: const Text('See more →'),
                                    ),
                                  ),
                                ],
                              ],
                            );

                            return Column(
                              children: [
                                if (isDesktop)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 3, child: leftColumn),
                                      const SizedBox(width: 32),
                                      Expanded(flex: 2, child: rightColumn),
                                    ],
                                  )
                                else
                                  Column(
                                    children: [
                                      rightColumn,
                                      const SizedBox(height: 24),
                                      leftColumn,
                                    ],
                                  ),
                                const SizedBox(height: 40),
                              ],
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('Error: $e')),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
