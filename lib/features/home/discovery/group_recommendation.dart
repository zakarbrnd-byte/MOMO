import '../../../models/group.dart';

/// Presentation-layer recommendation result (not persisted).
class GroupRecommendation {
  const GroupRecommendation({
    required this.group,
    required this.score,
    required this.reasons,
  });

  final Group group;
  final int score;
  final List<String> reasons;

  /// Up to two concise reason labels for cards.
  List<String> get visibleReasons => reasons.take(2).toList(growable: false);
}

/// Structured Home discovery payload (search mode or browsable sections).
class HomeDiscoveryView {
  const HomeDiscoveryView({
    required this.isSearchMode,
    required this.filteredGroups,
    required this.recommended,
    required this.nearby,
    required this.similarAge,
    required this.newest,
    required this.allGroups,
  });

  final bool isSearchMode;
  final List<Group> filteredGroups;
  final List<GroupRecommendation> recommended;
  final List<GroupRecommendation> nearby;
  final List<GroupRecommendation> similarAge;
  final List<Group> newest;
  final List<Group> allGroups;

  int get resultCount => filteredGroups.length;
}
