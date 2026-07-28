import 'package:flutter_test/flutter_test.dart';

import 'package:momo/data/mock_feed.dart';

void main() {
  test('mock playdates keep stable ids with varied engagement', () {
    expect(mockPlaydates.length, 8);

    const expectedIds = [
      'pd1',
      'pd2',
      'pd3',
      'pd4',
      'pd5',
      'pd6',
      'pd7',
      'pd8',
    ];
    expect(mockPlaydates.map((item) => item.id).toList(), expectedIds);

    final viewCounts = <int>{};
    final commentCounts = <int>{};
    final likeCounts = <int>{};

    for (final playdate in mockPlaydates) {
      viewCounts.add(playdate.viewCount);
      commentCounts.add(playdate.commentCount);
      likeCounts.add(playdate.likeCount);

      expect(playdate.viewCount, greaterThanOrEqualTo(0));
      expect(playdate.commentCount, greaterThanOrEqualTo(0));
      expect(playdate.likeCount, greaterThanOrEqualTo(0));
    }

    expect(viewCounts.length, greaterThan(1));
    expect(commentCounts.length, greaterThan(1));
    expect(likeCounts.length, greaterThan(1));
  });

  test('capacity and ownership scenarios remain intact', () {
    expect(playdateLibrary.maxParticipants, isNull);
    expect(playdateCafe.participantIds.length, 5);
    expect(playdateCafe.maxParticipants, 5);
    expect(playdateNearFull.participantIds.length, 4);
    expect(playdateNearFull.maxParticipants, 5);
    expect(playdateOwnedByDemo.creatorId, 'user_001');
    expect(playdateGriffithPicnic.participantIds, isEmpty);
  });
}
