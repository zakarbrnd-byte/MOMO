import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/core/widgets/empty_state.dart';
import 'package:momo/models/playdate.dart';
import 'package:momo/models/post.dart';
import 'package:momo/providers/playdate_provider.dart';
import 'package:momo/providers/post_provider.dart';

class _EmptyPlaydates extends PlaydateNotifier {
  @override
  Future<List<Playdate>> build() async => [];
}

class _EmptyPosts extends PostNotifier {
  @override
  Future<List<Post>> build() async => [];
}

void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    List<Override> overrides = const [],
  }) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const MomoApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Home shows mock feed content', (tester) async {
    await pumpApp(tester);

    expect(find.text('이번 토요일 공원에서 같이 놀아요 😊'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('킨더 도시락 보통 뭐 싸주시나요?'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('킨더 도시락 보통 뭐 싸주시나요?'), findsOneWidget);
    expect(find.text('아직 등록된 플레이데이트가 없습니다.'), findsNothing);
    expect(find.text('아직 게시글이 없습니다.'), findsNothing);
  });

  testWidgets('Empty playdates shows empty state CTA', (tester) async {
    await pumpApp(
      tester,
      overrides: [
        playdateProvider.overrideWith(_EmptyPlaydates.new),
      ],
    );

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('아직 등록된 플레이데이트가 없습니다.'), findsOneWidget);
    expect(find.text('첫 번째 모임을 만들어보세요.'), findsOneWidget);
    expect(find.text('플레이데이트 만들기'), findsWidgets);

    await tester.tap(find.text('플레이데이트 만들기').last);
    await tester.pumpAndSettle();

    expect(find.text('플레이데이트 만들기'), findsWidgets);
    expect(find.byType(TextFormField), findsWidgets);
  });

  testWidgets('Empty posts shows empty state CTA', (tester) async {
    await pumpApp(
      tester,
      overrides: [
        postProvider.overrideWith(_EmptyPosts.new),
      ],
    );

    final createButton = find.text('글 작성하기');
    await tester.scrollUntilVisible(
      createButton,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('아직 게시글이 없습니다.'), findsOneWidget);
    expect(find.text('첫 번째 이야기를 공유해보세요.'), findsOneWidget);
    expect(createButton, findsWidgets);

    await tester.ensureVisible(createButton.first);
    await tester.pumpAndSettle();
    await tester.tap(createButton.first);
    await tester.pumpAndSettle();

    expect(find.text('글 작성하기'), findsWidgets);
    expect(find.byType(TextFormField), findsWidgets);
  });

  testWidgets('Both empty shows playdate and post empty states',
      (tester) async {
    await pumpApp(
      tester,
      overrides: [
        playdateProvider.overrideWith(_EmptyPlaydates.new),
        postProvider.overrideWith(_EmptyPosts.new),
      ],
    );

    expect(find.text('아직 등록된 플레이데이트가 없습니다.'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('아직 게시글이 없습니다.'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('아직 게시글이 없습니다.'), findsOneWidget);
  });
}
