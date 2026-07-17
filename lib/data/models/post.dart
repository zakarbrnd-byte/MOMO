import 'mom_user.dart';

/// Post card data — short mom-to-mom note in the feed.
class Post {
  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.author,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final MomUser author;
  final DateTime createdAt;
}
