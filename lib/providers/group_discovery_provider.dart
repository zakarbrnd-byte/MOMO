import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/home/discovery/group_discovery_filters.dart';
import '../features/home/discovery/group_discovery_service.dart';
import '../features/home/discovery/group_recommendation.dart';
import '../models/group.dart';
import '../models/post.dart';
import 'current_user_provider.dart';
import 'group_provider.dart';
import 'post_provider.dart';

/// Home search query (trimmed usage happens in discovery service).
final groupSearchQueryProvider = StateProvider<String>((ref) => '');

class GroupDiscoveryFiltersNotifier extends Notifier<GroupDiscoveryFilters> {
  @override
  GroupDiscoveryFilters build() => GroupDiscoveryFilters.empty;

  void setFilters(GroupDiscoveryFilters filters) {
    state = filters;
  }

  void clear() {
    state = GroupDiscoveryFilters.empty;
  }

  void removeLocation(String value) {
    state = state.withoutLocation(value);
  }

  void removeAgeRange(String value) {
    state = state.withoutAgeRange(value);
  }

  void removeInterest(String value) {
    state = state.withoutInterest(value);
  }

  void removeCategory(String value) {
    state = state.withoutCategory(value);
  }

  void clearMembership() {
    state = state.withoutMembership();
  }
}

final groupDiscoveryFiltersProvider =
    NotifierProvider<GroupDiscoveryFiltersNotifier, GroupDiscoveryFilters>(
      GroupDiscoveryFiltersNotifier.new,
    );

/// Filter chip options derived from the loaded Group catalog.
final groupFilterOptionsProvider = Provider<AsyncValue<GroupFilterOptions>>((
  ref,
) {
  return ref
      .watch(groupProvider)
      .whenData(GroupDiscoveryService.extractFilterOptions);
});

/// Groups after search + filters (async-safe combine of Group + membership).
final filteredGroupsProvider = Provider<AsyncValue<List<Group>>>((ref) {
  final groupsAsync = ref.watch(groupProvider);
  final membershipAsync = ref.watch(currentUserGroupIdsProvider);
  final query = ref.watch(groupSearchQueryProvider);
  final filters = ref.watch(groupDiscoveryFiltersProvider);

  if (!groupsAsync.hasValue && groupsAsync.isLoading) {
    return const AsyncLoading();
  }
  if (groupsAsync.hasError && !groupsAsync.hasValue) {
    return AsyncError(
      groupsAsync.error!,
      groupsAsync.stackTrace ?? StackTrace.current,
    );
  }

  if (membershipAsync.hasError && !membershipAsync.hasValue) {
    return AsyncError(
      membershipAsync.error!,
      membershipAsync.stackTrace ?? StackTrace.current,
    );
  }

  final groups = groupsAsync.requireValue;
  final joined = membershipAsync.valueOrNull ?? const <String>{};

  return AsyncData(
    GroupDiscoveryService.applySearchAndFilters(
      groups: groups,
      query: query,
      filters: filters,
      joinedGroupIds: joined,
    ),
  );
});

/// Screen-ready discovery sections / search results.
final homeDiscoveryProvider = Provider<AsyncValue<HomeDiscoveryView>>((ref) {
  final groupsAsync = ref.watch(groupProvider);
  final membershipAsync = ref.watch(currentUserGroupIdsProvider);
  final query = ref.watch(groupSearchQueryProvider);
  final filters = ref.watch(groupDiscoveryFiltersProvider);
  final user = ref.watch(currentUserProvider);

  if (!groupsAsync.hasValue && groupsAsync.isLoading) {
    return const AsyncLoading();
  }
  if (groupsAsync.hasError && !groupsAsync.hasValue) {
    return AsyncError(
      groupsAsync.error!,
      groupsAsync.stackTrace ?? StackTrace.current,
    );
  }

  if (membershipAsync.hasError && !membershipAsync.hasValue) {
    return AsyncError(
      membershipAsync.error!,
      membershipAsync.stackTrace ?? StackTrace.current,
    );
  }

  final groups = groupsAsync.requireValue;
  final joined = membershipAsync.valueOrNull ?? const <String>{};

  return AsyncData(
    GroupDiscoveryService.buildDiscoveryView(
      groups: groups,
      user: user,
      joinedGroupIds: joined,
      query: query,
      filters: filters,
    ),
  );
});

/// Global community posts for the secondary Home section (not search targets).
final homeCommunityPostsProvider = Provider<AsyncValue<List<Post>>>((ref) {
  return ref
      .watch(postProvider)
      .whenData(
        (posts) => [
          for (final post in posts)
            if (post.isGlobal) post,
        ],
      );
});
