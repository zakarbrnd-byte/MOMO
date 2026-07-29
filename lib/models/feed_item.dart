import 'group.dart';
import 'playdate.dart';
import 'post.dart';

/// Sealed feed row for the home list.
sealed class FeedItem {
  const FeedItem();
}

class GroupFeedItem extends FeedItem {
  const GroupFeedItem(this.group);

  final Group group;
}

class PostFeedItem extends FeedItem {
  const PostFeedItem(this.post);

  final Post post;
}

/// Legacy Playdate feed row — retired from active Home UI in Phase 3.7.
@Deprecated('Playdate cards removed from active Home; use GroupFeedItem')
class PlaydateFeedItem extends FeedItem {
  const PlaydateFeedItem(this.playdate);

  final Playdate playdate;
}
