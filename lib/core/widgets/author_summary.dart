import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Compact author metadata row for feed cards and detail headers.
///
/// Only [displayName] is required. Avatar URL, location, and contextual
/// labels are optional so callers can pass currently available Post fields
/// without inventing missing domain data.
class AuthorSummary extends StatelessWidget {
  const AuthorSummary({
    super.key,
    required this.displayName,
    this.avatarUrl,
    this.location,
    this.contextualLabel,
    this.avatarRadius = 16,
  });

  final String displayName;

  /// Remote avatar URL when available. Invalid / missing URLs fall back.
  final String? avatarUrl;

  /// Optional neighborhood / city label.
  final String? location;

  /// Optional free-form subtitle (e.g. child age). Prefer over inventing data.
  final String? contextualLabel;

  final double avatarRadius;

  String get _subtitle {
    final parts = <String>[
      if (location != null && location!.trim().isNotEmpty) location!.trim(),
      if (contextualLabel != null && contextualLabel!.trim().isNotEmpty)
        contextualLabel!.trim(),
    ];
    return parts.join(' · ');
  }

  String get _initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'M';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = _subtitle;
    final hasSubtitle = subtitle.isNotEmpty;
    final name = displayName.trim().isEmpty ? 'A MOMO mom' : displayName.trim();

    return Semantics(
      label: hasSubtitle ? '$name, $subtitle' : name,
      excludeSemantics: true,
      child: Row(
        children: [
          _Avatar(
            avatarUrl: avatarUrl,
            initials: _initials,
            radius: avatarRadius,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (hasSubtitle) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.avatarUrl,
    required this.initials,
    required this.radius,
  });

  final String? avatarUrl;
  final String initials;
  final double radius;

  bool get _hasUsableUrl {
    final url = avatarUrl?.trim() ?? '';
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Widget _fallback() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primarySoft,
      child: Text(
        initials,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasUsableUrl) return _fallback();

    final size = radius * 2;
    return ClipOval(
      child: Image.network(
        avatarUrl!.trim(),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      ),
    );
  }
}
