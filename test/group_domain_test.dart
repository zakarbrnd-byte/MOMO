import 'package:flutter_test/flutter_test.dart';

import 'package:momo/data/mock_groups.dart';
import 'package:momo/dto/group_dto.dart';
import 'package:momo/dto/post_dto.dart';
import 'package:momo/models/entity_status.dart';
import 'package:momo/models/group.dart';
import 'package:momo/models/post.dart';

void main() {
  group('Group domain', () {
    test('constructs with defaults and copyWith', () {
      final createdAt = DateTime.utc(2026, 1, 1);
      final group = Group(
        id: 'g1',
        name: 'Test',
        description: 'Desc',
        category: '육아',
        location: 'LA',
        ownerId: 'u1',
        ownerName: 'Ann',
        childAgeRanges: const ['2–4세'],
        interestTags: const ['공원'],
        memberCount: 3,
        coverEmoji: '🧸',
        isFeatured: true,
        createdAt: createdAt,
      );

      expect(group.isFeatured, isTrue);
      expect(group.memberCount, 3);
      expect(group.copyWith(memberCount: 4).memberCount, 4);
      expect(group.copyWith(name: 'Updated').name, 'Updated');
      expect(group.copyWith(coverEmoji: null).coverEmoji, isNull);
    });

    test('GroupMember role defaults to member', () {
      const member = GroupMember(groupId: 'g1', userId: 'u1', userName: 'Ann');
      expect(member.role, GroupMemberRole.member);
      expect(
        member.copyWith(role: GroupMemberRole.owner).role,
        GroupMemberRole.owner,
      );
    });
  });

  group('EventAnnouncement and Rsvp', () {
    test('constructs event with optional limit', () {
      final when = DateTime.utc(2026, 8, 1, 17);
      final event = EventAnnouncement(
        id: 'e1',
        groupId: 'g1',
        creatorId: 'u1',
        creatorName: 'Ann',
        title: 'Park day',
        description: 'Meet at park',
        dateTime: when,
        location: 'Lafayette',
        childAgeRange: '3세',
        participantLimit: 8,
      );

      expect(event.isCancelled, isFalse);
      expect(event.participantLimit, 8);
      expect(event.copyWith(status: EventStatus.cancelled).isCancelled, isTrue);
      expect(event.copyWith(participantLimit: null).participantLimit, isNull);
    });

    test('Rsvp statuses', () {
      const rsvp = Rsvp(
        eventId: 'e1',
        userId: 'u1',
        userName: 'Ann',
        status: RsvpStatus.attending,
      );
      expect(rsvp.status, RsvpStatus.attending);
      expect(
        rsvp.copyWith(status: RsvpStatus.notAttending).status,
        RsvpStatus.notAttending,
      );
    });
  });

  group('Post.groupId', () {
    test('null groupId means global; non-null means group post', () {
      const global = Post(
        id: 'p1',
        title: 'Global',
        content: 'Body',
        authorName: 'Ann',
      );
      const groupPost = Post(
        id: 'p2',
        title: 'In group',
        content: 'Body',
        authorName: 'Ann',
        groupId: 'g1',
        groupName: 'Moms',
      );

      expect(global.isGlobal, isTrue);
      expect(global.isGroupPost, isFalse);
      expect(groupPost.isGlobal, isFalse);
      expect(groupPost.isGroupPost, isTrue);
      expect(groupPost.copyWith(groupId: null).isGlobal, isTrue);
    });

    test('mock global posts have null groupId', () {
      for (final post in mockGlobalPosts) {
        expect(post.groupId, isNull);
        expect(post.isGlobal, isTrue);
      }
      for (final post in mockGroupPosts) {
        expect(post.groupId, isNotNull);
        expect(post.isGroupPost, isTrue);
      }
    });
  });

  group('DTO roundtrip', () {
    test('GroupDto domain → json → domain', () {
      final original = groupLa3;
      final json = GroupDto.fromDomain(original).toJson();
      final restored = GroupDto.fromJson(json).toDomain();

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.ownerId, original.ownerId);
      expect(restored.memberCount, original.memberCount);
      expect(restored.isFeatured, original.isFeatured);
      expect(restored.childAgeRanges, original.childAgeRanges);
      expect(restored.interestTags, original.interestTags);
      expect(json['isFeatured'], true);
    });

    test('GroupMemberDto roundtrip', () {
      final original = mockGroupMembers.first;
      final json = GroupMemberDto.fromDomain(original).toJson();
      final restored = GroupMemberDto.fromJson(json).toDomain();

      expect(restored.groupId, original.groupId);
      expect(restored.userId, original.userId);
      expect(restored.role, original.role);
    });

    test('EventAnnouncementDto roundtrip', () {
      final original = eventLa3Park;
      final json = EventAnnouncementDto.fromDomain(original).toJson();
      final restored = EventAnnouncementDto.fromJson(json).toDomain();

      expect(restored.id, original.id);
      expect(restored.groupId, original.groupId);
      expect(restored.title, original.title);
      expect(restored.dateTime, original.dateTime);
      expect(restored.participantLimit, original.participantLimit);
      expect(restored.status, EventStatus.scheduled);
    });

    test('RsvpDto roundtrip', () {
      final original = mockRsvps.first;
      final json = RsvpDto.fromDomain(original).toJson();
      final restored = RsvpDto.fromJson(json).toDomain();

      expect(restored.eventId, original.eventId);
      expect(restored.userId, original.userId);
      expect(restored.status, original.status);
    });

    test('PostDto preserves groupId', () {
      final groupPost = mockGroupPosts.first;
      final json = PostDto.fromDomain(groupPost).toJson();
      final restored = PostDto.fromJson(json).toDomain();

      expect(restored.groupId, groupPost.groupId);
      expect(restored.groupName, groupPost.groupName);
      expect(json['groupId'], groupPost.groupId);

      final global = mockGlobalPosts.first;
      final globalJson = PostDto.fromDomain(global).toJson();
      expect(globalJson.containsKey('groupId'), isFalse);
      expect(PostDto.fromJson(globalJson).toDomain().groupId, isNull);
    });
  });
}
