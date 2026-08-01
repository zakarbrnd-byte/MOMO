import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/async/mutation_notifier.dart';
import '../core/models/async_state.dart';
import '../core/result/result.dart';
import '../features/detail/comment_rules.dart';
import '../models/comment.dart';
import '../repositories/repository_providers.dart';
import 'current_user_provider.dart';
import 'post_provider.dart';

/// Async comments for one Post. Always awaited — no sync Future bridge.
final commentsByPostProvider = FutureProvider.family<List<Comment>, String>((
  ref,
  postId,
) async {
  final repo = ref.watch(commentRepositoryProvider);
  return repo.loadCommentsByPost(postId);
});

/// One-level threads derived from [commentsByPostProvider].
final commentThreadsByPostProvider =
    Provider.family<AsyncValue<List<CommentThread>>, String>((ref, postId) {
  return ref
      .watch(commentsByPostProvider(postId))
      .whenData(CommentRules.buildCommentThreads);
});

/// Comment create / reply mutation lifecycle (per Post Detail screen).
final createCommentMutationProvider =
    NotifierProvider.autoDispose<MutationNotifier, AsyncOpState<void>>(
  MutationNotifier.new,
);

/// Creates a comment or reply, syncs [Post.commentCount], invalidates readers.
///
/// [replyTargetId] is the tapped comment id (top-level or reply). Repository
/// normalizes reply-to-reply to the original thread root.
Future<bool> submitPostComment(
  WidgetRef ref, {
  required String postId,
  required String body,
  String? replyTargetId,
  required bool isReply,
}) async {
  final user = ref.read(currentUserProvider);
  final repo = ref.read(commentRepositoryProvider);

  final succeeded = await ref
      .read(createCommentMutationProvider.notifier)
      .runResult(() async {
    final result = await repo.createComment(
      postId: postId,
      authorId: user.id,
      authorName: user.displayName,
      body: body,
      parentCommentId: replyTargetId,
    );
    return result.when(
      success: (_) => const Success(true),
      failure: (message) => Failure<bool>(message),
    );
  });

  if (!succeeded) return false;

  ref.invalidate(commentsByPostProvider(postId));
  await ref.read(commentsByPostProvider(postId).future);

  final count = await repo.loadCommentCount(postId);
  ref.read(postProvider.notifier).syncCommentCount(postId, count);
  return true;
}
