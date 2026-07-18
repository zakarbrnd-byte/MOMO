import '../models/feed_item.dart';
import '../models/mom_user.dart';
import '../models/playdate.dart';
import '../models/post.dart';

/// Fictional mock moms for demos/tests (not real people).
abstract final class MockUsers {
  static const soojin = MomUser(
    id: 'u_soojin',
    displayName: 'Soojin Kim',
    neighborhood: 'Irvine',
  );

  static const hana = MomUser(
    id: 'u_hana',
    displayName: 'Hana Park',
    neighborhood: 'Fullerton',
  );

  static const yuna = MomUser(
    id: 'u_yuna',
    displayName: 'Yuna Lee',
    neighborhood: 'Buena Park',
  );

  static const mina = MomUser(
    id: 'u_mina',
    displayName: 'Mina Choi',
    neighborhood: 'Tustin',
  );

  static const jieun = MomUser(
    id: 'u_jieun',
    displayName: 'Jieun Han',
    neighborhood: 'Orange',
  );
}

/// Mixed Home Feed — mock only, no backend.
abstract final class MockFeed {
  /// Stable "now" so relative post times stay readable in demos/tests.
  static final DateTime now = DateTime(2026, 7, 17, 18, 0);

  static final List<FeedItem> items = [
    PlaydateFeedItem(
      Playdate(
        id: 'pd_park_morning',
        title: 'Saturday park morning',
        startsAt: DateTime(2026, 7, 19, 10, 0),
        location: 'Central Park playground, Irvine',
        host: MockUsers.soojin,
        ageRange: '3–5',
      ),
    ),
    PostFeedItem(
      Post(
        id: 'post_thursday',
        title: 'Anyone free Thursday afternoon?',
        body:
            'Looking for a short indoor meetup near the library. Toddlers welcome.',
        author: MockUsers.hana,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
    ),
    PlaydateFeedItem(
      Playdate(
        id: 'pd_library_story',
        title: 'Library story time hang',
        startsAt: DateTime(2026, 7, 21, 11, 0),
        location: 'OC Public Library — Tustin branch',
        host: MockUsers.mina,
        ageRange: '2–4',
      ),
    ),
    PostFeedItem(
      Post(
        id: 'post_new_to_area',
        title: 'New to Fullerton — say hi?',
        body:
            'We just moved. Would love to meet other moms with kids under 5.',
        author: MockUsers.yuna,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
    ),
    PlaydateFeedItem(
      Playdate(
        id: 'pd_picnic',
        title: 'Weekday picnic + bubbles',
        startsAt: DateTime(2026, 7, 22, 16, 30),
        location: 'Peters Canyon picnic lawn',
        host: MockUsers.jieun,
        ageRange: '4–7',
      ),
    ),
    PostFeedItem(
      Post(
        id: 'post_swim',
        title: 'Swim class carpool?',
        body: 'Tuesday 9am Lessons in Irvine. One seat left if anyone is going.',
        author: MockUsers.soojin,
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
      ),
    ),
    PlaydateFeedItem(
      Playdate(
        id: 'pd_cafe',
        title: 'Quiet cafe playdate',
        startsAt: DateTime(2026, 7, 23, 14, 0),
        location: 'Morning Lavender Cafe, Orange',
        host: MockUsers.hana,
        ageRange: '0–3',
      ),
    ),
    PostFeedItem(
      Post(
        id: 'post_rainy',
        title: 'Rainy-day ideas near Buena Park',
        body: 'Indoor playground recs that aren’t too crowded on weekends?',
        author: MockUsers.yuna,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ),
  ];
}
