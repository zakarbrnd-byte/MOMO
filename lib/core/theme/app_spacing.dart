import 'package:flutter/material.dart';

/// Centralized spacing tokens for MOMO layouts.
///
/// Prefer these over raw `SizedBox(height: 12)` / `EdgeInsets.all(16)`.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // --- EdgeInsets helpers ---

  static const EdgeInsets allXs = EdgeInsets.all(xs);
  static const EdgeInsets allSm = EdgeInsets.all(sm);
  static const EdgeInsets allMd = EdgeInsets.all(md);
  static const EdgeInsets allLg = EdgeInsets.all(lg);
  static const EdgeInsets allXl = EdgeInsets.all(xl);
  static const EdgeInsets allXxl = EdgeInsets.all(xxl);

  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);

  /// Standard screen body inset (feed, profile, create forms).
  static const EdgeInsets page = EdgeInsets.fromLTRB(xl, sm, xl, xl);

  /// Create-form body with extra bottom room for the primary button.
  static const EdgeInsets pageForm = EdgeInsets.fromLTRB(xl, sm, xl, xxl);

  /// Vertical gap between stacked form fields.
  static const double formFieldGap = lg;

  /// Space above the primary submit button in a form.
  static const double formSubmitGap = xl;

  /// Create-tab selection screen inset.
  static const EdgeInsets pageCreate = EdgeInsets.fromLTRB(xl, md, xl, xl);

  /// Bottom action bar (join / owner controls).
  static const EdgeInsets actionBar = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: md,
  );

  // --- Card spacing / shape ---

  /// Corner radius for [MomoCard] and feed cards.
  static const double cardRadius = 20;

  /// Gap between cards in a vertical list (Home feed).
  static const double cardListGap = lg;

  /// Inner padding for feed / profile cards.
  static const EdgeInsets cardPadding = EdgeInsets.all(xl);

  /// Slightly tighter padding for dense detail info cards.
  static const EdgeInsets cardDetailPadding = EdgeInsets.fromLTRB(
    lg,
    lg,
    lg,
    sm,
  );

  /// Space between card title and following content.
  static const double cardTitleGap = md;

  /// Space between stacked meta / body lines inside a card.
  static const double cardContentGap = sm;

  /// Space above card footer / trailing actions.
  static const double cardFooterGap = md;

  /// Chip / badge inset inside cards.
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: xs,
  );

  /// Empty-state card content inset.
  static const EdgeInsets emptyStatePadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: xxl,
  );
}
