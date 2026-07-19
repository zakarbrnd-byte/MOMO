import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/data/mock_user.dart';
import 'package:momo/models/playdate.dart';
import 'package:momo/providers/playdate_provider.dart';

void main() {
  group('Playdate model helpers', () {
    test('participantCount derives from joinedUserIds', () {
      const playdate = Playdate(
        id: 'p1',
        creatorId: 'host_1',
        title: 'Park',
        date: 'Sat',
        time: '10:00 AM',
        location: 'Irvine',
        childAge: '',
        description: '',
        hostName: 'Host',
        joinedUserIds: ['a', 'b'],
        maxParticipants: 5,
      );

      expect(playdate.participantCount, 2);
      expect(playdate.participantsLabel, '2 / 5 joined');
      expect(playdate.isFull, isFalse);
      expect(playdate.isOwner('host_1'), isTrue);
      expect(playdate.isOwner('a'), isFalse);
    });

    test('unlimited capacity never reports full', () {
      const playdate = Playdate(
        id: 'p2',
        creatorId: 'host_1',
        title: 'Park',
        date: 'Sat',
        time: '',
        location: 'Irvine',
        childAge: '',
        description: '',
        hostName: 'Host',
        joinedUserIds: ['a', 'b', 'c'],
        maxParticipants: null,
      );

      expect(playdate.hasCapacityLimit, isFalse);
      expect(playdate.isFull, isFalse);
      expect(playdate.participantsLabel, '3 joined');
    });

    test('isFull when at capacity', () {
      const playdate = Playdate(
        id: 'p3',
        creatorId: 'host_1',
        title: 'Park',
        date: 'Sat',
        time: '',
        location: 'Irvine',
        childAge: '',
        description: '',
        hostName: 'Host',
        joinedUserIds: ['a', 'b', 'c', 'd', 'e'],
        maxParticipants: 5,
      );

      expect(playdate.isFull, isTrue);
      expect(playdate.joinStateFor('outsider'), PlaydateJoinState.full);
      expect(playdate.joinStateFor('a'), PlaydateJoinState.leave);
      expect(playdate.joinStateFor('host_1'), PlaydateJoinState.owner);
    });

    test('joinStateFor returns join / leave / owner correctly', () {
      const playdate = Playdate(
        id: 'p4',
        creatorId: 'host_1',
        title: 'Park',
        date: 'Sat',
        time: '',
        location: 'Irvine',
        childAge: '',
        description: '',
        hostName: 'Host',
        joinedUserIds: ['mom_a'],
        maxParticipants: 5,
      );

      expect(playdate.joinStateFor(currentUser.id), PlaydateJoinState.join);
      expect(
        playdate.joinStateFor('mom_a').actionLabel,
        'Leave Playdate',
      );
      expect(
        playdate.joinStateFor(currentUser.id).actionLabel,
        'Join Playdate',
      );
      expect(
        playdate.joinStateFor('host_1').actionLabel,
        'My Playdate',
      );
    });
  });

  group('PlaydateNotifier participation', () {
    Future<ProviderContainer> warmContainer() async {
      final container = ProviderContainer();
      await container.read(playdateProvider.future);
      return container;
    }

    test('join increases participant count once', () async {
      final container = await warmContainer();
      addTearDown(container.dispose);

      final before = container
          .read(playdateProvider)
          .requireValue
          .firstWhere((item) => item.id == 'pd1')
          .participantCount;

      final joined = container
          .read(playdateProvider.notifier)
          .joinPlaydate('pd1', currentUser.id);
      final joinedAgain = container
          .read(playdateProvider.notifier)
          .joinPlaydate('pd1', currentUser.id);

      expect(joined, isTrue);
      expect(joinedAgain, isFalse);

      final after = container
          .read(playdateProvider)
          .requireValue
          .firstWhere((item) => item.id == 'pd1');
      expect(after.participantCount, before + 1);
      expect(after.hasUserJoined(currentUser.id), isTrue);
    });

    test('leave decreases participant count', () async {
      final container = await warmContainer();
      addTearDown(container.dispose);

      container
          .read(playdateProvider.notifier)
          .joinPlaydate('pd1', currentUser.id);

      final left = container
          .read(playdateProvider.notifier)
          .leavePlaydate('pd1', currentUser.id);

      expect(left, isTrue);
      final after = container
          .read(playdateProvider)
          .requireValue
          .firstWhere((item) => item.id == 'pd1');
      expect(after.participantCount, 2);
      expect(after.hasUserJoined(currentUser.id), isFalse);
    });

    test('unlimited playdate accepts joins beyond five', () async {
      final container = await warmContainer();
      addTearDown(container.dispose);

      final notifier = container.read(playdateProvider.notifier);
      expect(notifier.playdateById('pd2')!.maxParticipants, isNull);

      for (var i = 0; i < 5; i++) {
        expect(notifier.joinPlaydate('pd2', 'extra_$i'), isTrue);
      }

      final playdate = notifier.playdateById('pd2')!;
      expect(playdate.isFull, isFalse);
      expect(playdate.participantCount, 3 + 5);
    });

    test('owner cannot join or leave own playdate', () async {
      final container = await warmContainer();
      addTearDown(container.dispose);

      final notifier = container.read(playdateProvider.notifier);
      expect(notifier.joinPlaydate('pd5', currentUser.id), isFalse);
      expect(notifier.leavePlaydate('pd5', currentUser.id), isFalse);
    });
  });
}
