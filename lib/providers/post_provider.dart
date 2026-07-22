import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../repositories/post_repository.dart';
import '../repositories/repository_providers.dart';

/// Reads a [Future] that completes synchronously (mock [SynchronousFuture]).
T _readSync<T>(Future<T> future) {
  late T value;
  var completed = false;
  future.then((result) {
    value = result;
    completed = true;
  });
  assert(
    completed,
    'PostRepository Futures must complete synchronously in the mock MVP.',
  );
  return value;
}

/// In-memory posts as [AsyncValue] (feed load lifecycle).
///
/// Data access goes through [PostRepository] only.
/// Create mutations use [createPostMutationProvider] for Idle → Loading →
/// Success | Error.
class PostNotifier extends AsyncNotifier<List<Post>> {
  PostRepository get _repo => ref.read(postRepositoryProvider);

  @override
  Future<List<Post>> build() => _repo.getPosts();

  List<Post> get posts => state.valueOrNull ?? const [];

  void _refresh() {
    state = AsyncData(_readSync(_repo.getPosts()));
  }

  void addPost(Post post) {
    _readSync(_repo.updatePost(post));
    _refresh();
  }

  /// Builds a post from form fields and prepends it to local state.
  void createPost({
    required String title,
    required String content,
    String? authorName,
  }) {
    _readSync(
      _repo.createPost(
        title: title,
        content: content,
        authorName: authorName,
      ),
    );
    _refresh();
  }

  void updatePost(Post post) {
    _readSync(_repo.updatePost(post));
    _refresh();
  }
}

final postProvider =
    AsyncNotifierProvider<PostNotifier, List<Post>>(PostNotifier.new);
