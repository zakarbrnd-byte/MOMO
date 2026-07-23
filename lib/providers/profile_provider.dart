import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile.dart';
import '../repositories/repository_providers.dart';

T _readSync<T>(Future<T> future) {
  late T value;
  var completed = false;
  future.then((result) {
    value = result;
    completed = true;
  });
  assert(
    completed,
    'ProfileRepository Futures must complete synchronously in the mock MVP.',
  );
  return value;
}

/// Profile tab data via [ProfileRepository] (no mock imports in UI).
final profileProvider = Provider<Profile>((ref) {
  return _readSync(ref.watch(profileRepositoryProvider).load());
});
