import 'entity_status.dart';

/// Domain model for a playdate.
///
/// Ownership ([creatorId]) is separate from participation ([participantIds]).
/// Counts and full-state are derived — never persisted separately.
///
/// [hostName] / [hostChildLabel] are denormalized display fields for MVP UI.
///
/// Phase 3.5 engagement fields ([viewCount], [commentCount], [likeCount]) are
/// display-only mock metrics — not interactive until a later phase.
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
    this.hostChildLabel,
    this.participantIds = const [],
    this.maxParticipants,
    this.viewCount = 0,
    this.commentCount = 0,
    this.likeCount = 0,
    this.status = PlaydateStatus.active,
    this.createdAt,
    this.updatedAt,
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

  /// Display name of the host (denormalized for MVP cards/detail).
  final String hostName;

  /// Optional host child context, e.g. `아이 4세`.
  final String? hostChildLabel;

  /// Participant user IDs (source of truth for join/leave in MVP).
  final List<String> participantIds;

  /// Optional capacity. `null` means unlimited.
  final int? maxParticipants;

  /// Display-only engagement (mock / future analytics).
  final int viewCount;
  final int commentCount;
  final int likeCount;

  final PlaydateStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Soft-cancel flag derived from [status] (soft-delete reserved for backend).
  bool get isCancelled => status == PlaydateStatus.cancelled;

  /// Derived count — do not store separately.
  int get participantCount => participantIds.length;

  /// Alias kept for call-site clarity in older code paths.
  int get currentParticipants => participantCount;

  /// Backward-compatible alias for [participantIds].
  List<String> get joinedUserIds => participantIds;

  bool get hasCapacityLimit => maxParticipants != null;

  bool get isFull => hasCapacityLimit && participantCount >= maxParticipants!;

  bool isOwner(String userId) => creatorId == userId;

  bool hasUserJoined(String userId) => participantIds.contains(userId);

  /// Backward-compatible alias for [hasUserJoined].
  bool isJoinedBy(String userId) => hasUserJoined(userId);

  /// Shared label for cards and detail screens (Korean-first).
  String get participantsLabel {
    if (hasCapacityLimit) {
      return '$participantCount / $maxParticipants명';
    }
    return '$participantCount명';
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
    Object? hostChildLabel = _unset,
    List<String>? participantIds,
    Object? maxParticipants = _unset,
    int? viewCount,
    int? commentCount,
    int? likeCount,
    PlaydateStatus? status,
    Object? createdAt = _unset,
    Object? updatedAt = _unset,
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
      hostChildLabel: identical(hostChildLabel, _unset)
          ? this.hostChildLabel
          : hostChildLabel as String?,
      participantIds: participantIds ?? this.participantIds,
      maxParticipants: identical(maxParticipants, _unset)
          ? this.maxParticipants
          : maxParticipants as int?,
      viewCount: viewCount ?? this.viewCount,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
      status: status ?? this.status,
      createdAt: identical(createdAt, _unset)
          ? this.createdAt
          : createdAt as DateTime?,
      updatedAt: identical(updatedAt, _unset)
          ? this.updatedAt
          : updatedAt as DateTime?,
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
      PlaydateJoinState.owner => '내가 만든 모임',
      PlaydateJoinState.join => '참여하기',
      PlaydateJoinState.leave => '나가기',
      PlaydateJoinState.full => '마감',
    };
  }

  /// Compact status chip label on feed cards.
  String get statusBadgeLabel {
    return switch (this) {
      PlaydateJoinState.owner => '내가 만든 모임',
      PlaydateJoinState.join => '참여하기',
      PlaydateJoinState.leave => '참여 중',
      PlaydateJoinState.full => '마감',
    };
  }

  bool get isOwnerState => this == PlaydateJoinState.owner;
  bool get canJoin => this == PlaydateJoinState.join;
  bool get canLeave => this == PlaydateJoinState.leave;
  bool get isFullState => this == PlaydateJoinState.full;
}

const _unset = Object();
