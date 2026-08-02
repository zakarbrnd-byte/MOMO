import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/time/relative_time_ko.dart';
import '../../core/widgets/momo_card.dart';
import '../../core/widgets/momo_error.dart';
import '../../core/widgets/momo_error_banner.dart';
import '../../models/comment.dart';
import '../../models/post.dart';
import '../../providers/comment_provider.dart';
import '../../providers/post_provider.dart';
import 'comment_rules.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  const PostDetailScreen({
    super.key,
    required this.post,
    @visibleForTesting this.now,
  });

  final Post post;

  @visibleForTesting
  final DateTime? now;

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  late final TextEditingController _composerController;
  final _composerFocus = FocusNode();

  Comment? _replyTarget;
  String? _localValidationError;

  @override
  void initState() {
    super.initState();
    _composerController = TextEditingController();
    _composerController.addListener(_onComposerChanged);
  }

  @override
  void dispose() {
    _composerController
      ..removeListener(_onComposerChanged)
      ..dispose();
    _composerFocus.dispose();
    super.dispose();
  }

  void _onComposerChanged() {
    if (_localValidationError != null) {
      setState(() => _localValidationError = null);
    } else {
      setState(() {});
    }
  }

  Post get _livePost {
    final posts = ref.watch(postProvider).valueOrNull ?? const <Post>[];
    for (final post in posts) {
      if (post.id == widget.post.id) return post;
    }
    return widget.post;
  }

  void _enterReplyMode(Comment target) {
    setState(() => _replyTarget = target);
    _composerFocus.requestFocus();
  }

  void _cancelReplyMode() {
    setState(() => _replyTarget = null);
  }

  Future<void> _submit() async {
    final raw = _composerController.text;
    final validationError = CommentRules.validateBody(raw);
    if (validationError != null) {
      setState(() => _localValidationError = validationError);
      return;
    }

    final isReply = _replyTarget != null;
    final ok = await submitPostComment(
      ref,
      postId: widget.post.id,
      body: raw,
      replyTargetId: _replyTarget?.id,
      isReply: isReply,
    );

    if (!mounted) return;

    if (ok) {
      _composerController.clear();
      setState(() {
        _replyTarget = null;
        _localValidationError = null;
      });
      _composerFocus.unfocus();
      return;
    }

    // Prefer product copy over raw exception / backend simulation text.
    final message = isReply
        ? '답글을 등록하지 못했습니다. 다시 시도해주세요.'
        : '댓글을 등록하지 못했습니다. 다시 시도해주세요.';
    MomoErrorBanner.show(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final post = _livePost;
    final textTheme = Theme.of(context).textTheme;
    final title = post.title.trim().isEmpty
        ? 'Untitled post'
        : post.title.trim();
    final content = post.content.trim().isEmpty
        ? 'No content provided.'
        : post.content.trim();
    final author = post.authorName.trim().isEmpty
        ? 'A MOMO mom'
        : post.authorName.trim();
    final hasContent = post.content.trim().isNotEmpty;
    final commentsAsync = ref.watch(commentsByPostProvider(post.id));
    final threadsAsync = ref.watch(commentThreadsByPostProvider(post.id));
    final mutation = ref.watch(createCommentMutationProvider);
    final isSubmitting = mutation.isLoading;
    final trimmed = _composerController.text.trim();
    final canSubmit = trimmed.isNotEmpty && !isSubmitting;

    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.pageForm,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.lg),
                  MomoCard(
                    padding: AppSpacing.allLg,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.15,
                          ),
                          child: Text(
                            _initials(author),
                            style: textTheme.labelLarge?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(author, style: textTheme.titleMedium),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                post.isGroupPost && post.groupName != null
                                    ? post.groupName!
                                    : 'Shared with the MOMO community',
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Post', style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  SelectableText(
                    content,
                    style: textTheme.bodyLarge?.copyWith(
                      color: hasContent
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('댓글 ${post.commentCount}', style: AppTextStyles.title),
                  const SizedBox(height: AppSpacing.md),
                  commentsAsync.when(
                    loading: () => Padding(
                      padding: AppSpacing.verticalLg,
                      child: Text(
                        '댓글을 불러오는 중...',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    error: (_, __) => MomoError(
                      title: '댓글을 불러오지 못했습니다.',
                      message: '잠시 후 다시 시도해 주세요.',
                      retryLabel: '다시 시도',
                      onRetry: () {
                        ref.invalidate(commentsByPostProvider(post.id));
                      },
                    ),
                    data: (_) {
                      final threads = threadsAsync.valueOrNull ?? const [];
                      if (threads.isEmpty) {
                        return Text(
                          '아직 댓글이 없습니다. 첫 댓글을 남겨보세요.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final thread in threads) ...[
                            _CommentTile(
                              comment: thread.root,
                              now: widget.now,
                              onReply: () => _enterReplyMode(thread.root),
                            ),
                            for (final reply in thread.replies)
                              _CommentTile(
                                comment: reply,
                                isReply: true,
                                now: widget.now,
                                onReply: () => _enterReplyMode(reply),
                              ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
          _CommentComposerBar(
            controller: _composerController,
            focusNode: _composerFocus,
            replyTarget: _replyTarget,
            validationError: _localValidationError,
            isSubmitting: isSubmitting,
            canSubmit: canSubmit,
            onCancelReply: _cancelReplyMode,
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'M';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.comment,
    required this.onReply,
    this.isReply = false,
    this.now,
  });

  final Comment comment;
  final VoidCallback onReply;
  final bool isReply;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final time = RelativeTimeKo.format(comment.createdAt, now: now);
    final meta = time == null
        ? comment.authorName
        : '${comment.authorName} · $time';

    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? AppSpacing.xl : 0,
        bottom: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meta,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(comment.body, style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.xs),
          TextButton(
            onPressed: onReply,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(48, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
            ),
            child: const Text('답글 달기'),
          ),
        ],
      ),
    );
  }
}

class _CommentComposerBar extends StatelessWidget {
  const _CommentComposerBar({
    required this.controller,
    required this.focusNode,
    required this.replyTarget,
    required this.validationError,
    required this.isSubmitting,
    required this.canSubmit,
    required this.onCancelReply,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Comment? replyTarget;
  final String? validationError;
  final bool isSubmitting;
  final bool canSubmit;
  final VoidCallback onCancelReply;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return Material(
      elevation: 6,
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.sm + (bottomInset > 0 ? bottomInset : safeBottom),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (replyTarget != null) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${replyTarget!.authorName}님에게 답글 작성 중',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: isSubmitting ? null : onCancelReply,
                    child: const Text('취소'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    minLines: 1,
                    maxLines: 4,
                    maxLength: CommentRules.maxBodyLength,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요...',
                      counterText: '',
                      errorText: validationError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.background,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilledButton(
                  // Theme uses Size.fromHeight(52) (infinite min width); override
                  // so the button can sit in a Row next to the text field.
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(72, 52),
                    maximumSize: const Size(120, 52),
                  ),
                  onPressed: canSubmit ? onSubmit : null,
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : const Text('등록'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
