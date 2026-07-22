import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:momo/core/theme/app_theme.dart';
import 'package:momo/core/widgets/momo_button.dart';
import 'package:momo/core/widgets/momo_card.dart';
import 'package:momo/core/widgets/momo_text_field.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );
  }

  testWidgets('MomoButton taps when enabled', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      wrap(
        MomoButton(
          label: 'Save',
          onPressed: () => pressed = true,
        ),
      ),
    );

    await tester.tap(find.text('Save'));
    expect(pressed, isTrue);
  });

  testWidgets('MomoButton loading disables taps', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      wrap(
        MomoButton(
          label: 'Save',
          isLoading: true,
          onPressed: () => pressed = true,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(MomoButton));
    expect(pressed, isFalse);
  });

  testWidgets('MomoTextField validates via Form', (tester) async {
    final key = GlobalKey<FormState>();
    await tester.pumpWidget(
      wrap(
        Form(
          key: key,
          child: MomoTextField(
            label: 'Title',
            hint: 'Enter title',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
        ),
      ),
    );

    expect(key.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('MomoCard invokes onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        MomoCard(
          onTap: () => tapped = true,
          child: const Text('Card body'),
        ),
      ),
    );

    await tester.tap(find.text('Card body'));
    expect(tapped, isTrue);
  });

  testWidgets('MomoCard renders leading and footer slots', (tester) async {
    await tester.pumpWidget(
      wrap(
        const MomoCard(
          leading: Text('Leading'),
          footer: Text('Footer'),
          child: Text('Body'),
        ),
      ),
    );

    expect(find.text('Leading'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
    expect(find.text('Footer'), findsOneWidget);
  });
}
