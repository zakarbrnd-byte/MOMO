import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/result/result.dart';
import '../models/playdate.dart';
import '../repositories/playdate_repository.dart';
import '../repositories/repository_providers.dart';
import 'current_user_provider.dart';

/// Reads a [Future] that completes synchronously (mock [SynchronousFuture]).
///
/// Real network repositories will require `async` provider methods instead.
T _readSync<T>(Future<T> future) {
  late T value;
  var completed = false;
  future.then((result) {
    value = result;
    completed = true;
  });
  assert(
    completed,
    'PlaydateRepository Futures must complete synchronously in the mock MVP.',
  );
  return value;
}

bool _ok(Result<bool> result) => result.isSuccess;

/// Playdate list as [AsyncValue] (feed load lifecycle).
///
/// Request path: UI → this provider → [PlaydateRepository] → data source.
/// Mutations that need Idle → Loading → Success | Error should run through
/// [MutationNotifier] (see `createPlaydateMutationProvider`).
class PlaydateNotifier extends AsyncNotifier<List<Playdate>> {
  PlaydateRepository get _repo => ref.watch(playdateRepositoryProvider);

  @override
  Future<List<Playdate>> build() => _repo.load();

  List<Playdate> get playdates => state.valueOrNull ?? const [];

  void _refresh() {
    state = AsyncData(_readSync(_repo.load()));
  }

  void addPlaydate(Playdate playdate) {
    _readSync(_repo.update(playdate));
    _refresh();
  }

  /// Creates a playdate owned by [hostUserId] (defaults to current user).
  /// Creator is NOT added to [Playdate.participantIds].
  void createPlaydate({
    required String title,
    required String date,
    required String time,
    required String location,
    required String childAge,
    required String description,
    String? hostName,
    String? hostUserId,
    int? maxParticipants,
  }) {
    final creatorId = hostUserId ?? ref.read(currentUserProvider).id;
    final result = _readSync(
      _repo.create(
        title: title,
        date: date,
        time: time,
        location: location,
        childAge: childAge,
        description: description,
        creatorId: creatorId,
        hostName: hostName,
        maxParticipants: maxParticipants,
      ),
    );
    if (!_ok(result)) {
      throw Exception(result.errorOrNull ?? 'Could not create playdate.');
    }
    _refresh();
  }

  void updatePlaydate(Playdate playdate) {
    final result = _readSync(_repo.update(playdate));
    if (!_ok(result)) {
      throw Exception(result.errorOrNull ?? 'Could not update playdate.');
    }
    _refresh();
  }

  /// Adds [userId] to participants.
  /// Owners cannot join their own playdate.
  bool joinPlaydate(String playdateId, String userId) {
    final result = _readSync(_repo.join(playdateId, userId));
    if (_ok(result)) {
      _refresh();
      return true;
    }
    return false;
  }

  /// Removes [userId] from participants.
  /// Owners cannot "leave" as a participant.
  bool leavePlaydate(String playdateId, String userId) {
    final result = _readSync(_repo.leave(playdateId, userId));
    if (_ok(result)) {
      _refresh();
      return true;
    }
    return false;
  }

  /// Removes a playdate. Only the creator ([userId]) may cancel.
  bool cancelPlaydate(String playdateId, String userId) {
    final result = _readSync(_repo.delete(playdateId, userId));
    if (_ok(result)) {
      _refresh();
      return true;
    }
    return false;
  }

  bool joinAsCurrentUser(String playdateId) {
    return joinPlaydate(playdateId, ref.read(currentUserProvider).id);
  }

  bool leaveAsCurrentUser(String playdateId) {
    return leavePlaydate(playdateId, ref.read(currentUserProvider).id);
  }

  bool cancelAsCurrentUser(String playdateId) {
    return cancelPlaydate(playdateId, ref.read(currentUserProvider).id);
  }

  Playdate? playdateById(String id) {
    for (final playdate in playdates) {
      if (playdate.id == id) return playdate;
    }
    return null;
  }
}

final playdateProvider =
    AsyncNotifierProvider<PlaydateNotifier, List<Playdate>>(
  PlaydateNotifier.new,
);
