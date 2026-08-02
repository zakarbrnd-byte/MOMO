import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/core/result/result.dart';
import 'package:momo/data/mock_groups.dart';
import 'package:momo/data/mock_user.dart';
import 'package:momo/models/entity_status.dart';
import 'package:momo/models/group.dart';
import 'package:momo/providers/group_provider.dart';
import 'package:momo/repositories/group_repository.dart';
import 'package:momo/repositories/repository_providers.dart';

class _DelayedGroupRepository implements GroupRepository {
  _DelayedGroupRepository({this.failJoin = false, this.failLeave = false});

  final Duration delay = const Duration(milliseconds: 40);
  final bool failJoin;
  final bool failLeave;

  final List<Group> _groups = List<Group>.from(mockGroups);
  final Set<String> _joined = {
    for (final member in mockGroupMembers)
      if (member.userId == currentUserId) member.groupId,
  };
  final List<GroupMember> _members = List<GroupMember>.from(mockGroupMembers);
  final List<EventAnnouncement> _events = List<EventAnnouncement>.from(
    mockEvents,
  );
  final List<Rsvp> _rsvps = List<Rsvp>.from(mockRsvps);

  Future<T> _later<T>(T value) async {
    await Future<void>.delayed(delay);
    return value;
  }

  @override
  Future<List<Group>> load() => _later(List<Group>.from(_groups));

  @override
  Future<Group?> getById(String id) async {
    await Future<void>.delayed(delay);
    for (final group in _groups) {
      if (group.id == id) return group;
    }
    return null;
  }

  @override
  Future<List<GroupMember>> loadMembers(String groupId) async {
    await Future<void>.delayed(delay);
    return [
      for (final member in _members)
        if (member.groupId == groupId) member,
    ];
  }

  @override
  Future<Set<String>> loadJoinedGroupIds(String userId) =>
      _later(Set<String>.from(_joined));

  @override
  Future<Result<bool>> join({
    required String groupId,
    required String userId,
    required String userName,
  }) async {
    await Future<void>.delayed(delay);
    if (failJoin) return const Failure('join failed');
    if (_joined.contains(groupId)) {
      return const Failure('Already a member');
    }
    _joined.add(groupId);
    _members.add(
      GroupMember(groupId: groupId, userId: userId, userName: userName),
    );
    final index = _groups.indexWhere((g) => g.id == groupId);
    if (index >= 0) {
      final group = _groups[index];
      _groups[index] = group.copyWith(memberCount: group.memberCount + 1);
    }
    return const Success(true);
  }

  @override
  Future<Result<bool>> leave({
    required String groupId,
    required String userId,
  }) async {
    await Future<void>.delayed(delay);
    if (failLeave) return const Failure('leave failed');
    if (!_joined.contains(groupId)) {
      return const Failure('Not a member');
    }
    _joined.remove(groupId);
    _members.removeWhere((m) => m.groupId == groupId && m.userId == userId);
    final index = _groups.indexWhere((g) => g.id == groupId);
    if (index >= 0) {
      final group = _groups[index];
      _groups[index] = group.copyWith(
        memberCount: group.memberCount > 0 ? group.memberCount - 1 : 0,
      );
    }
    return const Success(true);
  }

  @override
  Future<List<EventAnnouncement>> loadEvents(String groupId) async {
    await Future<void>.delayed(delay);
    return [
      for (final event in _events)
        if (event.groupId == groupId) event,
    ];
  }

  @override
  Future<EventAnnouncement?> getEventById(String id) async {
    await Future<void>.delayed(delay);
    for (final event in _events) {
      if (event.id == id) return event;
    }
    return null;
  }

  @override
  Future<List<Rsvp>> loadRsvps(String eventId) async {
    await Future<void>.delayed(delay);
    return [
      for (final rsvp in _rsvps)
        if (rsvp.eventId == eventId) rsvp,
    ];
  }

  @override
  Future<Result<bool>> setRsvp(Rsvp rsvp) async {
    await Future<void>.delayed(delay);
    final index = _rsvps.indexWhere(
      (item) => item.eventId == rsvp.eventId && item.userId == rsvp.userId,
    );
    if (index >= 0) {
      _rsvps[index] = rsvp;
    } else {
      _rsvps.add(rsvp);
    }
    return const Success(true);
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
  }) async {
    await Future<void>.delayed(delay);
    final id = 'grp_delayed_${_groups.length}';
    _groups.insert(
      0,
      Group(
        id: id,
        name: name,
        description: description,
        category: category,
        location: location,
        ownerId: ownerId,
        ownerName: ownerName,
        childAgeRanges: childAgeRanges,
        interestTags: interestTags,
        memberCount: 1,
        coverEmoji: coverEmoji,
        isFeatured: isFeatured,
        createdAt: DateTime.now(),
      ),
    );
    _joined.add(id);
    return const Success(true);
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
  }) async {
    await Future<void>.delayed(delay);
    _events.insert(
      0,
      EventAnnouncement(
        id: 'evt_delayed_${_events.length}',
        groupId: groupId,
        creatorId: creatorId,
        creatorName: creatorName,
        title: title,
        description: description,
        dateTime: dateTime,
        location: location,
        childAgeRange: childAgeRange,
        participantLimit: participantLimit,
        status: EventStatus.scheduled,
        createdAt: DateTime.now(),
      ),
    );
    return const Success(true);
  }
}

class _FailingLoadRepository extends _DelayedGroupRepository {
  @override
  Future<List<Group>> load() async {
    await Future<void>.delayed(delay);
    throw Exception('load failed');
  }
}

