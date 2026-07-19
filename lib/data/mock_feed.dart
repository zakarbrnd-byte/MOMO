import '../models/playdate.dart';
import '../models/post.dart';

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
  title: 'Saturday Park Playdate',
  date: 'Sat, Jul 19',
  time: '10:00 AM',
  location: 'Olympic Park, Songpa',
  childAge: '3–5 years',
  description:
      'Easy morning meetup at the playground. Bring snacks and sunscreen. Looking for 2–3 moms nearby!',
  hostName: 'Sora Kim',
);

const playdateLibrary = Playdate(
  id: 'pd2',
  title: 'Indoor Library Story Hour',
  date: 'Wed, Jul 23',
  time: '2:30 PM',
  location: 'Jamsil Public Library',
  childAge: '2–4 years',
  description:
      'Quiet story session then free play in the kids corner. Perfect for rainy days.',
  hostName: 'Minji Park',
);

const playdateCafe = Playdate(
  id: 'pd3',
  title: 'Café Meetup + Coloring',
  date: 'Fri, Jul 25',
  time: '11:00 AM',
  location: 'Mom Café Banpo',
  childAge: '4–6 years',
  description:
      'Kids color while moms chat. Tables reserved near the play mat area.',
  hostName: 'Hyejin Lee',
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
];

const mockPosts = [
  postSeolleung,
  postIndoorSpots,
];

/// Mixed home feed: playdates and posts interleaved.
const mockFeedItems = <FeedItem>[
  PlaydateFeedItem(playdateSaturdayPark),
  PostFeedItem(postSeolleung),
  PlaydateFeedItem(playdateLibrary),
  PostFeedItem(postIndoorSpots),
  PlaydateFeedItem(playdateCafe),
];

const mockProfile = (
  displayName: 'Jiwoo Mom',
  neighborhood: 'Songpa-gu, Seoul',
  childInfo: 'Daughter, age 4',
  bio:
      'Looking for friendly playdates nearby. Love parks, libraries, and quiet café mornings.',
);
