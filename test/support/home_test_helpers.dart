import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/features/home/widgets/group_card.dart';

/// Opens Home search, enters [query], then taps a matching [GroupCard].
Future<void> openHomeGroupBySearch(
  WidgetTester tester,
  String query, {
  String? tapText,
}) async {
  await openHomeSearch(tester);
  final field = find.byType(TextField).first;
  await tester.enterText(field, query);
  await tester.pumpAndSettle();

  final needle = tapText ?? query;
  final target = find.descendant(
    of: find.byType(GroupCard),
    matching: find.textContaining(needle),
  );
  expect(target, findsWidgets);
  await tester.ensureVisible(target.first);
  await tester.tap(target.first);
  await tester.pumpAndSettle();
}

/// Expands the compact Home AppBar search field.
Future<void> openHomeSearch(WidgetTester tester) async {
  final searchIcon = find.byIcon(Icons.search_rounded);
  if (searchIcon.evaluate().isNotEmpty) {
    await tester.tap(searchIcon);
    await tester.pumpAndSettle();
  }
  expect(find.byType(TextField), findsOneWidget);
}
