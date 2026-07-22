import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// In-memory playdate store as [AsyncValue] (feed load lifecycle).
///
/// Data access goes through [PlaydateRepository] only.
/// Mutations that need Idle → Loading → Success | Error should run through
/// [MutationNotifier] (see `createPlaydateMutationProvider`).
class PlaydateNotifier extends AsyncNotifier<List<Playdate>> {
  PlaydateRepository get _repo => ref.read(playdateRepositoryProvider);

  @override
  Future<List<Playdate>> build() => _repo.getPlaydates();

  List<Playdate> get playdates => state.valueOrNull ?? const [];

  void _refresh() {
    state = AsyncData(_readSync(_repo.getPlaydates()));
  }

  void addPlaydate(Playdate playdate) {
    _readSync(_repo.updatePlaydate(playdate));
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
    _readSync(
      _repo.createPlaydate(
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
    _refresh();
  }

  void updatePlaydate(Playdate playdate) {
    _readSync(_repo.updatePlaydate(playdate));
    _refresh();
  }

  /// Adds [userId] to participants.
  /// Owners cannot join their own playdate.
  bool joinPlaydate(String playdateId, String userId) {
    final ok = _readSync(_repo.joinPlaydate(playdateId, userId));
    if (ok) _refresh();
    return ok;
  }

  /// Removes [userId] from participants.
  /// Owners cannot "leave" as a participant.
  bool leavePlaydate(String playdateId, String userId) {
    final ok = _readSync(_repo.leavePlaydate(playdateId, userId));
    if (ok) _refresh();
    return ok;
  }

  /// Removes a playdate. Only the creator ([userId]) may cancel.
  bool cancelPlaydate(String playdateId, String userId) {
    final ok = _readSync(_repo.deletePlaydate(playdateId, userId));
    if (ok) _refresh();
    return ok;
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
