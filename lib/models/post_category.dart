/// Stable post topic for feed cards and future filtering.
///
/// Serialized by [name] (lowercase English). Korean labels live in
/// [PostCategoryX.labelKo] — never store display text as the wire value.
enum PostCategory { parenting, school, local, health, food, daily, marketplace }

extension PostCategoryX on PostCategory {
  /// Korean UI label for chips / cards (not persisted).
  String get labelKo {
    return switch (this) {
      PostCategory.parenting => '육아질문',
      PostCategory.school => '학교·킨더',
      PostCategory.local => '지역정보',
      PostCategory.health => '병원·건강',
      PostCategory.food => '음식·간식',
      PostCategory.daily => '일상',
      PostCategory.marketplace => '장터',
    };
  }
}
