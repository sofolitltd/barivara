import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barivara/features/auth/repositories/auth_repository.dart';
import 'package:barivara/features/auth/repositories/user_repository.dart';
import 'package:barivara/features/auth/models/app_user.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.watch(userRepositoryProvider).watchUser(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (e, st) => Stream.error(e),
  );
});

final userProvider = FutureProvider.family<AppUser?, String>((ref, uid) {
  return ref.watch(userRepositoryProvider).getUser(uid);
});
