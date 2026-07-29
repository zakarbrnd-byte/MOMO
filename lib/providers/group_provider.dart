import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/result/result.dart';
import '../models/entity_status.dart';
import '../models/group.dart';
import '../repositories/group_repository.dart';
import '../repositories/repository_providers.dart';
import 'current_user_provider.dart';

T _readSync<T>(Future<T> future) {
  late T value;
  var completed = false;
  future.then((result) {
    value = result;
    completed = true;
  });
  assert(
    completed,
    'GroupRepository Futures must complete synchronously in the mock MVP.',
  );
  return value;
}

bool _ok(Result<bool> result) => result.isSuccess;

/// Group list as [AsyncValue].
class GroupNotifier extends AsyncNotifier<List<Group>> {
  GroupRepository get _repo => ref.watch(groupRepositoryProvider);

  @override
  Future<List<Group>> build() => _repo.load();

  List<Group> get groups => state.valueOrNull ?? const [];

  void _refresh() {
    state = AsyncData(_readSync(_repo.load()));
  }

  Group? getById(String id) {
    for (final group in groups) {
      if (group.id == id) return group;
    }
    return _readSync(_repo.getById(id));
  }

  bool isMember(String groupId) {
    final userId = ref.read(currentUserProvider).id;
    final members = _readSync(_repo.loadMembers(groupId));
    return members.any((m) => m.userId == userId);
  }

  List<GroupMember> membersOf(String groupId) {
    return _readSync(_repo.loadMembers(groupId));
  }

  void joinGroup(String groupId) {
    final user = ref.read(currentUserProvider);
    final result = _readSync(
      _repo.join(
        groupId: groupId,
        userId: user.id,
        userName: user.displayName,
      ),
    );
    if (!_ok(result)) {
      throw Exception(result.errorOrNull ?? 'Could not join group.');
    }
    _refresh();
  }

  void leaveGroup(String groupId) {
    final user = ref.read(currentUserProvider);
    final result = _readSync(
      _repo.leave(groupId: groupId, userId: user.id),
    );
    if (!_ok(result)) {
      throw Exception(result.errorOrNull ?? 'Could not leave group.');
    }
    _refresh();
  }

  void createGroup({
    required String name,
    required String description,
    required String category,
    required String location,
    List<String> childAgeRanges = const [],
    List<String> interestTags = const [],
    String? coverEmoji,
  }) {
    final user = ref.read(currentUserProvider);
    final result = _readSync(
      _repo.createGroup(
        name: name,
        description: description,
        category: category,
        location: location,
        ownerId: user.id,
        ownerName: user.displayName,
        childAgeRanges: childAgeRanges,
        interestTags: interestTags,
        coverEmoji: coverEmoji,
      ),
    );
    if (!_ok(result)) {
      throw Exception(result.errorOrNull ?? 'Could not create group.');
    }
    _refresh();
  }

  List<EventAnnouncement> eventsOf(String groupId) {
    return _readSync(_repo.loadEvents(groupId));
  }

  EventAnnouncement? eventById(String id) {
    return _readSync(_repo.getEventById(id));
  }

  void createEvent({
    required String groupId,
    required String title,
    required String description,
    required DateTime dateTime,
    required String location,
    String childAgeRange = '',
    int? participantLimit,
  }) {
    final user = ref.read(currentUserProvider);
    final result = _readSync(
      _repo.createEvent(
        groupId: groupId,
        creatorId: user.id,
        creatorName: user.displayName,
        title: title,
        description: description,
        dateTime: dateTime,
        location: location,
        childAgeRange: childAgeRange,
        participantLimit: participantLimit,
      ),
    );
    if (!_ok(result)) {
      throw Exception(result.errorOrNull ?? 'Could not create event.');
    }
    _refresh();
  }

  List<Rsvp> rsvpsOf(String eventId) {
    return _readSync(_repo.loadRsvps(eventId));
  }

  void setRsvp({
    required String eventId,
    required RsvpStatus status,
  }) {
    final user = ref.read(currentUserProvider);
    final result = _readSync(
      _repo.setRsvp(
        Rsvp(
          eventId: eventId,
          userId: user.id,
          userName: user.displayName,
          status: status,
          updatedAt: DateTime.now(),
        ),
      ),
    );
    if (!_ok(result)) {
      throw Exception(result.errorOrNull ?? 'Could not update RSVP.');
    }
    // RSVP store is separate from group list; bump state so watchers rebuild.
    _refresh();
  }
}

final groupProvider =
    AsyncNotifierProvider<GroupNotifier, List<Group>>(GroupNotifier.new);

/// Membership ids for the current user (derived).
final currentUserGroupIdsProvider = Provider<Set<String>>((ref) {
  final groupsAsync = ref.watch(groupProvider);
  final groups = groupsAsync.valueOrNull ?? const <Group>[];
  final notifier = ref.read(groupProvider.notifier);
  return {
    for (final group in groups)
      if (notifier.isMember(group.id)) group.id,
  };
});
