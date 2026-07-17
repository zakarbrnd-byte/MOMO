import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/app.dart';
import 'package:momo/core/theme/app_theme.dart';
import 'package:momo/data/mock/mock_feed.dart';
import 'package:momo/data/models/feed_item.dart';
import 'package:momo/data/models/mom_user.dart';
import 'package:momo/data/models/playdate.dart';
import 'package:momo/data/models/post.dart';
import 'package:momo/features/home/home_feed_screen.dart';
import 'package:momo/shared/widgets/cards/playdate_card.dart';
import 'package:momo/shared/widgets/cards/post_card.dart';

void main() {
  testWidgets('Home feed mixes playdate and post cards from mock data',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MomoApp(),
      ),
    );

    expect(find.text('MOMO'), findsOneWidget);
    expect(find.text('Playdates near you'), findsOneWidget);

    expect(find.byType(PlaydateCard), findsWidgets);
    expect(find.byType(PostCard), findsWidgets);

    // Mixed order: first mock item is a playdate, second is a post.
    expect(MockFeed.items[0], isA<PlaydateFeedItem>());
    expect(MockFeed.items[1], isA<PostFeedItem>());
    expect(find.text('Saturday park morning'), findsOneWidget);
    expect(find.text('Anyone free Thursday afternoon?'), findsOneWidget);

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(find.byType(PlaydateCard), findsWidgets);
  });

  testWidgets('Home feed shows empty state when there are no cards',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const HomeFeedScreen(items: []),
      ),
    );

    expect(find.textContaining('No cards yet'), findsOneWidget);
    expect(find.byType(PlaydateCard), findsNothing);
    expect(find.byType(PostCard), findsNothing);
  });

  testWidgets('Home feed renders an injected mixed list', (tester) async {
    const mom = MomUser(id: 'u1', displayName: 'Test Mom', neighborhood: 'Irvine');
    final items = <FeedItem>[
      PostFeedItem(
        Post(
          id: 'p1',
          title: 'Hello post',
          body: 'Body',
          author: mom,
          createdAt: MockFeed.now.subtract(const Duration(hours: 1)),
        ),
      ),
      PlaydateFeedItem(
        Playdate(
          id: 'pd1',
          title: 'Hello playdate',
          startsAt: DateTime(2026, 7, 20, 9, 0),
          location: 'Park',
          host: mom,
        ),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: HomeFeedScreen(items: items, now: MockFeed.now),
      ),
    );

    expect(find.text('Hello post'), findsOneWidget);
    expect(find.text('Hello playdate'), findsOneWidget);
    expect(find.byType(PostCard), findsOneWidget);
    expect(find.byType(PlaydateCard), findsOneWidget);
  });
}
