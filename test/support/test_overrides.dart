import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/core/async/simulated_backend.dart';
import 'package:momo/data/datasources/playdate_data_source.dart';
import 'package:momo/data/datasources/post_data_source.dart';
import 'package:momo/repositories/playdate_repository.dart';
import 'package:momo/repositories/post_repository.dart';
import 'package:momo/repositories/repository_providers.dart';

/// Zero-latency backend simulation for widget tests.
class InstantSimulatedBackend extends SimulatedBackendNotifier {
  @override
  SimulatedBackendConfig build() =>
      const SimulatedBackendConfig(delay: Duration.zero);
}

/// Default overrides so create flows stay fast in tests.
List<Override> get testBackendOverrides => [
      simulatedBackendProvider.overrideWith(InstantSimulatedBackend.new),
    ];

/// Override the playdate repository (fake / stub for unit or widget tests).
Override overridePlaydateRepository(PlaydateRepository repository) {
  return playdateRepositoryProvider.overrideWithValue(repository);
}

/// Override the post repository.
Override overridePostRepository(PostRepository repository) {
  return postRepositoryProvider.overrideWithValue(repository);
}

/// Override the playdate data source (keeps [PlaydateRepositoryImpl] wiring).
Override overridePlaydateDataSource(PlaydateDataSource dataSource) {
  return playdateDataSourceProvider.overrideWithValue(dataSource);
}

/// Override the post data source.
Override overridePostDataSource(PostDataSource dataSource) {
  return postDataSourceProvider.overrideWithValue(dataSource);
}
