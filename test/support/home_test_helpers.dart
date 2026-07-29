import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/features/home/widgets/group_card.dart';

/// Opens a Group from Home by searching, then tapping a matching [GroupCard].
///
/// Prefer this over tapping deep 전체 모임 cards that sit far below the fold.
Future<void> openHomeGroupBySearch(
  WidgetTester tester,
  String query, {
  String? tapText,
}) async {
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
