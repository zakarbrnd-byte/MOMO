import 'playdate.dart';
import 'post.dart';

/// A single Home Feed row — either a playdate or a post.
sealed class FeedItem {
  const FeedItem();

  String get id;
}

final class PlaydateFeedItem extends FeedItem {
  const PlaydateFeedItem(this.playdate);

  final Playdate playdate;

  @override
  String get id => playdate.id;
}

final class PostFeedItem extends FeedItem {
  const PostFeedItem(this.post);

  final Post post;

  @override
  String get id => post.id;
}
