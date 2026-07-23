import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/result/result.dart';
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

bool _ok(Result<bool> result) => result.isSuccess;

/// Posts as [AsyncValue] (feed load lifecycle).
///
/// Request path: UI → this provider → [PostRepository] → data source.
/// Create mutations use [createPostMutationProvider] for Idle → Loading →
/// Success | Error.
class PostNotifier extends AsyncNotifier<List<Post>> {
  PostRepository get _repo => ref.watch(postRepositoryProvider);

  @override
  Future<List<Post>> build() => _repo.load();

  List<Post> get posts => state.valueOrNull ?? const [];

  void _refresh() {
    state = AsyncData(_readSync(_repo.load()));
  }

  void addPost(Post post) {
    _readSync(_repo.update(post));
    _refresh();
  }

  /// Builds a post from form fields and prepends it to local state.
  void createPost({
    required String title,
    required String content,
    String? authorName,
  }) {
    final result = _readSync(
      _repo.create(
        title: title,
        content: content,
        authorName: authorName,
      ),
    );
    if (!_ok(result)) {
      throw Exception(result.errorOrNull ?? 'Could not create post.');
    }
    _refresh();
  }

  void updatePost(Post post) {
    final result = _readSync(_repo.update(post));
    if (!_ok(result)) {
      throw Exception(result.errorOrNull ?? 'Could not update post.');
    }
    _refresh();
  }
}

final postProvider =
    AsyncNotifierProvider<PostNotifier, List<Post>>(PostNotifier.new);
