import 'package:flutter_test/flutter_test.dart';

import 'package:momo/data/mock_feed.dart';
import 'package:momo/data/mock_user.dart';
import 'package:momo/dto/participant_dto.dart';
import 'package:momo/dto/playdate_dto.dart';
import 'package:momo/dto/post_dto.dart';
import 'package:momo/dto/user_dto.dart';
import 'package:momo/models/entity_status.dart';
import 'package:momo/models/participant.dart';

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
      final restored =
          PostDto.fromJson(PostDto.fromDomain(original).toJson()).toDomain();

      expect(restored.id, original.id);
      expect(restored.content, original.content);
      expect(restored.creatorId, original.creatorId);
      expect(restored.status, PostStatus.active);
      expect(restored.createdAt, original.createdAt);
    });

    test('ignores likes / comments / images keys', () {
      final json = {
        ...PostDto.fromDomain(postIndoorSpots).toJson(),
        'likes': 12,
        'comments': [],
        'images': null,
      };
      expect(PostDto.fromJson(json).toDomain().id, postIndoorSpots.id);
    });
  });

  group('UserDto', () {
    test('round-trip includes children', () {
      final restored =
          UserDto.fromJson(UserDto.fromDomain(currentUser).toJson()).toDomain();

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
