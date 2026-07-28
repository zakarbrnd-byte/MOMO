import 'package:flutter_test/flutter_test.dart';

import 'package:momo/core/time/relative_time_ko.dart';

void main() {
  final now = DateTime.utc(2026, 7, 28, 21, 0, 0);

  group('RelativeTimeKo.format', () {
    test('null timestamp returns null', () {
      expect(RelativeTimeKo.format(null, now: now), isNull);
    });

    test('less than one minute and future → 방금 전', () {
      expect(
        RelativeTimeKo.format(
          now.subtract(const Duration(seconds: 30)),
          now: now,
        ),
        '방금 전',
      );
      expect(
        RelativeTimeKo.format(
          now.add(const Duration(minutes: 5)),
          now: now,
        ),
        '방금 전',
      );
    });

    test('minutes and hours', () {
      expect(
        RelativeTimeKo.format(
          now.subtract(const Duration(minutes: 5)),
          now: now,
        ),
        '5분 전',
      );
      expect(
        RelativeTimeKo.format(
          now.subtract(const Duration(hours: 2)),
          now: now,
        ),
        '2시간 전',
      );
    });

    test('yesterday and several days', () {
      expect(
        RelativeTimeKo.format(
          DateTime.utc(2026, 7, 27, 10, 0),
          now: now,
        ),
        '어제',
      );
      expect(
        RelativeTimeKo.format(
          now.subtract(const Duration(days: 3)),
          now: now,
        ),
        '3일 전',
      );
    });

    test('older calendar date', () {
      expect(
        RelativeTimeKo.format(
          DateTime.utc(2026, 7, 19, 15, 0),
          now: now,
        ),
        '7월 19일',
      );
    });
  });

  group('RelativeTimeKo.authorWithTime', () {
    test('omits separator when timestamp is null', () {
      expect(
        RelativeTimeKo.authorWithTime('최유나', null, now: now),
        '최유나',
      );
      expect(
        RelativeTimeKo.authorWithTime('최유나', null, now: now).contains('·'),
        isFalse,
      );
    });

    test('joins author and relative time', () {
      expect(
        RelativeTimeKo.authorWithTime(
          '최유나',
          now.subtract(const Duration(hours: 2)),
          now: now,
        ),
        '최유나 · 2시간 전',
      );
    });
  });
}
