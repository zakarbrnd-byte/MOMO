import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/mock/mock_playdate_data_source.dart';
import '../data/datasources/mock/mock_post_data_source.dart';
import '../data/datasources/playdate_data_source.dart';
import '../data/datasources/post_data_source.dart';
import 'playdate_repository.dart';
import 'playdate_repository_impl.dart';
import 'post_repository.dart';
import 'post_repository_impl.dart';

/// Default: [MockPlaydateDataSource].
/// Later: override with SupabasePlaydateDataSource.
final playdateDataSourceProvider = Provider<PlaydateDataSource>((ref) {
  return MockPlaydateDataSource();
});

/// Default: [MockPostDataSource].
/// Later: override with SupabasePostDataSource.
final postDataSourceProvider = Provider<PostDataSource>((ref) {
  return MockPostDataSource();
});

/// Wires [PlaydateRepositoryImpl] → active [PlaydateDataSource].
/// Providers depend on this — never on [playdateDataSourceProvider] directly.
final playdateRepositoryProvider = Provider<PlaydateRepository>((ref) {
  return PlaydateRepositoryImpl(ref.watch(playdateDataSourceProvider));
});

/// Wires [PostRepositoryImpl] → active [PostDataSource].
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl(ref.watch(postDataSourceProvider));
});
