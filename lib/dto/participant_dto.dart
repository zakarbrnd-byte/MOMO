import '../models/entity_status.dart';
import '../models/participant.dart';
import 'json_converters.dart';

/// Wire format for [Participant].
///
/// Unknown JSON keys (e.g. future admin fields) are ignored on [fromJson].
class ParticipantDto {
  const ParticipantDto({
    required this.userId,
    required this.playdateId,
    this.joinedAt,
    this.status = ParticipantStatus.active,
  });

  final String userId;
  final String playdateId;
  final DateTime? joinedAt;
  final ParticipantStatus status;

  factory ParticipantDto.fromJson(Map<String, dynamic> json) {
    return ParticipantDto(
      userId: JsonConverters.stringFromJson(json['userId']),
      playdateId: JsonConverters.stringFromJson(json['playdateId']),
      joinedAt: JsonConverters.dateTimeFromJson(json['joinedAt']),
      status: JsonConverters.enumFromJson(
        json['status'],
        ParticipantStatus.values,
        fallback: ParticipantStatus.active,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'playdateId': playdateId,
      if (joinedAt != null)
        'joinedAt': JsonConverters.dateTimeToJson(joinedAt),
      'status': JsonConverters.enumToJson(status),
    };
  }

  Participant toDomain() {
    return Participant(
      userId: userId,
      playdateId: playdateId,
      joinedAt: joinedAt,
      status: status,
    );
  }

  factory ParticipantDto.fromDomain(Participant participant) {
    return ParticipantDto(
      userId: participant.userId,
      playdateId: participant.playdateId,
      joinedAt: participant.joinedAt,
      status: participant.status,
    );
  }
}
