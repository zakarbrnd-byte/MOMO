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
    expect(
      playdate.copyWith(status: PlaydateStatus.cancelled).isCancelled,
      isTrue,
    );
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

    const user = User(id: 'u1', displayName: 'Demo');
    expect(user.name, 'Demo');
    expect(user.children, isEmpty);
    expect(user.profileImageUrl, isNull);
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
