import 'package:flutter/foundation.dart';

import '../core/result/result.dart';
import '../data/datasources/group_data_source.dart';
import '../dto/group_dto.dart';
import '../models/group.dart';
import 'group_repository.dart';

/// Group access with DTO round-trip on load; persistence via [GroupDataSource].
///
/// Mapping: data source domain objects → DTO round-trip → domain.
/// Mutations map thrown exceptions to [Failure].
class GroupRepositoryImpl implements GroupRepository {
  GroupRepositoryImpl(this._dataSource);

  final GroupDataSource _dataSource;

  @override
  Future<List<Group>> load() {
    return _dataSource.getGroups().then((items) {
      return [
        for (final item in items) GroupDto.fromDomain(item).toDomain(),
      ];
    });
  }

  @override
  Future<Group?> getById(String id) {
    return _dataSource.getGroupById(id).then((item) {
      if (item == null) return null;
      return GroupDto.fromDomain(item).toDomain();
    });
  }

  @override
  Future<List<GroupMember>> loadMembers(String groupId) {
    return _dataSource.getGroupMembers(groupId).then((items) {
      return [
        for (final item in items) GroupMemberDto.fromDomain(item).toDomain(),
      ];
    });
  }

  @override
  Future<Set<String>> loadJoinedGroupIds(String userId) {
    return _dataSource.getJoinedGroupIds(userId);
  }

  @override
  Future<Result<bool>> join({
    required String groupId,
    required String userId,
    required String userName,
  }) {
    return _runMutation(
      () => _dataSource.joinGroup(
        groupId: groupId,
        userId: userId,
        userName: userName,
      ),
      failureMessage: 'Could not join group.',
    );
  }

  @override
  Future<Result<bool>> leave({
    required String groupId,
    required String userId,
  }) {
    return _runMutation(
      () => _dataSource.leaveGroup(groupId: groupId, userId: userId),
      failureMessage: 'Could not leave group.',
    );
  }

  @override
  Future<List<EventAnnouncement>> loadEvents(String groupId) {
    return _dataSource.getEventsByGroup(groupId).then((items) {
      return [
        for (final item in items)
          EventAnnouncementDto.fromDomain(item).toDomain(),
      ];
    });
  }

  @override
  Future<EventAnnouncement?> getEventById(String id) {
    return _dataSource.getEventById(id).then((item) {
      if (item == null) return null;
      return EventAnnouncementDto.fromDomain(item).toDomain();
    });
  }

  @override
  Future<List<Rsvp>> loadRsvps(String eventId) {
    return _dataSource.getRsvpsByEvent(eventId).then((items) {
      return [
        for (final item in items) RsvpDto.fromDomain(item).toDomain(),
      ];
    });
  }

  @override
  Future<Result<bool>> setRsvp(Rsvp rsvp) {
    return _runMutation(
      () => _dataSource.setRsvp(rsvp),
      failureMessage: 'Could not update RSVP.',
    );
  }

  @override
  Future<Result<bool>> createGroup({
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
    return _runMutation(
      () => _dataSource.createGroup(
        name: name,
        description: description,
        category: category,
        location: location,
        ownerId: ownerId,
        ownerName: ownerName,
        childAgeRanges: childAgeRanges,
        interestTags: interestTags,
        coverEmoji: coverEmoji,
        isFeatured: isFeatured,
      ),
      failureMessage: 'Could not create group.',
    );
  }

  @override
  Future<Result<bool>> createEvent({
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
    return _runMutation(
      () => _dataSource.createEvent(
        groupId: groupId,
        creatorId: creatorId,
        creatorName: creatorName,
        title: title,
        description: description,
        dateTime: dateTime,
        location: location,
        childAgeRange: childAgeRange,
        participantLimit: participantLimit,
      ),
      failureMessage: 'Could not create event.',
    );
  }

  /// Always awaits the data-source Future (sync or async implementations).
  Future<Result<bool>> _runMutation(
    Future<void> Function() action, {
    required String failureMessage,
  }) async {
    try {
      await action();
      return const Success(true);
    } catch (error, stackTrace) {
      debugPrint('GroupRepository mutation failed: $error\n$stackTrace');
      return Failure(failureMessage);
    }
  }
}
