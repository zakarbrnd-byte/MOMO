import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/data/mock_groups.dart';
import 'package:momo/features/detail/playdate_detail_screen.dart';
import 'package:momo/features/detail/post_detail_screen.dart';
import 'package:momo/models/playdate.dart';
import 'package:momo/models/post.dart';

import 'support/home_test_helpers.dart';
import 'support/test_overrides.dart';

void main() {
  testWidgets('Playdate detail shows full information', (tester) async {
    const playdate = Playdate(
      id: 'pd_full',
      creatorId: 'mom_other',
      title: 'Park Play Date',
      date: 'Saturday, July 25, 2026',
      time: '10:30 AM',
      location: 'Irvine Park',
      childAge: '2-4 years old',
      description: 'Bring snacks and sunscreen.',
      hostName: 'Jiwoo Mom',
      participantIds: ['mom_a', 'mom_b'],
      maxParticipants: 5,
    );

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: PlaydateDetailScreen(playdate: playdate)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Park Play Date'), findsOneWidget);
    expect(find.text('Irvine Park'), findsOneWidget);
    expect(find.text('Saturday, July 25, 2026'), findsOneWidget);
    expect(find.text('10:30 AM'), findsOneWidget);
    expect(find.text('2-4 years old'), findsOneWidget);
    expect(find.text('Bring snacks and sunscreen.'), findsOneWidget);
    expect(find.text('Hosted by Jiwoo Mom'), findsOneWidget);
    expect(find.text('2 / 5 joined'), findsWidgets);
    expect(find.text('Join Playdate'), findsOneWidget);
  });

  testWidgets('Playdate detail handles missing optional fields', (
    tester,
  ) async {
    const playdate = Playdate(
      id: 'pd_optional',
      creatorId: 'mom_minji',
      title: 'Library Meetup',
      date: 'Monday, July 20, 2026',
      time: '',
      location: 'Jamsil Library',
      childAge: '',
      description: '',
      hostName: 'Minji Park',
    );

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: PlaydateDetailScreen(playdate: playdate)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Library Meetup'), findsOneWidget);
    expect(find.text('Time not specified'), findsOneWidget);
    expect(find.text('Not specified'), findsOneWidget);
    expect(find.text('No description provided.'), findsOneWidget);
    expect(find.text('null'), findsNothing);
  });

  testWidgets('Post detail shows title, author, and content', (tester) async {
    const post = Post(
      id: 'po_1',
      title: 'Best playground recommendations?',
      content: 'Looking for toddler-friendly parks nearby.',
      authorName: 'Yuna Choi',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: testBackendOverrides,
        child: const MaterialApp(home: PostDetailScreen(post: post)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Best playground recommendations?'), findsOneWidget);
    expect(
      find.text('Looking for toddler-friendly parks nearby.'),
      findsOneWidget,
    );
    expect(find.text('Yuna Choi'), findsOneWidget);
    expect(find.text('Shared with the MOMO community'), findsOneWidget);
  });

  testWidgets('Home card opens group detail and returns', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: MomoApp()));
    await tester.pumpAndSettle();

    await openHomeGroupBySearch(tester, 'LA 3살');

    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    expect(find.text('Posts'), findsOneWidget);
    expect(find.text('Leave Group'), findsNothing);
    expect(find.textContaining(groupLa3.location), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.textContaining('LA 3살'), findsWidgets);
  });
}
