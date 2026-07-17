import 'package:flutter_test/flutter_test.dart';

import 'package:momo/shared/widgets/cards/card_format.dart';

void main() {
  group('CardFormat.playdateWhen', () {
    test('formats month, day, and 12-hour time', () {
      expect(
        CardFormat.playdateWhen(DateTime(2026, 7, 20, 10, 30)),
        'Jul 20 · 10:30 AM',
      );
      expect(
        CardFormat.playdateWhen(DateTime(2026, 12, 1, 15, 5)),
        'Dec 1 · 3:05 PM',
      );
      expect(
        CardFormat.playdateWhen(DateTime(2026, 1, 9, 0, 0)),
        'Jan 9 · 12:00 AM',
      );
      expect(
        CardFormat.playdateWhen(DateTime(2026, 6, 15, 12, 0)),
        'Jun 15 · 12:00 PM',
      );
    });
  });

  group('CardFormat.postWhen', () {
    final now = DateTime(2026, 7, 17, 18, 0);

    test('just now under one minute', () {
      expect(
        CardFormat.postWhen(
          now.subtract(const Duration(seconds: 30)),
          now: now,
        ),
        'Just now',
      );
    });

    test('minutes ago under one hour', () {
      expect(
        CardFormat.postWhen(
          now.subtract(const Duration(minutes: 2)),
          now: now,
        ),
        '2m ago',
      );
      expect(
        CardFormat.postWhen(
          now.subtract(const Duration(minutes: 59)),
          now: now,
        ),
        '59m ago',
      );
    });

    test('hours ago under one day', () {
      expect(
        CardFormat.postWhen(
          now.subtract(const Duration(hours: 2)),
          now: now,
        ),
        '2h ago',
      );
      expect(
        CardFormat.postWhen(
          now.subtract(const Duration(hours: 23)),
          now: now,
        ),
        '23h ago',
      );
    });

    test('days ago under one week', () {
      expect(
        CardFormat.postWhen(
          now.subtract(const Duration(days: 1)),
          now: now,
        ),
        '1d ago',
      );
      expect(
        CardFormat.postWhen(
          now.subtract(const Duration(days: 6)),
          now: now,
        ),
        '6d ago',
      );
    });

    test('month and day at one week or older', () {
      expect(
        CardFormat.postWhen(
          now.subtract(const Duration(days: 7)),
          now: now,
        ),
        'Jul 10',
      );
      expect(
        CardFormat.postWhen(DateTime(2026, 6, 1, 12, 0), now: now),
        'Jun 1',
      );
    });
  });
}
