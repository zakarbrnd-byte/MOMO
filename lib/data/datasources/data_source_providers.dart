import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mock/mock_playdate_data_source.dart';
import 'mock/mock_post_data_source.dart';
import 'mock/mock_profile_data_source.dart';
import 'mock/mock_user_data_source.dart';
import 'playdate_data_source.dart';
import 'post_data_source.dart';
import 'profile_data_source.dart';
import 'user_data_source.dart';

/// Composition root for playdate persistence.
///
/// Default: [MockPlaydateDataSource].
/// Future: `overrideWithValue(SupabasePlaydateDataSource(...))`.
final playdateDataSourceProvider = Provider<PlaydateDataSource>((ref) {
  return MockPlaydateDataSource();
});

/// Composition root for post persistence.
final postDataSourceProvider = Provider<PostDataSource>((ref) {
  return MockPostDataSource();
});

/// Composition root for profile tab data.
final profileDataSourceProvider = Provider<ProfileDataSource>((ref) {
  return MockProfileDataSource();
});

/// Composition root for the signed-in user.
final userDataSourceProvider = Provider<UserDataSource>((ref) {
  return MockUserDataSource();
});
