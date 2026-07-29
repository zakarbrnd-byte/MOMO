import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/data/mock_groups.dart';
import 'package:momo/data/mock_user.dart';
import 'package:momo/features/home/discovery/group_discovery_filters.dart';
import 'package:momo/features/home/discovery/group_discovery_service.dart';
import 'package:momo/models/group.dart';
import 'package:momo/models/user.dart';
import 'package:momo/providers/group_discovery_provider.dart';
import 'package:momo/providers/group_provider.dart';

void main() {
  final baseGroups = [
    groupLa3,
    groupOcWork,
    groupSwim,
    groupBook,
    groupCafe,
    groupOcPark,
  ];

  group('GroupDiscoveryService search', () {
    test('matches group name', () {
      expect(
        GroupDiscoveryService.groupMatchesSearch(groupLa3, '3살'),
        isTrue,
      );
    });

    test('matches description', () {
      expect(
        GroupDiscoveryService.groupMatchesSearch(groupLa3, '키즈카페'),
        isTrue,
      );
    });

    test('matches location', () {
      expect(
        GroupDiscoveryService.groupMatchesSearch(groupLa3, 'Koreatown'),
        isTrue,
      );
    });

    test('matches category', () {
      expect(
        GroupDiscoveryService.groupMatchesSearch(groupOcWork, '워킹맘'),
        isTrue,
      );
    });

    test('matches child age', () {
      expect(
        GroupDiscoveryService.groupMatchesSearch(groupLa3, '2–4세'),
        isTrue,
      );
    });

    test('matches interest tag', () {
      expect(
        GroupDiscoveryService.groupMatchesSearch(groupLa3, '도서관'),
        isTrue,
      );
    });

    test('is case-insensitive for English', () {
      expect(
        GroupDiscoveryService.groupMatchesSearch(groupLa3, 'koreatown'),
        isTrue,
      );
    });

    test('blank search matches all', () {
      for (final group in baseGroups) {
        expect(GroupDiscoveryService.groupMatchesSearch(group, '  '), isTrue);
        expect(GroupDiscoveryService.groupMatchesSearch(group, ''), isTrue);
      }
    });

    test('normalizeSearchText collapses whitespace', () {
      expect(
        GroupDiscoveryService.normalizeSearchText('  LA   3살  '),
        'LA 3살',
      );
      expect(GroupDiscoveryService.isActiveSearch('   '), isFalse);
    });
  });

  group('GroupDiscoveryService filters', () {
    test('location filters use OR within category', () {
      final filters = GroupDiscoveryFilters(
        locations: {
          groupLa3.location,
          groupOcWork.location,
        },
      );
      expect(
        GroupDiscoveryService.groupMatchesFilters(
          group: groupLa3,
          filters: filters,
          joinedGroupIds: const {},
        ),
        isTrue,
      );
      expect(
        GroupDiscoveryService.groupMatchesFilters(
          group: groupSwim,
          filters: filters,
          joinedGroupIds: const {},
        ),
        isFalse,
      );
    });

    test('different filter categories use AND', () {
      final filters = GroupDiscoveryFilters(
        locations: {groupLa3.location},
        ageRanges: {'2–4세'},
        interests: {'도서관'},
      );
      expect(
        GroupDiscoveryService.groupMatchesFilters(
          group: groupLa3,
          filters: filters,
          joinedGroupIds: const {},
        ),
        isTrue,
      );
      expect(
        GroupDiscoveryService.groupMatchesFilters(
          group: groupCafe,
          filters: filters,
          joinedGroupIds: const {},
        ),
        isFalse,
      );
    });

    test('interest filters match at least one selected tag', () {
      final filters = GroupDiscoveryFilters(
        interests: {'도서관', '수영'},
      );
      expect(
        GroupDiscoveryService.groupMatchesFilters(
          group: groupLa3,
          filters: filters,
          joinedGroupIds: const {},
        ),
        isTrue,
      );
      expect(
        GroupDiscoveryService.groupMatchesFilters(
          group: groupSwim,
          filters: filters,
          joinedGroupIds: const {},
        ),
        isTrue,
      );
      expect(
        GroupDiscoveryService.groupMatchesFilters(
          group: groupOcWork,
          filters: filters,
          joinedGroupIds: const {},
        ),
        isFalse,
      );
    });

    test('membership filter works', () {
      const joined = {'grp_la3'};
      expect(
        GroupDiscoveryService.groupMatchesFilters(
          group: groupLa3,
          filters: const GroupDiscoveryFilters(
            membership: GroupMembershipFilter.joined,
          ),
          joinedGroupIds: joined,
        ),
        isTrue,
      );
      expect(
        GroupDiscoveryService.groupMatchesFilters(
          group: groupBook,
          filters: const GroupDiscoveryFilters(
            membership: GroupMembershipFilter.joined,
          ),
          joinedGroupIds: joined,
        ),
        isFalse,
      );
      expect(
        GroupDiscoveryService.groupMatchesFilters(
          group: groupBook,
          filters: const GroupDiscoveryFilters(
            membership: GroupMembershipFilter.notJoined,
          ),
          joinedGroupIds: joined,
        ),
        isTrue,
      );
    });

    test('clear filters resets state and active count', () {
      final filters = GroupDiscoveryFilters(
        locations: {'Koreatown, Los Angeles'},
        ageRanges: {'2–4세'},
        membership: GroupMembershipFilter.joined,
      );
      expect(filters.activeCount, 3);
      expect(filters.clear().isEmpty, isTrue);
      expect(filters.clear().activeCount, 0);
    });

    test('extractFilterOptions ignores blanks and sorts', () {
      const messy = Group(
        id: 'g',
        name: 'n',
        description: 'd',
        category: ' 육아 ',
        location: '  ',
        ownerId: 'u',
        ownerName: 'Ann',
        childAgeRanges: ['', ' 3세 ', '3세'],
        interestTags: ['도서관', ' 도서관 ', ''],
      );
      final options =
          GroupDiscoveryService.extractFilterOptions([messy, groupOcWork]);
      expect(options.locations, isNot(contains('')));
      expect(options.locations, contains(groupOcWork.location));
      expect(options.ageRanges, contains('3세'));
      expect(options.interests.where((e) => e == '도서관').length, 1);
      expect(options.categories, contains('육아'));
    });
  });

  group('GroupDiscoveryService recommendations', () {
    test('scoring is deterministic and rewards location/age/interest', () {
      final a = GroupDiscoveryService.scoreGroup(
        group: groupBook,
        user: currentUser,
        isJoined: false,
      );
      final b = GroupDiscoveryService.scoreGroup(
        group: groupBook,
        user: currentUser,
        isJoined: false,
      );
      expect(a.score, b.score);
      expect(a.reasons, b.reasons);
      expect(a.score, greaterThanOrEqualTo(40 + 30));
      expect(a.reasons, contains('내 지역과 가까워요'));
      expect(a.reasons, contains('아이 연령이 비슷해요'));
      expect(
        a.reasons.any((r) => r.contains('관심사')),
        isTrue,
      );
    });

    test('joined groups are excluded from primary recommendations', () {
      final view = GroupDiscoveryService.buildDiscoveryView(
        groups: baseGroups,
        user: currentUser,
        joinedGroupIds: {'grp_la3', 'grp_park'},
        query: '',
        filters: GroupDiscoveryFilters.empty,
      );
      expect(
        view.recommended.any((r) => r.group.id == 'grp_la3'),
        isFalse,
      );
      expect(view.recommended, isNotEmpty);
      for (final item in view.recommended) {
        expect(item.reasons, isNotEmpty);
        expect(item.score, greaterThan(0));
      }
    });

    test('tie-breaking is stable', () {
      const lowA = Group(
        id: 'a',
        name: 'Alpha',
        description: 'd',
        category: '육아',
        location: 'Elsewhere',
        ownerId: 'u',
        ownerName: 'Ann',
        memberCount: 2,
        isFeatured: true,
      );
      const lowB = Group(
        id: 'b',
        name: 'Beta',
        description: 'd',
        category: '육아',
        location: 'Elsewhere',
        ownerId: 'u',
        ownerName: 'Ann',
        memberCount: 2,
        isFeatured: true,
      );
      final user = const User(id: 'u', displayName: 'Ann');
      final sorted = GroupDiscoveryService.sortRecommendations([
        GroupDiscoveryService.scoreGroup(
          group: lowB,
          user: user,
          isJoined: false,
        ),
        GroupDiscoveryService.scoreGroup(
          group: lowA,
          user: user,
          isJoined: false,
        ),
      ]);
      expect(sorted.first.group.id, 'a');
      expect(sorted.last.group.id, 'b');
    });

    test('section deduplication works', () {
      final view = GroupDiscoveryService.buildDiscoveryView(
        groups: mockGroups,
        user: currentUser,
        joinedGroupIds: {'grp_la3', 'grp_park'},
        query: '',
        filters: GroupDiscoveryFilters.empty,
      );
      final ids = <String>{};
      for (final item in [
        ...view.recommended,
        ...view.nearby,
        ...view.similarAge,
      ]) {
        expect(ids.contains(item.group.id), isFalse);
        ids.add(item.group.id);
      }
      for (final group in view.newest) {
        expect(ids.contains(group.id), isFalse);
        ids.add(group.id);
      }
      expect(view.allGroups.length, mockGroups.length - 0);
      expect(
        view.allGroups.map((g) => g.id).toSet().length,
        view.allGroups.length,
      );
    });

    test('search mode hides recommendation sections', () {
      final view = GroupDiscoveryService.buildDiscoveryView(
        groups: mockGroups,
        user: currentUser,
        joinedGroupIds: const {},
        query: '도서관',
        filters: GroupDiscoveryFilters.empty,
      );
      expect(view.isSearchMode, isTrue);
      expect(view.recommended, isEmpty);
      expect(view.nearby, isEmpty);
      expect(view.resultCount, greaterThan(0));
    });
  });

  group('discovery providers', () {
    test('filteredGroupsProvider combines search and filters', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(groupProvider.future);
      await container.read(currentUserGroupIdsProvider.future);

      container.read(groupSearchQueryProvider.notifier).state = '도서관';
      final filtered = container.read(filteredGroupsProvider).requireValue;
      expect(filtered, isNotEmpty);
      for (final group in filtered) {
        expect(
          GroupDiscoveryService.groupMatchesSearch(group, '도서관'),
          isTrue,
        );
      }

      container.read(groupDiscoveryFiltersProvider.notifier).setFilters(
            GroupDiscoveryFilters(
              locations: {groupBook.location},
            ),
          );
      final filtered2 = container.read(filteredGroupsProvider).requireValue;
      for (final group in filtered2) {
        expect(group.location, groupBook.location);
      }
    });

    test('membership changes update discovery', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(groupProvider.future);
      await container.read(currentUserGroupIdsProvider.future);

      final before =
          container.read(homeDiscoveryProvider).requireValue.recommended;
      final beforeIds = before.map((e) => e.group.id).toSet();

      await container.read(groupProvider.notifier).joinGroup('grp_book');
      await container.read(currentUserGroupIdsProvider.future);

      final after =
          container.read(homeDiscoveryProvider).requireValue.recommended;
      expect(after.any((e) => e.group.id == 'grp_book'), isFalse);
      if (beforeIds.contains('grp_book')) {
        expect(after.length, lessThanOrEqualTo(before.length));
      }
    });

    test('filter options derived from group data', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(groupProvider.future);
      final options = container.read(groupFilterOptionsProvider).requireValue;
      expect(options.locations, isNotEmpty);
      expect(options.categories, contains('육아'));
      expect(options.interests, contains('도서관'));
    });

    test('group loading error surfaces on homeDiscoveryProvider', () async {
      final container = ProviderContainer(
        overrides: [
          groupProvider.overrideWith(_ErrorGroups.new),
        ],
      );
      addTearDown(container.dispose);

      // Allow async error to settle on the notifier.
      await expectLater(
        container.read(groupProvider.future),
        throwsA(isA<Exception>()),
      );
      final discovery = container.read(homeDiscoveryProvider);
      expect(discovery.hasError, isTrue);
    });
  });
}

class _ErrorGroups extends GroupNotifier {
  @override
  Future<List<Group>> build() async {
    throw Exception('boom');
  }
}
