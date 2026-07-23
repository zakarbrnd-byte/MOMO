import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/data_source_providers.dart';
import 'playdate_repository.dart';
import 'playdate_repository_impl.dart';
import 'post_repository.dart';
import 'post_repository_impl.dart';
import 'profile_repository.dart';
import 'profile_repository_impl.dart';
import 'user_repository.dart';
import 'user_repository_impl.dart';

export '../data/datasources/data_source_providers.dart';

/// Exposes [PlaydateRepository] (interface only to feature providers).
final playdateRepositoryProvider = Provider<PlaydateRepository>((ref) {
  return PlaydateRepositoryImpl(ref.watch(playdateDataSourceProvider));
});

/// Exposes [PostRepository] (interface only to feature providers).
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl(ref.watch(postDataSourceProvider));
});

/// Exposes [ProfileRepository] for the Profile tab.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileDataSourceProvider));
});

/// Exposes [UserRepository] for the signed-in user.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(userDataSourceProvider));
});
