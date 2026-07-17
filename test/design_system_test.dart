import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/core/theme/app_button_style.dart';
import 'package:momo/core/theme/app_card_style.dart';
import 'package:momo/core/theme/app_colors.dart';
import 'package:momo/core/theme/app_spacing.dart';
import 'package:momo/core/theme/app_theme.dart';
import 'package:momo/core/theme/app_typography.dart';

void main() {
  group('AppColors', () {
    test('warm surfaces and coral primary stay distinct', () {
      expect(AppColors.background, isNot(AppColors.surface));
      expect(AppColors.primary, isNot(AppColors.primaryDark));
      expect(AppColors.textPrimary, isNot(AppColors.textSecondary));
    });
  });

  group('AppSpacing', () {
    test('scale is 4pt-based and ordered', () {
      expect(AppSpacing.xs, 4);
      expect(AppSpacing.sm, 8);
      expect(AppSpacing.md, 12);
      expect(AppSpacing.lg, 16);
      expect(AppSpacing.xl, 24);
      expect(AppSpacing.xxl, 32);
      expect(AppSpacing.tapTarget, greaterThanOrEqualTo(48));
      expect(AppSpacing.xs < AppSpacing.sm, isTrue);
      expect(AppSpacing.sm < AppSpacing.md, isTrue);
      expect(AppSpacing.md < AppSpacing.lg, isTrue);
    });
  });

  group('AppTypography', () {
    test('type scale is large and readable', () {
      expect(AppTypography.display.fontSize, greaterThanOrEqualTo(32));
      expect(AppTypography.headline.fontSize, greaterThanOrEqualTo(24));
      expect(AppTypography.body.fontSize, greaterThanOrEqualTo(16));
      expect(AppTypography.display.fontWeight, FontWeight.w700);
    });
  });

  group('AppCardStyle', () {
    test('cards are rounded with quiet border', () {
      expect(AppCardStyle.radius, greaterThanOrEqualTo(16));
      expect(AppCardStyle.theme.elevation, 0);
      expect(AppCardStyle.theme.color, AppColors.surface);
    });
  });

  group('AppButtonStyle', () {
    test('buttons use large tap targets and rounded corners', () {
      expect(AppButtonStyle.minHeight, AppSpacing.tapTarget);
      expect(AppButtonStyle.radius, greaterThanOrEqualTo(12));
      expect(AppButtonStyle.minimumSize.height, AppButtonStyle.minHeight);
    });
  });

  group('AppTheme', () {
    test('light theme wires design tokens', () {
      final theme = AppTheme.light;

      expect(theme.scaffoldBackgroundColor, AppColors.background);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.textTheme.headlineLarge?.fontSize, AppTypography.headline.fontSize);
      expect(theme.cardTheme.elevation, 0);
      expect(theme.elevatedButtonTheme.style, isNotNull);
      expect(theme.outlinedButtonTheme.style, isNotNull);
      expect(theme.filledButtonTheme.style, isNotNull);
    });

    testWidgets('theme applies to Material widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Column(
              children: [
                const Text('Hello', style: AppTypography.headline),
                const Card(child: Text('Card', style: AppTypography.body)),
                ElevatedButton(onPressed: () {}, child: const Text('Go')),
                OutlinedButton(onPressed: () {}, child: const Text('More')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Card'), findsOneWidget);
      expect(find.text('Go'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.colorScheme.primary, AppColors.primary);
    });
  });
}
