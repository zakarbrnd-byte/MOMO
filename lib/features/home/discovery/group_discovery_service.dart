import '../../../models/group.dart';
import '../../../models/user.dart';
import 'group_discovery_filters.dart';
import 'group_recommendation.dart';

/// Local Group discovery helpers (search, filters, recommendations).
///
/// Deterministic, side-effect free — no providers, BuildContext, or DateTime.now.
abstract final class GroupDiscoveryService {
  static const int maxRecommended = 5;
  static const int maxSectionSize = 4;
  static const int maxNewest = 4;

  /// Scoring weights (local heuristic — not ML / AI).
  static const int locationScore = 40;
  static const int ageScore = 30;
  static const int interestScorePerTag = 15;
  static const int featuredScore = 10;
  static const int joinedPenalty = 100;

  // ── Search ────────────────────────────────────────────────────────────

  /// Trim, collapse repeated whitespace. Empty after normalize → not a search.
  static String normalizeSearchText(String query) {
    return query.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static bool isActiveSearch(String query) =>
      normalizeSearchText(query).isNotEmpty;

  /// Case-insensitive English; Korean preserved; partial match across fields.
  static bool groupMatchesSearch(Group group, String query) {
    final normalized = normalizeSearchText(query);
    if (normalized.isEmpty) return true;

    final needle = normalized.toLowerCase();
    for (final haystack in _searchableFields(group)) {
      if (haystack.toLowerCase().contains(needle)) return true;
    }
    return false;
  }

  static Iterable<String> _searchableFields(Group group) sync* {
    yield group.name;
    yield group.description;
    yield group.category;
    yield group.location;
    yield* group.childAgeRanges;
    yield* group.interestTags;
  }

  // ── Filters ───────────────────────────────────────────────────────────

  /// Within a category: OR. Across categories: AND.
  /// Interests: at least one selected tag (OR within interest set).
  static bool groupMatchesFilters({
    required Group group,
    required GroupDiscoveryFilters filters,
    required Set<String> joinedGroupIds,
  }) {
    if (filters.locations.isNotEmpty) {
      if (!filters.locations.contains(group.location.trim())) {
        return false;
      }
    }

    if (filters.ageRanges.isNotEmpty) {
      final ages = group.childAgeRanges.map((e) => e.trim()).toSet();
      if (!filters.ageRanges.any(ages.contains)) {
        return false;
      }
    }

    if (filters.interests.isNotEmpty) {
      final tags = group.interestTags.map((e) => e.trim()).toSet();
      if (!filters.interests.any(tags.contains)) {
        return false;
      }
    }

    if (filters.categories.isNotEmpty) {
      if (!filters.categories.contains(group.category.trim())) {
        return false;
      }
    }

    switch (filters.membership) {
      case GroupMembershipFilter.all:
        break;
      case GroupMembershipFilter.joined:
        if (!joinedGroupIds.contains(group.id)) return false;
      case GroupMembershipFilter.notJoined:
        if (joinedGroupIds.contains(group.id)) return false;
    }

    return true;
  }

  static List<Group> applySearchAndFilters({
    required List<Group> groups,
    required String query,
    required GroupDiscoveryFilters filters,
    required Set<String> joinedGroupIds,
  }) {
    return [
      for (final group in groups)
        if (groupMatchesSearch(group, query) &&
            groupMatchesFilters(
              group: group,
              filters: filters,
              joinedGroupIds: joinedGroupIds,
            ))
          group,
    ];
  }

  /// Unique option lists from dataset (trimmed, non-blank, sorted).
  static GroupFilterOptions extractFilterOptions(List<Group> groups) {
    final locations = <String>{};
    final ages = <String>{};
    final interests = <String>{};
    final categories = <String>{};

    for (final group in groups) {
      final location = group.location.trim();
      if (location.isNotEmpty) locations.add(location);

      final category = group.category.trim();
      if (category.isNotEmpty) categories.add(category);

      for (final age in group.childAgeRanges) {
        final trimmed = age.trim();
        if (trimmed.isNotEmpty) ages.add(trimmed);
      }
      for (final tag in group.interestTags) {
        final trimmed = tag.trim();
        if (trimmed.isNotEmpty) interests.add(trimmed);
      }
    }

    return GroupFilterOptions(
      locations: _sortedStrings(locations),
      ageRanges: _sortedStrings(ages),
      interests: _sortedStrings(interests),
      categories: _sortedStrings(categories),
    );
  }

  static List<String> _sortedStrings(Set<String> values) {
    final list = values.toList()..sort(_compareLocaleSafe);
    return list;
  }

  /// Stable locale-safe ordering (code-unit compare; fine for KO + EN MVP).
  static int _compareLocaleSafe(String a, String b) => a.compareTo(b);

  // ── Location / age helpers ────────────────────────────────────────────

  /// Local mock location matching only; not GPS distance.
  static bool locationMatchesUser(Group group, User user) {
    final userLocation = user.location?.trim();
    if (userLocation == null || userLocation.isEmpty) return false;

    final groupLocation = group.location.trim();
    if (groupLocation.isEmpty) return false;

    final userNorm = _normalizeLocationToken(userLocation);
    final groupNorm = _normalizeLocationToken(groupLocation);
    if (userNorm.isEmpty || groupNorm.isEmpty) return false;

    return userNorm == groupNorm ||
        groupNorm.contains(userNorm) ||
        userNorm.contains(groupNorm) ||
        _locationTokensOverlap(userLocation, groupLocation);
  }

  static String _normalizeLocationToken(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static bool _locationTokensOverlap(String a, String b) {
    final tokensA = _significantLocationTokens(a);
    final tokensB = _significantLocationTokens(b);
    if (tokensA.isEmpty || tokensB.isEmpty) return false;
    return tokensA.any(tokensB.contains);
  }

  static Set<String> _significantLocationTokens(String value) {
    const stop = {'los', 'angeles', 'orange', 'county', 'and', 'the', '/'};
    return {
      for (final part in value.toLowerCase().split(RegExp(r'[,/]')))
        for (final word in part.trim().split(RegExp(r'\s+')))
          if (word.length >= 3 && !stop.contains(word)) word,
    };
  }

  /// True when any user child age overlaps a Group age range label.
  static bool ageMatchesUser(Group group, User user) {
    final childAges = [
      for (final child in user.children)
        if (child.ageLabel != null && child.ageLabel!.trim().isNotEmpty)
          child.ageLabel!.trim(),
    ];
    if (childAges.isEmpty || group.childAgeRanges.isEmpty) return false;

    for (final childAge in childAges) {
      final ageNum = int.tryParse(
        RegExp(r'\d+').firstMatch(childAge)?.group(0) ?? '',
      );
      for (final range in group.childAgeRanges) {
        if (_ageLabelMatchesRange(childAge, range, ageNum)) return true;
      }
    }
    return false;
  }

  static bool _ageLabelMatchesRange(
    String childAge,
    String range,
    int? ageNum,
  ) {
    final trimmed = range.trim();
    if (trimmed.isEmpty) return false;

    // Direct substring (e.g. "4" in "4–6세", or "3세" overlap).
    if (trimmed.contains(childAge) || childAge.contains(trimmed)) {
      return true;
    }

    if (ageNum == null) return false;

    final nums = RegExp(r'\d+')
        .allMatches(trimmed)
        .map((m) => int.tryParse(m.group(0)!))
        .whereType<int>()
        .toList();
    if (nums.isEmpty) return false;
    if (nums.length == 1) return ageNum == nums.first;
    final lo = nums.reduce((a, b) => a < b ? a : b);
    final hi = nums.reduce((a, b) => a > b ? a : b);
    return ageNum >= lo && ageNum <= hi;
  }

  static List<String> matchingInterestTags(Group group, User user) {
    final userTags = {
      for (final tag in user.interestTags)
        if (tag.trim().isNotEmpty) tag.trim(),
    };
    if (userTags.isEmpty) return const [];
    return [
      for (final tag in group.interestTags)
        if (userTags.contains(tag.trim())) tag.trim(),
    ];
  }

  // ── Recommendations ───────────────────────────────────────────────────

  static GroupRecommendation scoreGroup({
    required Group group,
    required User user,
    required bool isJoined,
  }) {
    var score = 0;
    final reasons = <String>[];

    if (locationMatchesUser(group, user)) {
      score += locationScore;
      reasons.add('내 지역과 가까워요');
    }

    if (ageMatchesUser(group, user)) {
      score += ageScore;
      reasons.add('아이 연령이 비슷해요');
    }

    final matchedInterests = matchingInterestTags(group, user);
    if (matchedInterests.isNotEmpty) {
      score += interestScorePerTag * matchedInterests.length;
      if (matchedInterests.length == 1) {
        reasons.add('관심사가 일치해요');
      } else {
        reasons.add('관심사가 ${matchedInterests.length}개 일치해요');
      }
    }

    if (group.isFeatured) {
      score += featuredScore;
      reasons.add('추천 모임');
    }

    if (isJoined) {
      score -= joinedPenalty;
    }

    return GroupRecommendation(group: group, score: score, reasons: reasons);
  }

  static int compareRecommendations(
    GroupRecommendation a,
    GroupRecommendation b,
  ) {
    final byScore = b.score.compareTo(a.score);
    if (byScore != 0) return byScore;

    final byReasons = b.reasons.length.compareTo(a.reasons.length);
    if (byReasons != 0) return byReasons;

    final byMembers = b.group.memberCount.compareTo(a.group.memberCount);
    if (byMembers != 0) return byMembers;

    final aCreated = a.group.createdAt;
    final bCreated = b.group.createdAt;
    if (aCreated != null && bCreated != null) {
      final byCreated = bCreated.compareTo(aCreated);
      if (byCreated != 0) return byCreated;
    } else if (aCreated != null && bCreated == null) {
      return -1;
    } else if (aCreated == null && bCreated != null) {
      return 1;
    }

    return _compareLocaleSafe(a.group.name, b.group.name);
  }

  static List<GroupRecommendation> sortRecommendations(
    List<GroupRecommendation> items,
  ) {
    final sorted = [...items]..sort(compareRecommendations);
    return sorted;
  }

  /// Catalog order: featured → member count desc → name.
  static List<Group> sortAllGroups(List<Group> groups) {
    final sorted = [...groups]
      ..sort((a, b) {
        if (a.isFeatured != b.isFeatured) {
          return a.isFeatured ? -1 : 1;
        }
        final byMembers = b.memberCount.compareTo(a.memberCount);
        if (byMembers != 0) return byMembers;
        return _compareLocaleSafe(a.name, b.name);
      });
    return sorted;
  }

  static List<Group> sortNewest(List<Group> groups) {
    final withDates = [
      for (final g in groups)
        if (g.createdAt != null) g,
    ];
    withDates.sort((a, b) {
      final byCreated = b.createdAt!.compareTo(a.createdAt!);
      if (byCreated != 0) return byCreated;
      return _compareLocaleSafe(a.name, b.name);
    });
    return withDates;
  }

  /// Build Home sections with dedupe:
  /// 추천 → 내 주변 → 아이 연령 → 새로운; 전체 모임 keeps full catalog.
  static HomeDiscoveryView buildDiscoveryView({
    required List<Group> groups,
    required User user,
    required Set<String> joinedGroupIds,
    required String query,
    required GroupDiscoveryFilters filters,
  }) {
    final filtered = applySearchAndFilters(
      groups: groups,
      query: query,
      filters: filters,
      joinedGroupIds: joinedGroupIds,
    );

    if (isActiveSearch(query)) {
      return HomeDiscoveryView(
        isSearchMode: true,
        filteredGroups: sortAllGroups(filtered),
        recommended: const [],
        nearby: const [],
        similarAge: const [],
        newest: const [],
        allGroups: sortAllGroups(filtered),
      );
    }

    final scored = [
      for (final group in filtered)
        scoreGroup(
          group: group,
          user: user,
          isJoined: joinedGroupIds.contains(group.id),
        ),
    ];

    final usedIds = <String>{};

    final recommended = sortRecommendations([
      for (final item in scored)
        if (!joinedGroupIds.contains(item.group.id) &&
            item.reasons.isNotEmpty &&
            item.score > 0)
          item,
    ]).take(maxRecommended).toList(growable: false);
    usedIds.addAll(recommended.map((e) => e.group.id));

    // Local mock location matching only; not GPS distance.
    final nearby = <GroupRecommendation>[];
    if (user.location != null && user.location!.trim().isNotEmpty) {
      final nearbyCandidates = sortRecommendations([
        for (final item in scored)
          if (!joinedGroupIds.contains(item.group.id) &&
              !usedIds.contains(item.group.id) &&
              locationMatchesUser(item.group, user))
            item,
      ]);
      nearby.addAll(nearbyCandidates.take(maxSectionSize));
      usedIds.addAll(nearby.map((e) => e.group.id));
    }

    final similarAge = <GroupRecommendation>[];
    final hasChildAge = user.children.any(
      (c) => c.ageLabel != null && c.ageLabel!.trim().isNotEmpty,
    );
    if (hasChildAge) {
      final ageCandidates = sortRecommendations([
        for (final item in scored)
          if (!joinedGroupIds.contains(item.group.id) &&
              !usedIds.contains(item.group.id) &&
              ageMatchesUser(item.group, user))
            item,
      ]);
      similarAge.addAll(ageCandidates.take(maxSectionSize));
      usedIds.addAll(similarAge.map((e) => e.group.id));
    }

    final newest = sortNewest([
      for (final group in filtered)
        if (!joinedGroupIds.contains(group.id) && !usedIds.contains(group.id))
          group,
    ]).take(maxNewest).toList(growable: false);

    return HomeDiscoveryView(
      isSearchMode: false,
      filteredGroups: filtered,
      recommended: recommended,
      nearby: nearby,
      similarAge: similarAge,
      newest: newest,
      allGroups: sortAllGroups(filtered),
    );
  }
}
