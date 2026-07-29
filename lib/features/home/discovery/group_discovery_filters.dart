/// Membership facet for Group discovery filters.
enum GroupMembershipFilter {
  all,
  joined,
  notJoined,
}

/// Immutable discovery filter state (no UI / BuildContext).
class GroupDiscoveryFilters {
  const GroupDiscoveryFilters({
    this.locations = const {},
    this.ageRanges = const {},
    this.interests = const {},
    this.categories = const {},
    this.membership = GroupMembershipFilter.all,
  });

  final Set<String> locations;
  final Set<String> ageRanges;
  final Set<String> interests;
  final Set<String> categories;
  final GroupMembershipFilter membership;

  static const empty = GroupDiscoveryFilters();

  bool get isEmpty =>
      locations.isEmpty &&
      ageRanges.isEmpty &&
      interests.isEmpty &&
      categories.isEmpty &&
      membership == GroupMembershipFilter.all;

  /// Count of active filter facets (membership counts as 1 when not [all]).
  int get activeCount {
    var count = locations.length +
        ageRanges.length +
        interests.length +
        categories.length;
    if (membership != GroupMembershipFilter.all) {
      count += 1;
    }
    return count;
  }

  GroupDiscoveryFilters copyWith({
    Set<String>? locations,
    Set<String>? ageRanges,
    Set<String>? interests,
    Set<String>? categories,
    GroupMembershipFilter? membership,
  }) {
    return GroupDiscoveryFilters(
      locations: locations ?? this.locations,
      ageRanges: ageRanges ?? this.ageRanges,
      interests: interests ?? this.interests,
      categories: categories ?? this.categories,
      membership: membership ?? this.membership,
    );
  }

  GroupDiscoveryFilters clear() => empty;

  GroupDiscoveryFilters withoutLocation(String value) =>
      copyWith(locations: {...locations}..remove(value));

  GroupDiscoveryFilters withoutAgeRange(String value) =>
      copyWith(ageRanges: {...ageRanges}..remove(value));

  GroupDiscoveryFilters withoutInterest(String value) =>
      copyWith(interests: {...interests}..remove(value));

  GroupDiscoveryFilters withoutCategory(String value) =>
      copyWith(categories: {...categories}..remove(value));

  GroupDiscoveryFilters withoutMembership() =>
      copyWith(membership: GroupMembershipFilter.all);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroupDiscoveryFilters &&
        _setEquals(locations, other.locations) &&
        _setEquals(ageRanges, other.ageRanges) &&
        _setEquals(interests, other.interests) &&
        _setEquals(categories, other.categories) &&
        membership == other.membership;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAllUnordered(locations),
        Object.hashAllUnordered(ageRanges),
        Object.hashAllUnordered(interests),
        Object.hashAllUnordered(categories),
        membership,
      );
}

bool _setEquals(Set<String> a, Set<String> b) {
  if (a.length != b.length) return false;
  return a.containsAll(b);
}

/// Unique filter option values derived from a Group dataset.
class GroupFilterOptions {
  const GroupFilterOptions({
    this.locations = const [],
    this.ageRanges = const [],
    this.interests = const [],
    this.categories = const [],
  });

  final List<String> locations;
  final List<String> ageRanges;
  final List<String> interests;
  final List<String> categories;
}
