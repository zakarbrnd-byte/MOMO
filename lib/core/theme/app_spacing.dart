import 'package:flutter/material.dart';

/// Spacing scale for MOMO — 4pt base, generous for touch and cards.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Horizontal inset for screens / feed lists.
  static const double page = lg;

  /// Default inner padding for cards.
  static const double card = lg;

  /// Gap between stacked cards in a feed.
  static const double cardGap = md;

  /// Space between major screen sections.
  static const double section = xl;

  /// Minimum comfortable tap target.
  static const double tapTarget = 48;

  // EdgeInsets helpers

  static const EdgeInsets pageInsets = EdgeInsets.symmetric(horizontal: page);

  static const EdgeInsets cardInsets = EdgeInsets.all(card);

  static const EdgeInsets screenInsets = EdgeInsets.fromLTRB(
    page,
    lg,
    page,
    xl,
  );

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

  static EdgeInsets all(double value) => EdgeInsets.all(value);

  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
}
