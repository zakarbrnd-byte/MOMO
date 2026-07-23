import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../repositories/repository_providers.dart';

/// Reads a [Future] that completes synchronously (mock [SynchronousFuture]).
T _readSync<T>(Future<T> future) {
  late T value;
  var completed = false;
  future.then((result) {
    value = result;
    completed = true;
  });
  assert(
    completed,
    'UserRepository Futures must complete synchronously in the mock MVP.',
  );
  return value;
}

/// Single source for the active user.
///
/// Today: [UserRepository] → mock data source.
/// Later: auth session / Supabase user repository (same provider type).
final currentUserProvider = Provider<User>((ref) {
  return _readSync(ref.watch(userRepositoryProvider).getCurrentUser());
});
