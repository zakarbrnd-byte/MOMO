import '../models/entity_status.dart';
import '../models/playdate.dart';
import 'json_converters.dart';

/// Wire format for [Playdate].
///
/// Maps JSON ⇄ domain. UI / providers use [Playdate] only.
/// Extra JSON keys (images, adminStatus, deletedAt, …) are ignored.
class PlaydateDto {
  const PlaydateDto({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.childAge,
    required this.description,
    required this.hostName,
    this.participantIds = const [],
    this.maxParticipants,
    this.status = PlaydateStatus.active,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String creatorId;
  final String title;
  final String date;
  final String time;
  final String location;
  final String childAge;
  final String description;
  final String hostName;
  final List<String> participantIds;
  final int? maxParticipants;
  final PlaydateStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PlaydateDto.fromJson(Map<String, dynamic> json) {
    return PlaydateDto(
      id: JsonConverters.stringFromJson(json['id']),
      creatorId: JsonConverters.stringFromJson(json['creatorId']),
      title: JsonConverters.stringFromJson(json['title']),
      date: JsonConverters.stringFromJson(json['date']),
      time: JsonConverters.stringFromJson(json['time']),
      location: JsonConverters.stringFromJson(json['location']),
      childAge: JsonConverters.stringFromJson(json['childAge']),
      description: JsonConverters.stringFromJson(json['description']),
      hostName: JsonConverters.stringFromJson(json['hostName']),
      participantIds: JsonConverters.stringListFromJson(json['participantIds']),
      maxParticipants: JsonConverters.intFromJson(json['maxParticipants']),
      status: JsonConverters.enumFromJson(
        json['status'],
        PlaydateStatus.values,
        fallback: PlaydateStatus.active,
      ),
      createdAt: JsonConverters.dateTimeFromJson(json['createdAt']),
      updatedAt: JsonConverters.dateTimeFromJson(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creatorId': creatorId,
      'title': title,
      'date': date,
      'time': time,
      'location': location,
      'childAge': childAge,
      'description': description,
      'hostName': hostName,
      'participantIds': participantIds,
      'maxParticipants': maxParticipants,
      'status': JsonConverters.enumToJson(status),
      if (createdAt != null)
        'createdAt': JsonConverters.dateTimeToJson(createdAt),
      if (updatedAt != null)
        'updatedAt': JsonConverters.dateTimeToJson(updatedAt),
    };
  }

  Playdate toDomain() {
    return Playdate(
      id: id,
      creatorId: creatorId,
      title: title,
      date: date,
      time: time,
      location: location,
      childAge: childAge,
      description: description,
      hostName: hostName,
      participantIds: List<String>.from(participantIds),
      maxParticipants: maxParticipants,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory PlaydateDto.fromDomain(Playdate playdate) {
    return PlaydateDto(
      id: playdate.id,
      creatorId: playdate.creatorId,
      title: playdate.title,
      date: playdate.date,
      time: playdate.time,
      location: playdate.location,
      childAge: playdate.childAge,
      description: playdate.description,
      hostName: playdate.hostName,
      participantIds: List<String>.from(playdate.participantIds),
      maxParticipants: playdate.maxParticipants,
      status: playdate.status,
      createdAt: playdate.createdAt,
      updatedAt: playdate.updatedAt,
    );
  }
}
