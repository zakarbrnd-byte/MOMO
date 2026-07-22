import 'playdate.dart';
import 'post.dart';

/// Sealed feed row for the home list (playdate or post card).
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
