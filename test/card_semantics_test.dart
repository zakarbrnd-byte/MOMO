import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/core/theme/app_theme.dart';
import 'package:momo/data/models/mom_user.dart';
import 'package:momo/data/models/playdate.dart';
import 'package:momo/data/models/post.dart';
import 'package:momo/shared/widgets/cards/base_card.dart';
import 'package:momo/shared/widgets/cards/playdate_card.dart';
import 'package:momo/shared/widgets/cards/post_card.dart';

void main() {
  const host = MomUser(
    id: 'u1',
    displayName: 'Soojin Kim',
    neighborhood: 'Irvine',
  );

  final playdate = Playdate(
    id: 'pd1',
    title: 'Park morning meetup',
    startsAt: DateTime(2026, 7, 20, 10, 30),
    location: 'Central Park playground',
    host: host,
    ageRange: '3–5',
  );

  final post = Post(
    id: 'p1',
    title: 'Anyone free Thursday?',
    body: 'Looking for a quick indoor playdate near the library.',
    author: host,
    createdAt: DateTime(2026, 7, 17, 8, 0),
  );

  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  testWidgets('PlaydateCard exposes semantic label when tappable', (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        wrap(
          PlaydateCard(
            playdate: playdate,
            onTap: () {},
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(BaseCard));
      // BaseCard sets label; Flutter merges descendant text into the same node.
      expect(node.label, startsWith('Playdate: Park morning meetup'));
      expect(node.flagsCollection.isButton, isTrue);
    } finally {
      handle.dispose();
    }
  });

  testWidgets('PostCard exposes semantic label when tappable', (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        wrap(
          PostCard(
            post: post,
            now: DateTime(2026, 7, 17, 10, 0),
            onTap: () {},
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(BaseCard));
      expect(node.label, startsWith('Post: Anyone free Thursday?'));
      expect(node.flagsCollection.isButton, isTrue);
    } finally {
      handle.dispose();
    }
  });

  testWidgets('PlaydateCard without onTap keeps label but is not a button',
      (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        wrap(
          PlaydateCard(playdate: playdate),
        ),
      );

      final node = tester.getSemantics(find.byType(BaseCard));
      expect(node.label, startsWith('Playdate: Park morning meetup'));
      expect(node.flagsCollection.isButton, isFalse);
    } finally {
      handle.dispose();
    }
  });
}
