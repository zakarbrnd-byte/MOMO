import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/core/widgets/empty_state.dart';
import 'package:momo/data/mock_groups.dart';
import 'package:momo/models/group.dart';
import 'package:momo/models/post.dart';
import 'package:momo/providers/group_provider.dart';
import 'package:momo/providers/post_provider.dart';

class _EmptyGroups extends GroupNotifier {
  @override
  Future<List<Group>> build() async => [];
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
      ProviderScope(overrides: overrides, child: const MomoApp()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Home shows mock feed content', (tester) async {
    await pumpApp(tester);

    expect(find.textContaining('LA 3살'), findsWidgets);
    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text(mockGlobalPosts.first.title),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text(mockGlobalPosts.first.title), findsOneWidget);
    expect(find.text('아직 등록된 모임이 없습니다.'), findsNothing);
    expect(find.text('아직 커뮤니티 게시글이 없습니다.'), findsNothing);
    expect(find.text('Create Playdate'), findsNothing);
  });

  testWidgets('Empty groups shows empty state CTA', (tester) async {
    await pumpApp(
      tester,
      overrides: [groupProvider.overrideWith(_EmptyGroups.new)],
    );

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('아직 등록된 모임이 없습니다.'), findsOneWidget);
    expect(find.text('관심사·나이·지역으로 첫 커뮤니티를 만들어보세요.'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Create Group'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Create Group'));
    await tester.pumpAndSettle();

    expect(find.text('Create Group'), findsWidgets);
    expect(find.byType(TextFormField), findsWidgets);
  });

  testWidgets('Empty posts shows empty state CTA', (tester) async {
    await pumpApp(
      tester,
      overrides: [postProvider.overrideWith(_EmptyPosts.new)],
    );

    await tester.scrollUntilVisible(
      find.text('아직 커뮤니티 게시글이 없습니다.'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('아직 커뮤니티 게시글이 없습니다.'), findsOneWidget);
    expect(find.text('첫 번째 이야기를 공유해보세요.'), findsOneWidget);
    final createPost = find.widgetWithText(FilledButton, 'Create Post');
    await tester.ensureVisible(createPost);
    await tester.tap(createPost);
    await tester.pumpAndSettle();

    expect(find.text('Create Post'), findsWidgets);
    expect(find.byType(TextFormField), findsWidgets);
  });

  testWidgets('Both empty shows group empty state first', (tester) async {
    await pumpApp(
      tester,
      overrides: [
        groupProvider.overrideWith(_EmptyGroups.new),
        postProvider.overrideWith(_EmptyPosts.new),
      ],
    );

    expect(find.text('아직 등록된 모임이 없습니다.'), findsOneWidget);
    expect(find.text('아직 커뮤니티 게시글이 없습니다.'), findsNothing);
  });
}
