import 'package:flutter_test/flutter_test.dart';

import 'package:momo/data/mock_feed.dart';
import 'package:momo/data/mock_user.dart';
import 'package:momo/dto/participant_dto.dart';
import 'package:momo/dto/playdate_dto.dart';
import 'package:momo/dto/post_dto.dart';
import 'package:momo/dto/user_dto.dart';
import 'package:momo/models/entity_status.dart';
import 'package:momo/models/participant.dart';
import 'package:momo/models/post_category.dart';

void main() {
  group('PlaydateDto', () {
    test('domain → json → domain round-trip', () {
      final original = playdateSaturdayPark.copyWith(
        createdAt: DateTime.utc(2026, 7, 1, 10),
        updatedAt: DateTime.utc(2026, 7, 2, 12),
      );

      final json = PlaydateDto.fromDomain(original).toJson();
      final restored = PlaydateDto.fromJson(json).toDomain();

      expect(restored.id, original.id);
      expect(restored.creatorId, original.creatorId);
      expect(restored.title, original.title);
      expect(restored.participantIds, original.participantIds);
      expect(restored.maxParticipants, original.maxParticipants);
      expect(restored.status, PlaydateStatus.active);
      expect(restored.createdAt, original.createdAt);
      expect(restored.updatedAt, original.updatedAt);
      expect(json['createdAt'], '2026-07-01T10:00:00.000Z');
    });

    test('ignores unknown future JSON keys', () {
      final json = {
        ...PlaydateDto.fromDomain(playdateLibrary).toJson(),
        'images': ['a.jpg'],
        'adminStatus': 'flagged',
        'deletedAt': '2026-08-01T00:00:00.000Z',
      };

      final playdate = PlaydateDto.fromJson(json).toDomain();
      expect(playdate.id, playdateLibrary.id);
      expect(playdate.title, playdateLibrary.title);
    });
  });

  group('PostDto', () {
    test('domain → json → domain round-trip', () {
      final original = postSeolleung.copyWith(
        createdAt: DateTime.utc(2026, 6, 15),
      );
      final json = PostDto.fromDomain(original).toJson();
      final restored = PostDto.fromJson(json).toDomain();

      expect(restored.id, original.id);
      expect(restored.content, original.content);
      expect(restored.creatorId, original.creatorId);
      expect(restored.category, PostCategory.school);
      expect(restored.viewCount, original.viewCount);
      expect(restored.commentCount, original.commentCount);
      expect(restored.likeCount, original.likeCount);
      expect(restored.status, PostStatus.active);
      expect(restored.createdAt, original.createdAt);
      expect(json['category'], 'school');
      expect(json['viewCount'], original.viewCount);
      expect(json['commentCount'], original.commentCount);
      expect(json['likeCount'], original.likeCount);
    });

    test('fromJson maps full category and engagement fields', () {
      final post = PostDto.fromJson({
        'id': 'po_full',
        'title': 'Title',
        'content': 'Body',
        'authorName': 'Ann',
        'creatorId': 'mom_a',
        'category': 'food',
        'viewCount': 250,
        'commentCount': 12,
        'likeCount': 40,
        'status': 'active',
      }).toDomain();

      expect(post.category, PostCategory.food);
      expect(post.viewCount, 250);
      expect(post.commentCount, 12);
      expect(post.likeCount, 40);
    });

    test('missing category and engagement fields use safe defaults', () {
      final post = PostDto.fromJson({
        'id': 'po_legacy',
        'title': 'Legacy',
        'content': 'Old payload',
        'authorName': 'Ann',
      }).toDomain();

      expect(post.category, PostCategory.parenting);
      expect(post.viewCount, 0);
      expect(post.commentCount, 0);
      expect(post.likeCount, 0);
    });

    test('unknown category falls back to parenting', () {
      final post = PostDto.fromJson({
        'id': 'po_unknown',
        'title': 'Title',
        'content': 'Body',
        'authorName': 'Ann',
        'category': 'not_a_real_category',
        'viewCount': 5,
      }).toDomain();

      expect(post.category, PostCategory.parenting);
      expect(post.viewCount, 5);
    });

    test('toDomain and fromDomain preserve engagement', () {
      final dto = PostDto.fromDomain(postCostcoSnacks);
      final domain = dto.toDomain();

      expect(domain.category, postCostcoSnacks.category);
      expect(domain.viewCount, postCostcoSnacks.viewCount);
      expect(domain.commentCount, postCostcoSnacks.commentCount);
      expect(domain.likeCount, postCostcoSnacks.likeCount);
      expect(PostDto.fromDomain(domain).category, dto.category);
    });

    test('ignores legacy likes / comments / images keys', () {
      final json = {
        ...PostDto.fromDomain(postIndoorSpots).toJson(),
        'likes': 12,
        'comments': [],
        'images': null,
      };
      final post = PostDto.fromJson(json).toDomain();
      expect(post.id, postIndoorSpots.id);
      expect(post.likeCount, postIndoorSpots.likeCount);
      expect(post.commentCount, postIndoorSpots.commentCount);
    });
  });

  group('UserDto', () {
    test('round-trip includes children', () {
      final restored = UserDto.fromJson(
        UserDto.fromDomain(currentUser).toJson(),
      ).toDomain();

      expect(restored.id, currentUser.id);
      expect(restored.displayName, currentUser.displayName);
      expect(restored.location, currentUser.location);
      expect(restored.children.length, currentUser.children.length);
      expect(restored.children.first.ageLabel, '4');
    });
  });

  group('ParticipantDto', () {
    test('round-trip ISO joinedAt', () {
      final original = Participant(
        userId: 'u1',
        playdateId: 'pd1',
        joinedAt: DateTime.utc(2026, 7, 10, 8, 30),
        status: ParticipantStatus.active,
      );
      final json = ParticipantDto.fromDomain(original).toJson();
      final restored = ParticipantDto.fromJson(json).toDomain();

      expect(restored.userId, original.userId);
      expect(restored.playdateId, original.playdateId);
      expect(restored.joinedAt, original.joinedAt);
      expect(json['joinedAt'], '2026-07-10T08:30:00.000Z');
    });
  });
}
