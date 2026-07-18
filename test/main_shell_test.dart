import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/app.dart';
import 'package:momo/features/create/create_selection_screen.dart';
import 'package:momo/features/home/home_feed_screen.dart';
import 'package:momo/features/profile/profile_screen.dart';
import 'package:momo/navigation/main_shell.dart';

void main() {
  testWidgets('MainShell switches Home · Create · Profile tabs', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MomoApp(),
      ),
    );

    expect(find.byType(MainShell), findsOneWidget);
    expect(find.byType(HomeFeedScreen), findsOneWidget);
    expect(find.text('MOMO'), findsOneWidget);

    await tester.tap(find.text('Create').last);
    await tester.pumpAndSettle();

    expect(
      find.byType(CreateSelectionScreen, skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('What would you like to share?'), findsOneWidget);

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen, skipOffstage: false), findsOneWidget);
    expect(find.text('Your cards on MOMO (mock)'), findsOneWidget);

    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();

    expect(find.byType(HomeFeedScreen), findsOneWidget);
    expect(find.text('MOMO'), findsOneWidget);
    expect(find.text('Playdates near you'), findsOneWidget);
  });

  testWidgets('MainShell keeps offstage tabs in IndexedStack', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MomoApp(),
      ),
    );

    expect(find.byType(HomeFeedScreen, skipOffstage: false), findsOneWidget);
    expect(
      find.byType(CreateSelectionScreen, skipOffstage: false),
      findsOneWidget,
    );
    expect(find.byType(ProfileScreen, skipOffstage: false), findsOneWidget);

    await tester.tap(find.text('Create').last);
    await tester.pumpAndSettle();

    final nav = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(nav.selectedIndex, 1);
  });
}
