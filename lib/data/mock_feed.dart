import '../models/playdate.dart';
import '../models/post.dart';
import 'mock_user.dart';

sealed class FeedItem {
  const FeedItem();
}

class PlaydateFeedItem extends FeedItem {
  const PlaydateFeedItem(this.playdate);

  final Playdate playdate;
}

class PostFeedItem extends FeedItem {
  const PostFeedItem(this.post);

  final Post post;
}

const playdateSaturdayPark = Playdate(
  id: 'pd1',
  creatorId: 'mom_sora',
  title: 'Saturday Park Playdate',
  date: 'Sat, Jul 19',
  time: '10:00 AM',
  location: 'Olympic Park, Songpa',
  childAge: '3–5 years',
  description:
      'Easy morning meetup at the playground. Bring snacks and sunscreen. Looking for 2–3 moms nearby!',
  hostName: 'Sora Kim',
  joinedUserIds: ['mom_yuna', 'mom_eunji'],
  maxParticipants: 5,
);

const playdateLibrary = Playdate(
  id: 'pd2',
  creatorId: 'mom_minji',
  title: 'Indoor Library Story Hour',
  date: 'Wed, Jul 23',
  time: '2:30 PM',
  location: 'Jamsil Public Library',
  childAge: '2–4 years',
  description:
      'Quiet story session then free play in the kids corner. Perfect for rainy days.',
  hostName: 'Minji Park',
  joinedUserIds: ['mom_eunji', 'mom_hyejin', 'mom_sora'],
  maxParticipants: null, // unlimited
);

const playdateCafe = Playdate(
  id: 'pd3',
  creatorId: 'mom_hyejin',
  title: 'Café Meetup + Coloring',
  date: 'Fri, Jul 25',
  time: '11:00 AM',
  location: 'Mom Café Banpo',
  childAge: '4–6 years',
  description:
      'Kids color while moms chat. Tables reserved near the play mat area.',
  hostName: 'Hyejin Lee',
  joinedUserIds: [
    'mom_minji',
    'mom_yuna',
    'mom_eunji',
    'mom_sora',
    'mom_jiwoo',
  ],
  maxParticipants: 5,
);

/// Near-capacity limited playdate for fill/leave tests (4/5).
const playdateNearFull = Playdate(
  id: 'pd4',
  creatorId: 'mom_yuna',
  title: 'Toddler Soft Play Meetup',
  date: 'Thu, Jul 24',
  time: '3:00 PM',
  location: 'Kids Zone Gangnam',
  childAge: '1–3 years',
  description: 'Indoor soft play for little ones. One spot left!',
  hostName: 'Yuna Choi',
  joinedUserIds: ['mom_minji', 'mom_eunji', 'mom_hyejin', 'mom_sora'],
  maxParticipants: 5,
);

/// Owned by the mock current user for creator-control demos/tests.
const playdateOwnedByDemo = Playdate(
  id: 'pd5',
  creatorId: currentUserId,
  title: 'Neighborhood Walk & Play',
  date: 'Sun, Jul 26',
  time: '9:30 AM',
  location: 'Hangang Park',
  childAge: '3–6 years',
  description: 'Casual morning walk. Strollers welcome!',
  hostName: 'Demo User',
  joinedUserIds: ['mom_yuna'],
  maxParticipants: 4,
);

const postSeolleung = Post(
  id: 'po1',
  title: 'Anyone free near Seolleung this week?',
  content:
      'My 4-year-old loves outdoor play. Looking for a casual afternoon hang — park or café both fine.',
  authorName: 'Yuna Choi',
);

const postIndoorSpots = Post(
  id: 'po2',
  title: 'Favorite indoor spots for toddlers?',
  content:
      'New to Gangnam. What are your go-to places when it’s too hot outside? Soft play or libraries preferred.',
  authorName: 'Eunji Han',
);

const mockPlaydates = [
  playdateSaturdayPark,
  playdateLibrary,
  playdateCafe,
  playdateNearFull,
  playdateOwnedByDemo,
];

const mockPosts = [
  postSeolleung,
  postIndoorSpots,
];

/// Seed data for providers. Home feed is composed via [feedProvider].

const mockProfile = (
  displayName: 'Jiwoo Mom',
  neighborhood: 'Songpa-gu, Seoul',
  childInfo: 'Daughter, age 4',
  bio:
      'Looking for friendly playdates nearby. Love parks, libraries, and quiet café mornings.',
);
