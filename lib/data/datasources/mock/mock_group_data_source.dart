import 'package:flutter/foundation.dart';

import '../../../models/entity_status.dart';
import '../../../models/group.dart';
import '../../mock_groups.dart';
import '../group_data_source.dart';

/// In-memory group store seeded from [mockGroups] / related seed lists.
///
/// Owns mock collections — repositories must not hold seed lists.
class MockGroupDataSource implements GroupDataSource {
  MockGroupDataSource({
    List<Group>? groups,
    List<GroupMember>? members,
    List<EventAnnouncement>? events,
    List<Rsvp>? rsvps,
  })  : _groups = List<Group>.from(groups ?? mockGroups),
        _members = List<GroupMember>.from(members ?? mockGroupMembers),
        _events = List<EventAnnouncement>.from(events ?? mockEvents),
        _rsvps = List<Rsvp>.from(rsvps ?? mockRsvps);

  final List<Group> _groups;
  final List<GroupMember> _members;
  final List<EventAnnouncement> _events;
  final List<Rsvp> _rsvps;

  @override
  Future<List<Group>> getGroups() {
    return SynchronousFuture(List<Group>.from(_groups));
  }

  @override
  Future<Group?> getGroupById(String id) {
    return SynchronousFuture(_groupById(id));
  }

  @override
  Future<List<GroupMember>> getGroupMembers(String groupId) {
    return SynchronousFuture([
      for (final member in _members)
        if (member.groupId == groupId) member,
    ]);
  }

  @override
  Future<Set<String>> getJoinedGroupIds(String userId) {
    return SynchronousFuture({
      for (final member in _members)
        if (member.userId == userId) member.groupId,
    });
  }

  @override
  Future<void> joinGroup({
    required String groupId,
    required String userId,
    required String userName,
  }) {
    final group = _groupById(groupId);
    if (group == null) {
      throw StateError('Group not found: $groupId');
    }
    if (_isMember(groupId, userId)) {
      throw StateError('Already a member of $groupId');
    }

    final now = DateTime.now();
    _members.add(
      GroupMember(
        groupId: groupId,
        userId: userId,
        userName: userName.trim(),
        role: GroupMemberRole.member,
        joinedAt: now,
      ),
    );
    _replaceGroup(
      group.copyWith(
        memberCount: group.memberCount + 1,
        recentActivityAt: now,
      ),
    );
    return SynchronousFuture(null);
  }

  @override
  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) {
    final group = _groupById(groupId);
    if (group == null) {
      throw StateError('Group not found: $groupId');
    }
    final member = _memberOf(groupId, userId);
    if (member == null) {
      throw StateError('Not a member of $groupId');
    }
    if (member.role == GroupMemberRole.owner) {
      throw StateError('Owner cannot leave the group');
    }

    _members.removeWhere(
      (m) => m.groupId == groupId && m.userId == userId,
    );
    final now = DateTime.now();
    _replaceGroup(
      group.copyWith(
        memberCount: group.memberCount > 0 ? group.memberCount - 1 : 0,
        recentActivityAt: now,
      ),
    );
    return SynchronousFuture(null);
  }

  @override
  Future<List<EventAnnouncement>> getEventsByGroup(String groupId) {
    return SynchronousFuture([
      for (final event in _events)
        if (event.groupId == groupId) event,
    ]);
  }

  @override
  Future<EventAnnouncement?> getEventById(String id) {
    for (final event in _events) {
      if (event.id == id) return SynchronousFuture(event);
    }
    return SynchronousFuture(null);
  }

  @override
  Future<List<Rsvp>> getRsvpsByEvent(String eventId) {
    return SynchronousFuture([
      for (final rsvp in _rsvps)
        if (rsvp.eventId == eventId) rsvp,
    ]);
  }

  @override
  Future<void> setRsvp(Rsvp rsvp) {
    final index = _rsvps.indexWhere(
      (item) => item.eventId == rsvp.eventId && item.userId == rsvp.userId,
    );
    final updated = rsvp.copyWith(
      updatedAt: rsvp.updatedAt ?? DateTime.now(),
    );
    if (index >= 0) {
      _rsvps[index] = updated;
    } else {
      _rsvps.add(updated);
    }
    return SynchronousFuture(null);
  }

  @override
  Future<void> createGroup({
    required String name,
    required String description,
    required String category,
    required String location,
    required String ownerId,
    required String ownerName,
    List<String> childAgeRanges = const [],
    List<String> interestTags = const [],
    String? coverEmoji,
    bool isFeatured = false,
  }) {
    final now = DateTime.now();
    final id = 'grp_${now.millisecondsSinceEpoch}';
    final group = Group(
      id: id,
      name: name.trim(),
      description: description.trim(),
      category: category.trim(),
      location: location.trim(),
      childAgeRanges: childAgeRanges,
      interestTags: interestTags,
      ownerId: ownerId,
      ownerName: ownerName.trim(),
      memberCount: 1,
      coverEmoji: coverEmoji,
      isFeatured: isFeatured,
      createdAt: now,
      recentActivityAt: now,
    );
    _groups.insert(0, group);
    _members.insert(
      0,
      GroupMember(
        groupId: id,
        userId: ownerId,
        userName: ownerName.trim(),
        role: GroupMemberRole.owner,
        joinedAt: now,
      ),
    );
    return SynchronousFuture(null);
  }

  @override
  Future<void> createEvent({
    required String groupId,
    required String creatorId,
    required String creatorName,
    required String title,
    required String description,
    required DateTime dateTime,
    required String location,
    String childAgeRange = '',
    int? participantLimit,
  }) {
    if (_groupById(groupId) == null) {
      throw StateError('Group not found: $groupId');
    }
    final now = DateTime.now();
    final event = EventAnnouncement(
      id: 'evt_${now.millisecondsSinceEpoch}',
      groupId: groupId,
      creatorId: creatorId,
      creatorName: creatorName.trim(),
      title: title.trim(),
      description: description.trim(),
      dateTime: dateTime,
      location: location.trim(),
      childAgeRange: childAgeRange.trim(),
      participantLimit: participantLimit,
      status: EventStatus.scheduled,
      createdAt: now,
    );
    _events.insert(0, event);
    return SynchronousFuture(null);
  }

  Group? _groupById(String id) {
    for (final group in _groups) {
      if (group.id == id) return group;
    }
    return null;
  }

  bool _isMember(String groupId, String userId) {
    return _memberOf(groupId, userId) != null;
  }

  GroupMember? _memberOf(String groupId, String userId) {
    for (final member in _members) {
      if (member.groupId == groupId && member.userId == userId) {
        return member;
      }
    }
    return null;
  }

  void _replaceGroup(Group updated) {
    final index = _groups.indexWhere((g) => g.id == updated.id);
    if (index >= 0) {
      _groups[index] = updated;
    }
  }
}
