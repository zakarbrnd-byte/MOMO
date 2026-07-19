/// Domain model for a playdate.
///
/// Ownership ([creatorId]) is separate from participation ([joinedUserIds]).
/// Counts and full-state are derived — never persisted separately.
class Playdate {
  const Playdate({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.childAge,
    required this.description,
    required this.hostName,
    this.joinedUserIds = const [],
    this.maxParticipants,
  });

  final String id;

  /// User who created the playdate (not the same as a participant).
  final String creatorId;

  final String title;
  final String date;
  final String time;
  final String location;
  final String childAge;
  final String description;
  final String hostName;

  /// Participant user IDs (source of truth for join/leave).
  final List<String> joinedUserIds;

  /// Optional capacity. `null` means unlimited.
  final int? maxParticipants;

  /// Derived count — do not store separately.
  int get participantCount => joinedUserIds.length;

  /// Alias kept for call-site clarity in older code paths.
  int get currentParticipants => participantCount;

  bool get hasCapacityLimit => maxParticipants != null;

  bool get isFull =>
      hasCapacityLimit && participantCount >= maxParticipants!;

  bool isOwner(String userId) => creatorId == userId;

  bool hasUserJoined(String userId) => joinedUserIds.contains(userId);

  /// Backward-compatible alias for [hasUserJoined].
  bool isJoinedBy(String userId) => hasUserJoined(userId);

  /// Shared label for cards and detail screens.
  String get participantsLabel {
    if (hasCapacityLimit) {
      return '$participantCount / $maxParticipants joined';
    }
    return '$participantCount joined';
  }

  /// UI-facing participation / ownership action for [userId].
  PlaydateJoinState joinStateFor(String userId) {
    if (isOwner(userId)) return PlaydateJoinState.owner;
    if (hasUserJoined(userId)) return PlaydateJoinState.leave;
    if (isFull) return PlaydateJoinState.full;
    return PlaydateJoinState.join;
  }

  Playdate copyWith({
    String? id,
    String? creatorId,
    String? title,
    String? date,
    String? time,
    String? location,
    String? childAge,
    String? description,
    String? hostName,
    List<String>? joinedUserIds,
    Object? maxParticipants = _unset,
  }) {
    return Playdate(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      childAge: childAge ?? this.childAge,
      description: description ?? this.description,
      hostName: hostName ?? this.hostName,
      joinedUserIds: joinedUserIds ?? this.joinedUserIds,
      maxParticipants: identical(maxParticipants, _unset)
          ? this.maxParticipants
          : maxParticipants as int?,
    );
  }
}

/// What the primary participation control should show for a user.
enum PlaydateJoinState {
  owner,
  join,
  leave,
  full,
}

extension PlaydateJoinStateX on PlaydateJoinState {
  String get actionLabel {
    return switch (this) {
      PlaydateJoinState.owner => 'My Playdate',
      PlaydateJoinState.join => 'Join Playdate',
      PlaydateJoinState.leave => 'Leave Playdate',
      PlaydateJoinState.full => 'Playdate Full',
    };
  }

  bool get isOwnerState => this == PlaydateJoinState.owner;
  bool get canJoin => this == PlaydateJoinState.join;
  bool get canLeave => this == PlaydateJoinState.leave;
  bool get isFullState => this == PlaydateJoinState.full;
}

const _unset = Object();
