import '../core/result/result.dart';
import '../data/datasources/post_data_source.dart';
import '../dto/post_dto.dart';
import '../models/post.dart';
import 'post_repository.dart';

/// Post access; persistence via [PostDataSource].
class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this._dataSource);

  final PostDataSource _dataSource;

  @override
  Future<List<Post>> load() {
    return _dataSource.getPosts().then((items) {
      return [
        for (final item in items) PostDto.fromDomain(item).toDomain(),
      ];
    });
  }

  @override
  Future<Result<bool>> create({
    required String title,
    required String content,
    String? authorName,
  }) {
    return _dataSource
        .createPost(
          title: title,
          content: content,
          authorName: authorName,
        )
        .then((_) => const Success(true));
  }

  @override
  Future<Result<bool>> update(Post post) {
    return _dataSource
        .updatePost(post)
        .then((_) => const Success(true));
  }

  @override
  Future<Result<bool>> delete(String postId) {
    return _dataSource.deletePost(postId).then((ok) {
      return ok
          ? const Success(true)
          : const Failure('Could not delete post.');
    });
  }
}
