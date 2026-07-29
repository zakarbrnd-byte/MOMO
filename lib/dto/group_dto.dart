import '../models/entity_status.dart';
import '../models/group.dart';
import 'json_converters.dart';

class GroupDto {
  const GroupDto({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.location,
    required this.ownerId,
    required this.ownerName,
    this.childAgeRanges = const [],
    this.interestTags = const [],
    this.memberCount = 0,
    this.coverEmoji,
    this.isFeatured = false,
    this.createdAt,
    this.recentActivityAt,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final String location;
  final List<String> childAgeRanges;
  final List<String> interestTags;
  final String ownerId;
  final String ownerName;
  final int memberCount;
  final String? coverEmoji;
  final bool isFeatured;
  final DateTime? createdAt;
  final DateTime? recentActivityAt;

  factory GroupDto.fromJson(Map<String, dynamic> json) {
    return GroupDto(
      id: JsonConverters.stringFromJson(json['id']),
      name: JsonConverters.stringFromJson(json['name']),
      description: JsonConverters.stringFromJson(json['description']),
      category: JsonConverters.stringFromJson(json['category']),
      location: JsonConverters.stringFromJson(json['location']),
      ownerId: JsonConverters.stringFromJson(json['ownerId']),
      ownerName: JsonConverters.stringFromJson(json['ownerName']),
      childAgeRanges: JsonConverters.stringListFromJson(json['childAgeRanges']),
      interestTags: JsonConverters.stringListFromJson(json['interestTags']),
      memberCount: JsonConverters.intFromJson(json['memberCount']) ?? 0,
      coverEmoji: JsonConverters.nullableStringFromJson(json['coverEmoji']),
      isFeatured: json['isFeatured'] == true,
      createdAt: JsonConverters.dateTimeFromJson(json['createdAt']),
      recentActivityAt:
          JsonConverters.dateTimeFromJson(json['recentActivityAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'location': location,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'childAgeRanges': childAgeRanges,
      'interestTags': interestTags,
      'memberCount': memberCount,
      if (coverEmoji != null) 'coverEmoji': coverEmoji,
      'isFeatured': isFeatured,
      if (createdAt != null)
        'createdAt': JsonConverters.dateTimeToJson(createdAt),
      if (recentActivityAt != null)
        'recentActivityAt': JsonConverters.dateTimeToJson(recentActivityAt),
    };
  }

  Group toDomain() {
    return Group(
      id: id,
      name: name,
      description: description,
      category: category,
      location: location,
      childAgeRanges: childAgeRanges,
      interestTags: interestTags,
      ownerId: ownerId,
      ownerName: ownerName,
      memberCount: memberCount,
      coverEmoji: coverEmoji,
      isFeatured: isFeatured,
      createdAt: createdAt,
      recentActivityAt: recentActivityAt,
    );
  }

  factory GroupDto.fromDomain(Group group) {
    return GroupDto(
      id: group.id,
      name: group.name,
      description: group.description,
      category: group.category,
      location: group.location,
      childAgeRanges: group.childAgeRanges,
      interestTags: group.interestTags,
      ownerId: group.ownerId,
      ownerName: group.ownerName,
      memberCount: group.memberCount,
      coverEmoji: group.coverEmoji,
      isFeatured: group.isFeatured,
      createdAt: group.createdAt,
      recentActivityAt: group.recentActivityAt,
    );
  }
}

class GroupMemberDto {
  const GroupMemberDto({
    required this.groupId,
    required this.userId,
    required this.userName,
    this.role = GroupMemberRole.member,
    this.joinedAt,
  });

  final String groupId;
  final String userId;
  final String userName;
  final GroupMemberRole role;
  final DateTime? joinedAt;

  factory GroupMemberDto.fromJson(Map<String, dynamic> json) {
    return GroupMemberDto(
      groupId: JsonConverters.stringFromJson(json['groupId']),
      userId: JsonConverters.stringFromJson(json['userId']),
      userName: JsonConverters.stringFromJson(json['userName']),
      role: JsonConverters.enumFromJson(
        json['role'],
        GroupMemberRole.values,
        fallback: GroupMemberRole.member,
      ),
      joinedAt: JsonConverters.dateTimeFromJson(json['joinedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'userId': userId,
      'userName': userName,
      'role': JsonConverters.enumToJson(role),
      if (joinedAt != null) 'joinedAt': JsonConverters.dateTimeToJson(joinedAt),
    };
  }

  GroupMember toDomain() {
    return GroupMember(
      groupId: groupId,
      userId: userId,
      userName: userName,
      role: role,
      joinedAt: joinedAt,
    );
  }

  factory GroupMemberDto.fromDomain(GroupMember member) {
    return GroupMemberDto(
      groupId: member.groupId,
      userId: member.userId,
      userName: member.userName,
      role: member.role,
      joinedAt: member.joinedAt,
    );
  }
}

class EventAnnouncementDto {
  const EventAnnouncementDto({
    required this.id,
    required this.groupId,
    required this.creatorId,
    required this.creatorName,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    this.childAgeRange = '',
    this.participantLimit,
    this.status = EventStatus.scheduled,
    this.createdAt,
  });

  final String id;
  final String groupId;
  final String creatorId;
  final String creatorName;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final String childAgeRange;
  final int? participantLimit;
  final EventStatus status;
  final DateTime? createdAt;

  factory EventAnnouncementDto.fromJson(Map<String, dynamic> json) {
    return EventAnnouncementDto(
      id: JsonConverters.stringFromJson(json['id']),
      groupId: JsonConverters.stringFromJson(json['groupId']),
      creatorId: JsonConverters.stringFromJson(json['creatorId']),
      creatorName: JsonConverters.stringFromJson(json['creatorName']),
      title: JsonConverters.stringFromJson(json['title']),
      description: JsonConverters.stringFromJson(json['description']),
      dateTime: JsonConverters.dateTimeFromJson(json['dateTime']) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      location: JsonConverters.stringFromJson(json['location']),
      childAgeRange: JsonConverters.stringFromJson(json['childAgeRange']),
      participantLimit: JsonConverters.intFromJson(json['participantLimit']),
      status: JsonConverters.enumFromJson(
        json['status'],
        EventStatus.values,
        fallback: EventStatus.scheduled,
      ),
      createdAt: JsonConverters.dateTimeFromJson(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'title': title,
      'description': description,
      'dateTime': JsonConverters.dateTimeToJson(dateTime),
      'location': location,
      'childAgeRange': childAgeRange,
      if (participantLimit != null) 'participantLimit': participantLimit,
      'status': JsonConverters.enumToJson(status),
      if (createdAt != null)
        'createdAt': JsonConverters.dateTimeToJson(createdAt),
    };
  }

  EventAnnouncement toDomain() {
    return EventAnnouncement(
      id: id,
      groupId: groupId,
      creatorId: creatorId,
      creatorName: creatorName,
      title: title,
      description: description,
      dateTime: dateTime,
      location: location,
      childAgeRange: childAgeRange,
      participantLimit: participantLimit,
      status: status,
      createdAt: createdAt,
    );
  }

  factory EventAnnouncementDto.fromDomain(EventAnnouncement event) {
    return EventAnnouncementDto(
      id: event.id,
      groupId: event.groupId,
      creatorId: event.creatorId,
      creatorName: event.creatorName,
      title: event.title,
      description: event.description,
      dateTime: event.dateTime,
      location: event.location,
      childAgeRange: event.childAgeRange,
      participantLimit: event.participantLimit,
      status: event.status,
      createdAt: event.createdAt,
    );
  }
}

class RsvpDto {
  const RsvpDto({
    required this.eventId,
    required this.userId,
    required this.userName,
    required this.status,
    this.updatedAt,
  });

  final String eventId;
  final String userId;
  final String userName;
  final RsvpStatus status;
  final DateTime? updatedAt;

  factory RsvpDto.fromJson(Map<String, dynamic> json) {
    return RsvpDto(
      eventId: JsonConverters.stringFromJson(json['eventId']),
      userId: JsonConverters.stringFromJson(json['userId']),
      userName: JsonConverters.stringFromJson(json['userName']),
      status: JsonConverters.enumFromJson(
        json['status'],
        RsvpStatus.values,
        fallback: RsvpStatus.undecided,
      ),
      updatedAt: JsonConverters.dateTimeFromJson(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'userId': userId,
      'userName': userName,
      'status': JsonConverters.enumToJson(status),
      if (updatedAt != null)
        'updatedAt': JsonConverters.dateTimeToJson(updatedAt),
    };
  }

  Rsvp toDomain() {
    return Rsvp(
      eventId: eventId,
      userId: userId,
      userName: userName,
      status: status,
      updatedAt: updatedAt,
    );
  }

  factory RsvpDto.fromDomain(Rsvp rsvp) {
    return RsvpDto(
      eventId: rsvp.eventId,
      userId: rsvp.userId,
      userName: rsvp.userName,
      status: rsvp.status,
      updatedAt: rsvp.updatedAt,
    );
  }
}
