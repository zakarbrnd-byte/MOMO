import 'package:flutter_test/flutter_test.dart';

import 'package:momo/models/child.dart';
import 'package:momo/models/entity_status.dart';
import 'package:momo/models/participant.dart';
import 'package:momo/models/playdate.dart';
import 'package:momo/models/post.dart';
import 'package:momo/models/user.dart';

void main() {
  test('Playdate defaults status active and derives isCancelled', () {
    const playdate = Playdate(
      id: 'p1',
      creatorId: 'u1',
      title: 'Park',
      date: 'Sat',
      time: '',
      location: 'A',
      childAge: '',
      description: '',
      hostName: 'Host',
    );

    expect(playdate.status, PlaydateStatus.active);
    expect(playdate.isCancelled, isFalse);
    expect(playdate.participantIds, isEmpty);
    expect(playdate.viewCount, 0);
    expect(playdate.commentCount, 0);
    expect(playdate.likeCount, 0);
    expect(
      playdate.copyWith(status: PlaydateStatus.cancelled).isCancelled,
      isTrue,
    );
  });

  test('Playdate accepts explicit engagement values and copyWith', () {
    const playdate = Playdate(
      id: 'p2',
      creatorId: 'u1',
      title: 'Park',
      date: 'Sat',
      time: '',
      location: 'A',
      childAge: '',
      description: '',
      hostName: 'Host',
      viewCount: 120,
      commentCount: 8,
      likeCount: 15,
    );

    expect(playdate.viewCount, 120);
    expect(playdate.commentCount, 8);
    expect(playdate.likeCount, 15);

    final preserved = playdate.copyWith(title: 'Updated');
    expect(preserved.title, 'Updated');
    expect(preserved.viewCount, 120);
    expect(preserved.commentCount, 8);
    expect(preserved.likeCount, 15);

    final updated = playdate.copyWith(
      viewCount: 200,
      commentCount: 10,
      likeCount: 25,
    );
    expect(updated.viewCount, 200);
    expect(updated.commentCount, 10);
    expect(updated.likeCount, 25);
    expect(updated.title, playdate.title);
  });

  test('Post and User expose backend-ready fields with defaults', () {
    const post = Post(
      id: 'po1',
      title: 'Hi',
      content: 'Body',
      authorName: 'Ann',
    );
    expect(post.status, PostStatus.active);
    expect(post.creatorId, isNull);
    expect(post.groupId, isNull);
    expect(post.isGlobal, isTrue);
    expect(post.category, PostCategory.parenting);
    expect(post.viewCount, 0);
    expect(post.commentCount, 0);
    expect(post.likeCount, 0);

    const user = User(id: 'u1', displayName: 'Demo');
    expect(user.name, 'Demo');
    expect(user.children, isEmpty);
    expect(user.profileImageUrl, isNull);
  });

  test('Post accepts explicit category and engagement values', () {
    const post = Post(
      id: 'po2',
      title: 'Hi',
      content: 'Body',
      authorName: 'Ann',
      category: PostCategory.local,
      viewCount: 120,
      commentCount: 8,
      likeCount: 15,
    );

    expect(post.category, PostCategory.local);
    expect(post.category.labelKo, '지역정보');
    expect(post.viewCount, 120);
    expect(post.commentCount, 8);
    expect(post.likeCount, 15);
  });

  test('Post copyWith preserves and updates category and engagement', () {
    const original = Post(
      id: 'po3',
      title: 'Hi',
      content: 'Body',
      authorName: 'Ann',
      category: PostCategory.food,
      viewCount: 10,
      commentCount: 2,
      likeCount: 3,
    );

    final preserved = original.copyWith(title: 'Updated');
    expect(preserved.title, 'Updated');
    expect(preserved.category, PostCategory.food);
    expect(preserved.viewCount, 10);
    expect(preserved.commentCount, 2);
    expect(preserved.likeCount, 3);

    final updated = original.copyWith(
      category: PostCategory.health,
      viewCount: 99,
      commentCount: 7,
      likeCount: 11,
    );
    expect(updated.category, PostCategory.health);
    expect(updated.viewCount, 99);
    expect(updated.commentCount, 7);
    expect(updated.likeCount, 11);
    expect(updated.title, original.title);
  });

  test('PostCategory Korean labels cover all values', () {
    expect(PostCategory.parenting.labelKo, '육아질문');
    expect(PostCategory.school.labelKo, '학교·킨더');
    expect(PostCategory.local.labelKo, '지역정보');
    expect(PostCategory.health.labelKo, '병원·건강');
    expect(PostCategory.food.labelKo, '음식·간식');
    expect(PostCategory.daily.labelKo, '일상');
    expect(PostCategory.marketplace.labelKo, '장터');
  });

  test('Participant composite id and Child remain immutable helpers', () {
    final joinedAt = DateTime.utc(2026, 7, 1);
    final participant = Participant(
      userId: 'u1',
      playdateId: 'pd1',
      joinedAt: joinedAt,
    );
    expect(participant.id, 'pd1_u1');
    expect(participant.isActive, isTrue);

    const child = Child(id: 'c1', displayName: 'Kid', ageLabel: '4');
    expect(child.copyWith(ageLabel: '5').ageLabel, '5');
    expect(child.ageLabel, '4');
  });
}
