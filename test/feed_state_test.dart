import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/models/playdate.dart';
import 'package:momo/providers/playdate_provider.dart';

void main() {
  testWidgets('Home shows seeded mock playdates', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MomoApp(),
      ),
    );

    expect(find.text('Saturday Park Playdate'), findsOneWidget);
    expect(find.text('Anyone free near Seolleung this week?'), findsOneWidget);
  });

  testWidgets('Adding a playdate updates the Home feed', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MomoApp(),
      ),
    );

    container.read(playdateProvider.notifier).addPlaydate(
          const Playdate(
            id: 'pd_test',
            title: 'Test Park Meetup',
            date: 'Mon, Jul 20',
            time: '9:00 AM',
            location: 'Test Park',
            childAge: '3–5 years',
            description: 'Provider smoke test',
            hostName: 'Jiwoo Mom',
          ),
        );
    await tester.pumpAndSettle();

    expect(find.text('Test Park Meetup'), findsOneWidget);
  });
}
