import 'package:flutter_test/flutter_test.dart';

import 'package:momo/data/mock_feed.dart';
import 'package:momo/models/post_category.dart';

void main() {
  test('mock posts keep stable ids with valid category and engagement', () {
    expect(mockPosts.length, 12);

    const expectedIds = [
      'po1',
      'po2',
      'po3',
      'po4',
      'po5',
      'po6',
      'po7',
      'po8',
      'po9',
      'po10',
      'po11',
      'po12',
    ];
    expect(mockPosts.map((post) => post.id).toList(), expectedIds);

    final categories = <PostCategory>{};
    final viewCounts = <int>{};
    final commentCounts = <int>{};
    final likeCounts = <int>{};

    for (final post in mockPosts) {
      categories.add(post.category);
      viewCounts.add(post.viewCount);
      commentCounts.add(post.commentCount);
      likeCounts.add(post.likeCount);

      expect(PostCategory.values, contains(post.category));
      expect(post.viewCount, greaterThanOrEqualTo(0));
      expect(post.commentCount, greaterThanOrEqualTo(0));
      expect(post.likeCount, greaterThanOrEqualTo(0));
      expect(post.createdAt, isNotNull);
    }

    expect(categories.length, greaterThanOrEqualTo(2));
    expect(viewCounts.length, greaterThan(1));
    expect(commentCounts.length, greaterThan(1));
    expect(likeCounts.length, greaterThan(1));
    expect(
      mockPosts.map((post) => post.createdAt).toSet().length,
      greaterThan(1),
    );
  });

  test('mock post category assignments match content themes', () {
    expect(postSeolleung.category, PostCategory.school);
    expect(postIndoorSpots.category, PostCategory.school);
    expect(postKinderLunchBox.category, PostCategory.school);
    expect(postKinderBackpack.category, PostCategory.school);
    expect(postPickyEating.category, PostCategory.food);
    expect(postCostcoSnacks.category, PostCategory.food);
    expect(postPediatrician.category, PostCategory.health);
    expect(postSwimClass.category, PostCategory.parenting);
    expect(postRainyDay.category, PostCategory.local);
    expect(postShadyPlayground.category, PostCategory.local);
    expect(postIrvineParenting.category, PostCategory.local);
    expect(postDiaperGraduation.category, PostCategory.daily);
  });
}
