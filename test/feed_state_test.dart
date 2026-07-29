import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:momo/app.dart';
import 'package:momo/data/mock_groups.dart';
import 'package:momo/models/feed_item.dart';
import 'package:momo/models/group.dart';
import 'package:momo/models/post.dart';
import 'package:momo/providers/feed_provider.dart';
import 'package:momo/providers/group_provider.dart';

void main() {
  test('composeFeedItems lists featured groups then global posts', () {
    const featured = Group(
      id: 'g1',
      name: 'Featured',
      description: 'd',
      category: '육아',
      location: 'LA',
      ownerId: 'u1',
      ownerName: 'Ann',
      isFeatured: true,
    );
    const other = Group(
      id: 'g2',
      name: 'Other',
      description: 'd',
      category: '육아',
      location: 'OC',
      ownerId: 'u2',
      ownerName: 'Bee',
      isFeatured: false,
    );
    const globalPost = Post(
      id: 'p1',
      title: 'Global',
      content: 'Body',
      authorName: 'Ann',
    );
    const groupPost = Post(
      id: 'p2',
      title: 'Group only',
      content: 'Body',
      authorName: 'Bee',
      groupId: 'g1',
      groupName: 'Featured',
    );

    final items = composeFeedItems(
      groups: [other, featured],
      posts: [groupPost, globalPost],
    );

    expect(items.length, 3);
    expect(items[0], isA<GroupFeedItem>());
    expect((items[0] as GroupFeedItem).group.id, 'g1');
    expect((items[1] as GroupFeedItem).group.id, 'g2');
    expect(items[2], isA<PostFeedItem>());
    expect((items[2] as PostFeedItem).post.id, 'p1');
  });

  testWidgets('Home shows seeded mock groups and global posts', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MomoApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('LA 3살'), findsOneWidget);
    expect(find.text('이번 토요일 공원에서 같이 놀아요 😊'), findsNothing);

    await tester.scrollUntilVisible(
      find.text(mockGlobalPosts.first.title),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text(mockGlobalPosts.first.title), findsOneWidget);
  });

  testWidgets('Adding a group updates the Home feed', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MomoApp(),
      ),
    );
    await tester.pumpAndSettle();

    await container.read(groupProvider.notifier).createGroup(
          name: 'Test Park Moms',
          description: 'Provider smoke test for groups',
          category: '육아',
          location: 'Test Park',
        );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Test Park Moms'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Test Park Moms'), findsOneWidget);
  });
}
