import 'entity_status.dart';

/// Join record linking a user to a playdate.
///
/// MVP join/leave still uses [Playdate.participantIds]. This model prepares a
/// future participant table / API without changing current behavior.
class Participant {
  const Participant({
    required this.userId,
    required this.playdateId,
    this.joinedAt,
    this.status = ParticipantStatus.active,
  });

  final String userId;
  final String playdateId;
  final DateTime? joinedAt;
  final ParticipantStatus status;

  /// Stable composite key for future persistence.
  String get id => '${playdateId}_$userId';

  bool get isActive => status == ParticipantStatus.active;

  Participant copyWith({
    String? userId,
    String? playdateId,
    Object? joinedAt = _unset,
    ParticipantStatus? status,
  }) {
    return Participant(
      userId: userId ?? this.userId,
      playdateId: playdateId ?? this.playdateId,
      joinedAt: identical(joinedAt, _unset)
          ? this.joinedAt
          : joinedAt as DateTime?,
      status: status ?? this.status,
    );
  }
}

const _unset = Object();
