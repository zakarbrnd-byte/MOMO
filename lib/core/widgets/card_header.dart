import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'card_author_metadata.dart';

/// Shared feed-card header: category badge (start) + author/time (end).
///
/// Title stays outside this widget — always render the card title immediately
/// below [CardHeader]. Used by every Home feed card type.
class CardHeader extends StatelessWidget {
  const CardHeader({
    super.key,
    required this.categoryBadge,
    required this.authorName,
    this.createdAt,
    this.now,
    this.trailing,
  });

  /// Left-aligned chip/badge (e.g. [CategoryChip] or Playdate badge).
  final Widget categoryBadge;

  final String authorName;
  final DateTime? createdAt;

  /// Optional clock override (forwarded to [CardAuthorMetadata] for tests).
  final DateTime? now;

  /// Optional end-aligned control (e.g. bookmark affordance).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Align(alignment: Alignment.centerLeft, child: categoryBadge),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: CardAuthorMetadata(
            authorName: authorName,
            createdAt: createdAt,
            now: now,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.xs),
          trailing!,
        ],
      ],
    );
  }
}
