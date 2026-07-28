import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../time/relative_time_ko.dart';

/// Shared feed-card author metadata: `Author · relative time`.
///
/// Used by Playdate and Post cards. Formats via [RelativeTimeKo], sits in
/// normal vertical flow under the title, and end-aligns within card padding.
/// Long author names ellipsize; the relative-time suffix stays visible when
/// present.
class CardAuthorMetadata extends StatelessWidget {
  const CardAuthorMetadata({
    super.key,
    required this.authorName,
    this.createdAt,
    this.now,
    this.style,
  });

  final String authorName;
  final DateTime? createdAt;

  /// Optional clock override (used by card widget tests).
  final DateTime? now;

  /// Optional override; defaults to [AppTextStyles.caption].
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? AppTextStyles.caption;
    final name = authorName.trim().isEmpty ? 'A MOMO mom' : authorName.trim();
    final relative = RelativeTimeKo.format(createdAt, now: now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            name,
            style: textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
        if (relative != null && relative.isNotEmpty)
          Text(
            ' · $relative',
            style: textStyle,
            maxLines: 1,
            softWrap: false,
          ),
      ],
    );
  }
}
