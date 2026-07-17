import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/app.dart';
import 'package:momo/features/create/create_placeholder_screen.dart';
import 'package:momo/features/home/home_feed_screen.dart';
import 'package:momo/features/profile/profile_placeholder_screen.dart';
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
      find.byType(CreatePlaceholderScreen, skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('Create'), findsWidgets);

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();

    expect(
      find.byType(ProfilePlaceholderScreen, skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('Profile'), findsWidgets);

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

    // IndexedStack builds all children; offstage ones need skipOffstage: false.
    expect(find.byType(HomeFeedScreen, skipOffstage: false), findsOneWidget);
    expect(
      find.byType(CreatePlaceholderScreen, skipOffstage: false),
      findsOneWidget,
    );
    expect(
      find.byType(ProfilePlaceholderScreen, skipOffstage: false),
      findsOneWidget,
    );

    await tester.tap(find.text('Create').last);
    await tester.pumpAndSettle();

    expect(find.byType(HomeFeedScreen, skipOffstage: false), findsOneWidget);
    expect(
      find.byType(CreatePlaceholderScreen, skipOffstage: false),
      findsOneWidget,
    );
    expect(
      find.byType(ProfilePlaceholderScreen, skipOffstage: false),
      findsOneWidget,
    );

    final nav = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(nav.selectedIndex, 1);
  });
}
