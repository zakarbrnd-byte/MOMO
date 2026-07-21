import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_feed.dart';
import '../models/playdate.dart';
import 'current_user_provider.dart';

/// In-memory playdate store as [AsyncValue] (feed load lifecycle).
///
/// Mutations that need Idle → Loading → Success | Error should run through
/// [MutationNotifier] (see `createPlaydateMutationProvider`) so UI stays
/// backend-ready. Local writes here remain synchronous.
class PlaydateNotifier extends AsyncNotifier<List<Playdate>> {
  @override
  Future<List<Playdate>> build() async {
    return List<Playdate>.from(mockPlaydates);
  }

  List<Playdate> get playdates => state.valueOrNull ?? const [];

  void addPlaydate(Playdate playdate) {
    state = AsyncData([playdate, ...playdates]);
  }

  /// Creates a playdate owned by [hostUserId] (defaults to current user).
  /// Creator is NOT added to [Playdate.joinedUserIds].
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

    addPlaydate(
      Playdate(
        id: 'pd_${DateTime.now().millisecondsSinceEpoch}',
        creatorId: creatorId,
        title: title.trim(),
        date: date.trim(),
        time: time.trim(),
        location: location.trim(),
        childAge: childAge.trim(),
        description: description.trim(),
        hostName: hostName?.trim().isNotEmpty == true
            ? hostName!.trim()
            : mockProfile.displayName,
        joinedUserIds: const [],
        maxParticipants: maxParticipants,
      ),
    );
  }

  void updatePlaydate(Playdate playdate) {
    _replace(playdate);
  }

  /// Adds [userId] to participants.
  /// Owners cannot join their own playdate.
  bool joinPlaydate(String playdateId, String userId) {
    final playdate = playdateById(playdateId);
    if (playdate == null) return false;
    if (playdate.isOwner(userId)) return false;
    if (playdate.hasUserJoined(userId) || playdate.isFull) return false;

    _replace(
      playdate.copyWith(
        joinedUserIds: [...playdate.joinedUserIds, userId],
      ),
    );
    return true;
  }

  /// Removes [userId] from participants.
  /// Owners cannot "leave" as a participant.
  bool leavePlaydate(String playdateId, String userId) {
    final playdate = playdateById(playdateId);
    if (playdate == null) return false;
    if (playdate.isOwner(userId)) return false;
    if (!playdate.hasUserJoined(userId)) return false;

    _replace(
      playdate.copyWith(
        joinedUserIds: [
          for (final id in playdate.joinedUserIds)
            if (id != userId) id,
        ],
      ),
    );
    return true;
  }

  /// Removes a playdate. Only the creator ([userId]) may cancel.
  bool cancelPlaydate(String playdateId, String userId) {
    final playdate = playdateById(playdateId);
    if (playdate == null) return false;
    if (!playdate.isOwner(userId)) return false;

    state = AsyncData([
      for (final item in playdates)
        if (item.id != playdateId) item,
    ]);
    return true;
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

  void _replace(Playdate updated) {
    state = AsyncData([
      for (final item in playdates)
        if (item.id == updated.id) updated else item,
    ]);
  }
}

final playdateProvider =
    AsyncNotifierProvider<PlaydateNotifier, List<Playdate>>(
  PlaydateNotifier.new,
);
