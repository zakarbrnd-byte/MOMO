import 'entity_status.dart';

/// Persistent community (not a scheduled event).
class Group {
  const Group({
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

  /// Display category label (e.g. 육아 · 워킹맘).
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

  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? location,
    List<String>? childAgeRanges,
    List<String>? interestTags,
    String? ownerId,
    String? ownerName,
    int? memberCount,
    Object? coverEmoji = _unset,
    bool? isFeatured,
    Object? createdAt = _unset,
    Object? recentActivityAt = _unset,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      childAgeRanges: childAgeRanges ?? this.childAgeRanges,
      interestTags: interestTags ?? this.interestTags,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      memberCount: memberCount ?? this.memberCount,
      coverEmoji: identical(coverEmoji, _unset)
          ? this.coverEmoji
          : coverEmoji as String?,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: identical(createdAt, _unset)
          ? this.createdAt
          : createdAt as DateTime?,
      recentActivityAt: identical(recentActivityAt, _unset)
          ? this.recentActivityAt
          : recentActivityAt as DateTime?,
    );
  }
}

const _unset = Object();

/// Membership role inside a [Group].
enum GroupMemberRole { owner, admin, member }

/// Relationship between a user and a [Group].
class GroupMember {
  const GroupMember({
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

  GroupMember copyWith({
    String? groupId,
    String? userId,
    String? userName,
    GroupMemberRole? role,
    Object? joinedAt = _unset,
  }) {
    return GroupMember(
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      role: role ?? this.role,
      joinedAt: identical(joinedAt, _unset)
          ? this.joinedAt
          : joinedAt as DateTime?,
    );
  }
}

/// Scheduled offline activity that belongs to a [Group].
class EventAnnouncement {
  const EventAnnouncement({
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

  bool get isCancelled => status == EventStatus.cancelled;

  EventAnnouncement copyWith({
    String? id,
    String? groupId,
    String? creatorId,
    String? creatorName,
    String? title,
    String? description,
    DateTime? dateTime,
    String? location,
    String? childAgeRange,
    Object? participantLimit = _unset,
    EventStatus? status,
    Object? createdAt = _unset,
  }) {
    return EventAnnouncement(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      childAgeRange: childAgeRange ?? this.childAgeRange,
      participantLimit: identical(participantLimit, _unset)
          ? this.participantLimit
          : participantLimit as int?,
      status: status ?? this.status,
      createdAt: identical(createdAt, _unset)
          ? this.createdAt
          : createdAt as DateTime?,
    );
  }
}

/// User response to an [EventAnnouncement].
class Rsvp {
  const Rsvp({
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

  Rsvp copyWith({
    String? eventId,
    String? userId,
    String? userName,
    RsvpStatus? status,
    Object? updatedAt = _unset,
  }) {
    return Rsvp(
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      status: status ?? this.status,
      updatedAt: identical(updatedAt, _unset)
          ? this.updatedAt
          : updatedAt as DateTime?,
    );
  }
}
