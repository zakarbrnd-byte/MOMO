import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/app.dart';
import 'package:momo/data/models/playdate.dart';
import 'package:momo/data/providers/feed_provider.dart';
import 'package:momo/features/create/create_playdate_screen.dart';
import 'package:momo/features/create/create_post_screen.dart';
import 'package:momo/features/create/create_selection_screen.dart';
import 'package:momo/features/playdate/playdate_detail_screen.dart';
import 'package:momo/features/post/post_detail_screen.dart';

void main() {
  testWidgets('Create selection opens playdate and post forms', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MomoApp()),
    );

    await tester.tap(find.text('Create').last);
    await tester.pumpAndSettle();

    expect(find.byType(CreateSelectionScreen), findsOneWidget);

    await tester.tap(find.text('Playdate'));
    await tester.pumpAndSettle();
    expect(find.byType(CreatePlaydateScreen), findsOneWidget);

    Navigator.of(tester.element(find.byType(CreatePlaydateScreen))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Post').first);
    await tester.pumpAndSettle();
    expect(find.byType(CreatePostScreen), findsOneWidget);
  });

  testWidgets('Tapping a playdate card opens detail', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MomoApp()),
    );

    await tester.tap(find.text('Saturday park morning'));
    await tester.pumpAndSettle();

    expect(find.byType(PlaydateDetailScreen), findsOneWidget);
    expect(find.text('Meet offline — say hi when you arrive.'), findsOneWidget);
  });

  testWidgets('Tapping a post card opens detail', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MomoApp()),
    );

    await tester.tap(find.text('Anyone free Thursday afternoon?'));
    await tester.pumpAndSettle();

    expect(find.byType(PostDetailScreen), findsOneWidget);
    expect(
      find.textContaining('Looking for a short indoor meetup'),
      findsOneWidget,
    );
  });

  testWidgets('Creating a post adds it to the Home feed', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MomoApp()),
    );

    await tester.tap(find.text('Create').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Post').first);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Test post title',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Message'),
      'Hello moms',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Post'));
    await tester.pumpAndSettle();

    expect(find.text('Test post title'), findsOneWidget);
    expect(find.text('Playdates near you'), findsOneWidget);
  });

  test('FeedNotifier prepends a playdate', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final user = container.read(currentUserProvider);
    final before = container.read(feedProvider).length;

    container.read(feedProvider.notifier).addPlaydate(
          Playdate(
            id: 'pd_test',
            title: 'Notifier playdate',
            startsAt: DateTime(2026, 8, 1, 10),
            location: 'Park',
            host: user,
          ),
        );

    final feed = container.read(feedProvider);
    expect(feed.length, before + 1);
    expect(feed.first.id, 'pd_test');
  });
}
