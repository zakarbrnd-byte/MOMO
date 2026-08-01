import 'package:flutter/foundation.dart';

import '../../../dto/comment_dto.dart';
import '../../mock_comments.dart';
import '../comment_data_source.dart';

/// In-memory comment store seeded from [mockComments].
class MockCommentDataSource implements CommentDataSource {
  MockCommentDataSource({List<CommentDto>? seed})
      : _items = List<CommentDto>.from(
          seed ??
              [
                for (final comment in mockComments)
                  CommentDto.fromDomain(comment),
              ],
        );

  final List<CommentDto> _items;
  var _sequence = 0;

  @override
  Future<List<CommentDto>> fetchCommentsByPost(String postId) {
    final results = [
      for (final item in _items)
        if (item.postId == postId) item,
    ];
    return SynchronousFuture(List<CommentDto>.from(results));
  }

  @override
  Future<CommentDto> insertComment({
    required String postId,
    required String authorId,
    required String authorName,
    required String body,
    String? parentCommentId,
  }) {
    _sequence += 1;
    final created = CommentDto(
      id: 'cmt_new_${DateTime.now().microsecondsSinceEpoch}_$_sequence',
      postId: postId,
      authorId: authorId,
      authorName: authorName,
      body: body,
      createdAt: DateTime.now().toUtc(),
      parentCommentId: parentCommentId,
    );
    _items.add(created);
    return SynchronousFuture(created);
  }
}
