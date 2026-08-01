import '../core/result/result.dart';
import '../data/datasources/comment_data_source.dart';
import '../features/detail/comment_rules.dart';
import '../models/comment.dart';
import 'comment_repository.dart';

/// Comment access; persistence via [CommentDataSource].
class CommentRepositoryImpl implements CommentRepository {
  CommentRepositoryImpl(this._dataSource);

  final CommentDataSource _dataSource;

  @override
  Future<List<Comment>> loadCommentsByPost(String postId) async {
    final items = await _dataSource.fetchCommentsByPost(postId);
    return [for (final item in items) item.toDomain()];
  }

  @override
  Future<int> loadCommentCount(String postId) async {
    final items = await loadCommentsByPost(postId);
    return CommentRules.totalCount(items);
  }

  @override
  Future<Result<Comment>> createComment({
    required String postId,
    required String authorId,
    required String authorName,
    required String body,
    String? parentCommentId,
  }) async {
    final validationError = CommentRules.validateBody(body);
    if (validationError != null) {
      return Failure(validationError);
    }

    final normalized = CommentRules.normalizeBody(body);
    String? resolvedParent = parentCommentId;

    if (parentCommentId != null) {
      final existing = await loadCommentsByPost(postId);
      Comment? target;
      for (final comment in existing) {
        if (comment.id == parentCommentId) {
          target = comment;
          break;
        }
      }
      if (target == null) {
        return const Failure('답글 대상 댓글을 찾지 못했습니다.');
      }
      resolvedParent = CommentRules.resolveReplyParentId(
        target: target,
        allComments: existing,
      );
    }

    try {
      final dto = await _dataSource.insertComment(
        postId: postId,
        authorId: authorId,
        authorName: authorName,
        body: normalized,
        parentCommentId: resolvedParent,
      );
      return Success(dto.toDomain());
    } catch (_) {
      if (parentCommentId != null) {
        return const Failure('답글을 등록하지 못했습니다. 다시 시도해주세요.');
      }
      return const Failure('댓글을 등록하지 못했습니다. 다시 시도해주세요.');
    }
  }
}
