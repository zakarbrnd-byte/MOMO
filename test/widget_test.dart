import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/core/theme/app_fonts.dart';

void main() {
  testWidgets('MOMO app shows Home tab', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MomoApp()));
    await tester.pumpAndSettle();

    expect(find.text('MOMO'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
  });

  testWidgets('Home renders Korean labels with Pretendard theme',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MomoApp()));
    await tester.pumpAndSettle();

    expect(find.textContaining('우리 동네 엄마들의'), findsOneWidget);
    expect(find.text('✨ 추천 모임'), findsOneWidget);

    final theme = Theme.of(tester.element(find.text('MOMO')));
    expect(theme.textTheme.bodyLarge?.fontFamily, AppFonts.family);
  });
}
