import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/entity_status.dart';
import '../models/group.dart';
import '../models/post.dart';
import '../repositories/group_repository.dart';
import '../repositories/repository_providers.dart';
import 'current_user_provider.dart';
import 'post_provider.dart';

/// Group list as [AsyncValue]. Repository Futures are always awaited.
class GroupNotifier extends AsyncNotifier<List<Group>> {
  GroupRepository get _repo => ref.read(groupRepositoryProvider);

  @override
  Future<List<Group>> build() => _repo.load();

  List<Group> get groups => state.valueOrNull ?? const [];

  /// Reload groups while preserving previous data when possible.
  Future<void> refreshGroups() async {
    final previous = state;
    state = const AsyncLoading<List<Group>>().copyWithPrevious(previous);
    state = await AsyncValue.guard(_repo.load);
  }

  Future<void> joinGroup(String groupId) async {
    final user = ref.read(currentUserProvider);
    final result = await _repo.join(
      groupId: groupId,
      userId: user.id,
      userName: user.displayName,
    );
    if (!result.isSuccess) {
      throw Exception(result.errorOrNull ?? 'Could not join group.');
    }
    ref.invalidate(currentUserGroupIdsProvider);
    ref.invalidate(groupMembersProvider(groupId));
    await refreshGroups();
  }

  Future<void> leaveGroup(String groupId) async {
    final user = ref.read(currentUserProvider);
    final result = await _repo.leave(groupId: groupId, userId: user.id);
    if (!result.isSuccess) {
      throw Exception(result.errorOrNull ?? 'Could not leave group.');
    }
    ref.invalidate(currentUserGroupIdsProvider);
    ref.invalidate(groupMembersProvider(groupId));
    await refreshGroups();
  }

  Future<void> createGroup({
    required String name,
    required String description,
    required String category,
    required String location,
    List<String> childAgeRanges = const [],
    List<String> interestTags = const [],
    String? coverEmoji,
  }) async {
    final user = ref.read(currentUserProvider);
    final result = await _repo.createGroup(
      name: name,
      description: description,
      category: category,
      location: location,
      ownerId: user.id,
      ownerName: user.displayName,
      childAgeRanges: childAgeRanges,
      interestTags: interestTags,
      coverEmoji: coverEmoji,
    );
    if (!result.isSuccess) {
      throw Exception(result.errorOrNull ?? 'Could not create group.');
    }
    ref.invalidate(currentUserGroupIdsProvider);
    await refreshGroups();
  }

  Future<void> createEvent({
    required String groupId,
    required String title,
    required String description,
    required DateTime dateTime,
    required String location,
    String childAgeRange = '',
    int? participantLimit,
  }) async {
    final user = ref.read(currentUserProvider);
    final result = await _repo.createEvent(
      groupId: groupId,
      creatorId: user.id,
      creatorName: user.displayName,
      title: title,
      description: description,
      dateTime: dateTime,
      location: location,
      childAgeRange: childAgeRange,
      participantLimit: participantLimit,
    );
    if (!result.isSuccess) {
      throw Exception(result.errorOrNull ?? 'Could not create event.');
    }
    ref.invalidate(groupEventsProvider(groupId));
  }

  Future<void> setRsvp({
    required String eventId,
    required RsvpStatus status,
  }) async {
    final user = ref.read(currentUserProvider);
    final result = await _repo.setRsvp(
      Rsvp(
        eventId: eventId,
        userId: user.id,
        userName: user.displayName,
        status: status,
        updatedAt: DateTime.now(),
      ),
    );
    if (!result.isSuccess) {
      throw Exception(result.errorOrNull ?? 'Could not update RSVP.');
    }
    ref.invalidate(eventRsvpsProvider(eventId));
  }
}

final groupProvider =
    AsyncNotifierProvider<GroupNotifier, List<Group>>(GroupNotifier.new);

/// Joined group ids for the current user (async source of truth).
final currentUserGroupIdsProvider = FutureProvider<Set<String>>((ref) async {
  final user = ref.watch(currentUserProvider);
  final repo = ref.watch(groupRepositoryProvider);
  return repo.loadJoinedGroupIds(user.id);
});

/// Single group by id. Prefers the loaded group list when available.
final groupByIdProvider =
    FutureProvider.family<Group?, String>((ref, groupId) async {
  final groupsAsync = ref.watch(groupProvider);
  final groups = groupsAsync.valueOrNull;
  if (groups != null) {
    for (final group in groups) {
      if (group.id == groupId) return group;
    }
    return null;
  }
  if (groupsAsync.hasError) {
    Error.throwWithStackTrace(
      groupsAsync.error!,
      groupsAsync.stackTrace ?? StackTrace.current,
    );
  }
  return ref.watch(groupRepositoryProvider).getById(groupId);
});

final groupMembersProvider =
    FutureProvider.family<List<GroupMember>, String>((ref, groupId) async {
  return ref.watch(groupRepositoryProvider).loadMembers(groupId);
});

final groupEventsProvider =
    FutureProvider.family<List<EventAnnouncement>, String>(
        (ref, groupId) async {
  return ref.watch(groupRepositoryProvider).loadEvents(groupId);
});

final eventByIdProvider =
    FutureProvider.family<EventAnnouncement?, String>((ref, eventId) async {
  return ref.watch(groupRepositoryProvider).getEventById(eventId);
});

final eventRsvpsProvider =
    FutureProvider.family<List<Rsvp>, String>((ref, eventId) async {
  return ref.watch(groupRepositoryProvider).loadRsvps(eventId);
});

/// Group-scoped posts derived from [postProvider] (no sync repository bridge).
final groupPostsProvider =
    Provider.family<AsyncValue<List<Post>>, String>((ref, groupId) {
  return ref.watch(postProvider).whenData(
        (posts) => [
          for (final post in posts)
            if (post.groupId == groupId) post,
        ],
      );
});
