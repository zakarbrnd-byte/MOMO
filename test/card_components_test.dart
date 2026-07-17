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

  testWidgets('PlaydateCard shows shared type label and meetup meta',
      (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      wrap(
        PlaydateCard(
          playdate: playdate,
          onTap: () => tapped = true,
        ),
      ),
    );

    expect(find.byType(BaseCard), findsOneWidget);
    expect(find.text('Playdate'), findsOneWidget);
    expect(find.text('Park morning meetup'), findsOneWidget);
    expect(find.textContaining('Central Park'), findsOneWidget);
    expect(find.textContaining('Ages 3–5'), findsOneWidget);
    expect(find.textContaining('Soojin Kim'), findsOneWidget);

    await tester.tap(find.byType(PlaydateCard));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('PostCard shows shared shell with body preview', (tester) async {
    var tapped = false;
    final now = DateTime(2026, 7, 17, 10, 0);

    await tester.pumpWidget(
      wrap(
        PostCard(
          post: post,
          now: now,
          onTap: () => tapped = true,
        ),
      ),
    );

    expect(find.byType(BaseCard), findsOneWidget);
    expect(find.text('Post'), findsOneWidget);
    expect(find.text('Anyone free Thursday?'), findsOneWidget);
    expect(find.textContaining('indoor playdate'), findsOneWidget);
    expect(find.text('2h ago'), findsOneWidget);
    expect(find.textContaining('Soojin Kim'), findsOneWidget);

    await tester.tap(find.byType(PostCard));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('PlaydateCard and PostCard share BaseCard chrome', (tester) async {
    await tester.pumpWidget(
      wrap(
        Column(
          children: [
            PlaydateCard(playdate: playdate),
            const SizedBox(height: 12),
            PostCard(post: post, now: DateTime(2026, 7, 17, 10, 0)),
          ],
        ),
      ),
    );

    expect(find.byType(BaseCard), findsNWidgets(2));
    expect(find.text('Playdate'), findsOneWidget);
    expect(find.text('Post'), findsOneWidget);
  });
}
