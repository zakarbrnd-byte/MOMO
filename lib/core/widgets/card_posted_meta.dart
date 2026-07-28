import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../time/relative_time_ko.dart';

/// End-aligned feed-card metadata: `Author · relative time`.
///
/// Shared by Playdate and Post cards. Uses [RelativeTimeKo] for formatting;
/// when [createdAt] is null, only the author/host name is shown.
class CardPostedMeta extends StatelessWidget {
  const CardPostedMeta({
    super.key,
    required this.authorName,
    this.createdAt,
    this.now,
  });

  final String authorName;
  final DateTime? createdAt;

  /// Optional clock override (used by card widget tests).
  final DateTime? now;

  String get label => RelativeTimeKo.authorWithTime(
        authorName,
        createdAt,
        now: now,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
