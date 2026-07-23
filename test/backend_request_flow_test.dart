import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/core/result/result.dart';
import 'package:momo/data/datasources/mock/mock_playdate_data_source.dart';
import 'package:momo/data/mock_user.dart';
import 'package:momo/models/playdate.dart';
import 'package:momo/repositories/playdate_repository.dart';
import 'package:momo/repositories/repository_providers.dart';

import 'support/test_overrides.dart';

/// Minimal fake used only to prove repository DI overrides work.
class _FakeEmptyPlaydateRepository implements PlaydateRepository {
  @override
  Future<List<Playdate>> load() async => const [];

  @override
  Future<Result<bool>> create({
    required String title,
    required String date,
    required String time,
    required String location,
    required String childAge,
    required String description,
    required String creatorId,
    String? hostName,
    int? maxParticipants,
  }) async =>
      const Success(true);

  @override
  Future<Result<bool>> update(Playdate playdate) async => const Success(true);

  @override
  Future<Result<bool>> delete(String playdateId, String requestingUserId) async =>
      const Success(true);

  @override
  Future<Result<bool>> join(String playdateId, String userId) async =>
      const Success(true);

  @override
  Future<Result<bool>> leave(String playdateId, String userId) async =>
      const Success(true);
}

void main() {
  group('Result', () {
    test('success and failure helpers', () {
      final ok = Result.success(true);
      final bad = Result.failure('Nope');

      expect(ok.isSuccess, isTrue);
      expect(bad.isFailure, isTrue);
      expect(ok.dataOrNull, isTrue);
      expect(bad.errorOrNull, 'Nope');
      expect(
        ok.when(success: (_) => 'ok', failure: (_) => 'fail'),
        'ok',
      );
    });
  });

  group('PlaydateRepository via DI', () {
    test('default providers load seeded playdates', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final list = await container.read(playdateRepositoryProvider).load();
      expect(list, isNotEmpty);
    });

    test('join owner fails with Result.failure', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result =
          await container.read(playdateRepositoryProvider).join('pd5', currentUserId);
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, contains('Owners'));
    });

    test('overridePlaydateRepository replaces implementation', () async {
      final container = ProviderContainer(
        overrides: [
          overridePlaydateRepository(_FakeEmptyPlaydateRepository()),
        ],
      );
      addTearDown(container.dispose);

      final list = await container.read(playdateRepositoryProvider).load();
      expect(list, isEmpty);
    });

    test('overridePlaydateDataSource feeds repository impl', () async {
      final container = ProviderContainer(
        overrides: [
          overridePlaydateDataSource(MockPlaydateDataSource(seed: const [])),
        ],
      );
      addTearDown(container.dispose);

      final list = await container.read(playdateRepositoryProvider).load();
      expect(list, isEmpty);
    });
  });
}
