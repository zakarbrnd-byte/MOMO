import '../data/datasources/post_data_source.dart';
import '../dto/post_dto.dart';
import '../models/post.dart';
import 'post_repository.dart';

/// Post access; persistence via [PostDataSource].
///
/// Providers depend on [PostRepository] only — never on a data source.
class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this._dataSource);

  final PostDataSource _dataSource;

  @override
  Future<List<Post>> getPosts() {
    return _dataSource.getPosts().then((items) {
      return [
        for (final item in items) PostDto.fromDomain(item).toDomain(),
      ];
    });
  }

  @override
  Future<void> createPost({
    required String title,
    required String content,
    String? authorName,
  }) {
    return _dataSource.createPost(
      title: title,
      content: content,
      authorName: authorName,
    );
  }

  @override
  Future<void> updatePost(Post post) {
    return _dataSource.updatePost(post);
  }

  @override
  Future<bool> deletePost(String postId) {
    return _dataSource.deletePost(postId);
  }
}
