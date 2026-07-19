import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';

void main() {
  testWidgets('MOMO app shows Home tab', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MomoApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('MOMO'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
  });
}