void main() {
  test('initial group load resolves asynchronously', () async {
    final repo = _DelayedGroupRepository();
    final container = ProviderContainer(
      overrides: [groupRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    expect(container.read(groupProvider).isLoading, isTrue);
    final groups = await container.read(groupProvider.future);
    expect(groups, isNotEmpty);
    expect(container.read(groupProvider).hasValue, isTrue);
  });

  test('group load failure produces AsyncError', () async {
    final container = ProviderContainer(
      overrides: [
        groupRepositoryProvider.overrideWithValue(_FailingLoadRepository()),
      ],
    );
    addTearDown(container.dispose);

    await expectLater(container.read(groupProvider.future), throwsException);
    expect(container.read(groupProvider).hasError, isTrue);
  });

  test('joined group ids load asynchronously', () async {
    final container = ProviderContainer(
      overrides: [
        groupRepositoryProvider.overrideWithValue(_DelayedGroupRepository()),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(currentUserGroupIdsProvider).isLoading, isTrue);
    final ids = await container.read(currentUserGroupIdsProvider.future);
    expect(ids.contains(groupLa3.id), isTrue);
    expect(ids.contains(groupOcWork.id), isFalse);
  });

  test('join waits for repository and invalidates membership', () async {
    final repo = _DelayedGroupRepository();
    final container = ProviderContainer(
      overrides: [groupRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await container.read(groupProvider.future);
    await container.read(currentUserGroupIdsProvider.future);

    final before = await container.read(currentUserGroupIdsProvider.future);
    expect(before.contains(groupOcWork.id), isFalse);

    final joinFuture = container
        .read(groupProvider.notifier)
        .joinGroup(groupOcWork.id);
    expect(before.contains(groupOcWork.id), isFalse);
    await joinFuture;

    final after = await container.read(currentUserGroupIdsProvider.future);
    expect(after.contains(groupOcWork.id), isTrue);
  });

  test('join failure does not update membership', () async {
    final repo = _DelayedGroupRepository(failJoin: true);
    final container = ProviderContainer(
      overrides: [groupRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await container.read(currentUserGroupIdsProvider.future);
    await expectLater(
      container.read(groupProvider.notifier).joinGroup(groupOcWork.id),
      throwsException,
    );
    final ids = await container.read(currentUserGroupIdsProvider.future);
    expect(ids.contains(groupOcWork.id), isFalse);
  });

  test('leave waits for repository; failure preserves membership', () async {
    final okRepo = _DelayedGroupRepository();
    final container = ProviderContainer(
      overrides: [groupRepositoryProvider.overrideWithValue(okRepo)],
    );
    addTearDown(container.dispose);

    await container.read(groupProvider.future);
    await container.read(groupProvider.notifier).joinGroup(groupOcWork.id);
    expect(
      (await container.read(
        currentUserGroupIdsProvider.future,
      )).contains(groupOcWork.id),
      isTrue,
    );

    final failContainer = ProviderContainer(
      overrides: [
        groupRepositoryProvider.overrideWithValue(
          _DelayedGroupRepository(failLeave: true),
        ),
      ],
    );
    addTearDown(failContainer.dispose);
    await failContainer.read(groupProvider.future);
    // Seeded membership still present on fresh fail repo.
    expect(
      (await failContainer.read(
        currentUserGroupIdsProvider.future,
      )).contains(groupLa3.id),
      isTrue,
    );
    await expectLater(
      failContainer.read(groupProvider.notifier).leaveGroup(groupLa3.id),
      throwsException,
    );
    expect(
      (await failContainer.read(
        currentUserGroupIdsProvider.future,
      )).contains(groupLa3.id),
      isTrue,
    );
  });

  test('create group and create event refresh async providers', () async {
    final repo = _DelayedGroupRepository();
    final container = ProviderContainer(
      overrides: [groupRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await container.read(groupProvider.future);
    final beforeCount = container.read(groupProvider).requireValue.length;

    await container
        .read(groupProvider.notifier)
        .createGroup(
          name: 'Async Moms',
          description: 'Created after delay',
          category: '육아',
          location: 'Seoul',
        );

    expect(container.read(groupProvider).requireValue.length, beforeCount + 1);
    expect(
      (await container.read(
        currentUserGroupIdsProvider.future,
      )).any((id) => id.startsWith('grp_delayed_')),
      isTrue,
    );

    await container
        .read(groupProvider.notifier)
        .createEvent(
          groupId: groupLa3.id,
          title: 'Delayed Event',
          description: 'After await',
          dateTime: DateTime.now().add(const Duration(days: 2)),
          location: 'Park',
        );

    final events = await container.read(
      groupEventsProvider(groupLa3.id).future,
    );
    expect(events.any((e) => e.title == 'Delayed Event'), isTrue);
  });

  test('rsvp refreshes event RSVP provider', () async {
    final repo = _DelayedGroupRepository();
    final container = ProviderContainer(
      overrides: [groupRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await container.read(eventRsvpsProvider(eventLa3Library.id).future);
    await container
        .read(groupProvider.notifier)
        .setRsvp(eventId: eventLa3Library.id, status: RsvpStatus.attending);
    final rsvps = await container.read(
      eventRsvpsProvider(eventLa3Library.id).future,
    );
    expect(
      rsvps.any(
        (r) => r.userId == currentUserId && r.status == RsvpStatus.attending,
      ),
      isTrue,
    );
  });
}
