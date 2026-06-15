import '/features/billing/pages/invoice_view_page.dart';
import '/features/billing/models/invoice.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'features/auth/pages/login_page.dart';
import 'features/billing/pages/add_bill_page.dart';
import 'features/billing/pages/invoice_details_page.dart';
import 'features/property/pages/add_unit_page.dart';
import 'features/property/pages/add_property_page.dart';
import 'features/renters/pages/add_renter_page.dart';
import 'features/billing/pages/billing_history_page.dart';
import 'features/property/pages/unit_details_page.dart';
import 'features/property/pages/property_page.dart';
import 'features/property/pages/property_details_page.dart';
import 'features/dashboard/pages/home_page.dart';
import 'features/auth/pages/profile_page.dart';
import 'features/renters/pages/renter_history_page.dart';
import 'features/landing/pages/landing_page.dart';
import 'features/admin/pages/admin_panel_page.dart';
import 'features/onboarding/pages/landlord_request_page.dart';
import 'features/landing/pages/add_listing_page.dart';
import 'features/landing/pages/rent_post_detail_page.dart';
import 'features/landing/models/rent_post.dart';
import 'features/renters/pages/renter_details_page.dart';
import 'shared/widgets/app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Wraps [child] in a [Title] widget so the browser tab reflects the page.
/// Falls back to "Bari Vara" as the site name suffix.
Page<void> _page(String title, Widget child) {
  return NoTransitionPage(
    child: Title(
      title: '$title | Bari Vara',
      color: const Color(0xFF6366F1),
      child: child,
    ),
  );
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  // --- AUTH GUARD ---
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isProtectedRoute = state.matchedLocation.startsWith('/landlord');

    if (isProtectedRoute && !isLoggedIn) {
      return '/login';
    }
    return null;
  },
  routes: [
    // --- PUBLIC ROUTES ---
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => _page('Home', const LandingPage()),
    ),
    GoRoute(
      path: '/request-landlord',
      pageBuilder: (context, state) =>
          _page('Become a Landlord', const LandlordRequestPage()),
    ),
    GoRoute(
      path: '/admin',
      pageBuilder: (context, state) =>
          _page('Admin Panel', const AdminPanelPage()),
    ),
    GoRoute(
      path: '/profile-view',
      pageBuilder: (context, state) =>
          _page('My Profile', const ProfilePage()),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _page('Sign In', const LoginPage()),
    ),
    GoRoute(
      path: '/post/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        final post = state.extra as RentPost?;
        return _page(
          'Rent Post',
          RentPostDetailPage(postId: id, initialPost: post),
        );
      },
    ),
    GoRoute(
      path: '/invoice/:invoiceId',
      pageBuilder: (context, state) {
        final invoiceId = state.pathParameters['invoiceId']!;
        return _page('Invoice', InvoiceViewPage(invoiceId: invoiceId));
      },
    ),

    // --- PROTECTED LANDLORD ROUTES (require auth) ---
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/landlord/dashboard',
              pageBuilder: (context, state) =>
                  _page('Dashboard', const HomePage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/landlord/properties',
              pageBuilder: (context, state) =>
                  _page('My Properties', const HomeManagementPage()),
              routes: [
                GoRoute(
                  path: 'add-property',
                  pageBuilder: (context, state) =>
                      _page('Add Property', const AddPropertyPage()),
                ),
                GoRoute(
                  path: 'edit-property/:propertyId',
                  pageBuilder: (context, state) {
                    final propertyId = state.pathParameters['propertyId']!;
                    return _page(
                      'Edit Property',
                      AddPropertyPage(propertyId: propertyId),
                    );
                  },
                ),
                GoRoute(
                  path: ':propertyId/units',
                  pageBuilder: (context, state) {
                    final propertyId = state.pathParameters['propertyId']!;
                    return _page(
                      'Property Details',
                      HomeOverviewPage(propertyId: propertyId),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'add-unit',
                      pageBuilder: (context, state) {
                        final propertyId = state.pathParameters['propertyId']!;
                        return _page(
                          'Add Unit',
                          AddUnitPage(propertyId: propertyId),
                        );
                      },
                    ),
                    GoRoute(
                      path: ':unitId/edit-unit',
                      pageBuilder: (context, state) {
                        final propertyId = state.pathParameters['propertyId']!;
                        final unitId = state.pathParameters['unitId']!;
                        return _page(
                          'Edit Unit',
                          AddUnitPage(
                            propertyId: propertyId,
                            unitId: unitId,
                          ),
                        );
                      },
                    ),
                    GoRoute(
                      path: ':unitId',
                      pageBuilder: (context, state) {
                        final propertyId = state.pathParameters['propertyId']!;
                        final unitId = state.pathParameters['unitId']!;
                        final tab = state.uri.queryParameters['tab'];
                        final tabLabel = tab == 'billing'
                            ? 'Billing'
                            : tab == 'post'
                                ? 'Post'
                                : 'Renter';
                        return _page(
                          'Unit · $tabLabel',
                          UnitDetailsPage(
                            propertyId: propertyId,
                            unitId: unitId,
                            initialTab: tab,
                          ),
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'add-listing',
                          pageBuilder: (context, state) {
                            final propertyId =
                                state.pathParameters['propertyId']!;
                            final unitId = state.pathParameters['unitId']!;
                            return _page(
                              'Add Listing',
                              AddListingPage(
                                propertyId: propertyId,
                                unitId: unitId,
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'edit-listing/:postId',
                          pageBuilder: (context, state) {
                            final postId = state.pathParameters['postId']!;
                            final propertyId =
                                state.pathParameters['propertyId']!;
                            final unitId = state.pathParameters['unitId']!;
                            return _page(
                              'Edit Listing',
                              AddListingPage(
                                initialPostId: postId,
                                propertyId: propertyId,
                                unitId: unitId,
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'add-renter',
                          pageBuilder: (context, state) {
                            final propertyId =
                                state.pathParameters['propertyId']!;
                            final unitId = state.pathParameters['unitId']!;
                            return _page(
                              'Add Renter',
                              AddRenterPage(
                                propertyId: propertyId,
                                unitId: unitId,
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'edit-renter/:renterId',
                          pageBuilder: (context, state) {
                            final propertyId =
                                state.pathParameters['propertyId']!;
                            final unitId = state.pathParameters['unitId']!;
                            final renterId =
                                state.pathParameters['renterId']!;
                            return _page(
                              'Edit Renter',
                              AddRenterPage(
                                propertyId: propertyId,
                                unitId: unitId,
                                renterId: renterId,
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'renter-history',
                          pageBuilder: (context, state) {
                            final propertyId =
                                state.pathParameters['propertyId']!;
                            final unitId = state.pathParameters['unitId']!;
                            return _page(
                              'Renter History',
                              RenterHistoryPage(
                                propertyId: propertyId,
                                unitId: unitId,
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'renter-details/:renterId',
                          pageBuilder: (context, state) {
                            final propertyId =
                                state.pathParameters['propertyId']!;
                            final unitId = state.pathParameters['unitId']!;
                            final renterId =
                                state.pathParameters['renterId']!;
                            return _page(
                              'Renter Details',
                              RenterDetailsPage(
                                propertyId: propertyId,
                                unitId: unitId,
                                renterId: renterId,
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'add-bill',
                          pageBuilder: (context, state) {
                            final propertyId =
                                state.pathParameters['propertyId']!;
                            final unitId = state.pathParameters['unitId']!;
                            return _page(
                              'Generate Bill',
                              AddBillPage(
                                propertyId: propertyId,
                                unitId: unitId,
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'edit-bill/:invoiceId',
                          pageBuilder: (context, state) {
                            final propertyId =
                                state.pathParameters['propertyId']!;
                            final unitId = state.pathParameters['unitId']!;
                            final invoiceId =
                                state.pathParameters['invoiceId']!;
                            final invoice = state.extra as Invoice?;
                            return _page(
                              'Edit Bill',
                              AddBillPage(
                                propertyId: propertyId,
                                unitId: unitId,
                                initialInvoiceId: invoiceId,
                                initialInvoice: invoice,
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'invoice-details/:invoiceId',
                          pageBuilder: (context, state) {
                            final propertyId =
                                state.pathParameters['propertyId']!;
                            final unitId = state.pathParameters['unitId']!;
                            final invoiceId =
                                state.pathParameters['invoiceId']!;
                            return _page(
                              'Invoice Details',
                              InvoiceDetailsPage(
                                propertyId: propertyId,
                                unitId: unitId,
                                invoiceId: invoiceId,
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'bill-history',
                          pageBuilder: (context, state) {
                            final propertyId =
                                state.pathParameters['propertyId']!;
                            final unitId = state.pathParameters['unitId']!;
                            return _page(
                              'Billing History',
                              BillingHistoryPage(
                                propertyId: propertyId,
                                unitId: unitId,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);