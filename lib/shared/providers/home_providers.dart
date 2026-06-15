import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/property/models/unit.dart';
import '/features/billing/models/invoice.dart';
import '/features/property/models/property.dart';
import '/features/renters/models/renter.dart';
import '/features/landing/models/rent_post.dart';
import '/features/onboarding/models/landlord_request.dart';
import '/features/property/repositories/property_repository.dart';
import '/features/renters/repositories/renter_repository.dart';
import '/features/landing/repositories/listing_repository.dart';
import '/features/auth/models/app_user.dart';
import '/features/admin/repositories/admin_repository.dart';
import '/features/dashboard/repositories/dashboard_repository.dart';

final adminStatsProvider = StreamProvider<AdminStats>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return repository.watchAdminStats();
});

final allLandlordsProvider = StreamProvider<List<AppUser>>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return repository.watchAllLandlords();
});

final dashboardStatsProvider = StreamProvider.family<DashboardStats, String>((
  ref,
  ownerId,
) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.watchLandlordStats(ownerId);
});

final propertiesStreamProvider = StreamProvider.family<List<Property>, String>((
  ref,
  ownerId,
) {
  final repository = ref.watch(propertyRepositoryProvider);
  return repository.watchProperties(ownerId);
});

final propertyFutureProvider = FutureProvider.family<Property, String>((
  ref,
  propertyId,
) {
  final repository = ref.watch(propertyRepositoryProvider);
  return repository.getProperty(propertyId);
});

final unitsStreamProvider = StreamProvider.family<List<Unit>, String>((
  ref,
  propertyId,
) {
  final repository = ref.watch(propertyRepositoryProvider);
  return repository.watchUnits(propertyId);
});

final unitFutureProvider = FutureProvider.family<Unit, (String, String)>((
  ref,
  ids,
) async {
  final (propertyId, unitId) = ids;
  final repository = ref.watch(propertyRepositoryProvider);
  // We can just fetch all units and filter, or add a specific method to repository
  // For now, let's assume we can get it from the list or add getUnit to repository
  final units = await repository.watchUnits(propertyId).first;
  return units.firstWhere((u) => u.id == unitId);
});

// --- UPDATED FOR HIERARCHY ---
final rentersStreamProvider =
    StreamProvider.family<List<Renter>, (String, String)>((ref, ids) {
      final (propertyId, unitId) = ids;
      final repository = ref.watch(renterRepositoryProvider);
      return repository.watchActiveRenter(propertyId, unitId);
    });

final renterHistoryStreamProvider =
    StreamProvider.family<List<Renter>, (String, String)>((ref, ids) {
      final (propertyId, unitId) = ids;
      final repository = ref.watch(renterRepositoryProvider);
      return repository.watchRenterHistory(propertyId, unitId);
    });

final invoicesStreamProvider =
    StreamProvider.family<List<Invoice>, (String, String)>((ref, ids) {
      final (propertyId, unitId) = ids;
      final repository = ref.watch(renterRepositoryProvider);
      return repository.watchInvoices(propertyId, unitId);
    });

final propertyInvoicesStreamProvider =
    StreamProvider.family<List<Invoice>, String>((ref, propertyId) {
      final repository = ref.watch(renterRepositoryProvider);
      return repository.watchAllInvoices(propertyId);
    });

final allRentPostsStreamProvider = StreamProvider<List<RentPost>>((ref) {
  final repository = ref.watch(listingRepositoryProvider);
  return repository.watchAllRentPosts();
});

final pendingLandlordRequestsStreamProvider =
    StreamProvider<List<LandlordRequest>>((ref) {
      final repository = ref.watch(adminRepositoryProvider);
      return repository.watchPendingRequests();
    });

final invoiceFutureProvider = FutureProvider.family<Invoice, String>((
  ref,
  invoiceId,
) {
  final repository = ref.watch(renterRepositoryProvider);
  return repository.getInvoice(invoiceId);
});

final invoiceStreamProvider = StreamProvider.family<Invoice, String>((
  ref,
  invoiceId,
) {
  final repository = ref.watch(renterRepositoryProvider);
  return repository.watchInvoice(invoiceId);
});

final rentPostFutureProvider = FutureProvider.family<RentPost?, String>((
  ref,
  postId,
) {
  final repository = ref.watch(listingRepositoryProvider);
  return repository.getRentPost(postId);
});

final renterFutureProvider = FutureProvider.family<Renter, String>((
  ref,
  renterId,
) {
  final repository = ref.watch(renterRepositoryProvider);
  return repository.getRenter(renterId);
});
