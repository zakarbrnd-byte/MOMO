/// Bundled typography family for MOMO.
///
/// Pretendard is registered in `pubspec.yaml` (weights 400/500/600/700) and
/// applied globally via [AppTheme] / [AppTextStyles]. No runtime font CDN.
abstract final class AppFonts {
  static const String family = 'Pretendard';

  /// Safe OS fallbacks if a glyph is somehow missing from the bundle.
  static const List<String> fallback = <String>[
    'Apple SD Gothic Neo',
    'Noto Sans KR',
    'sans-serif',
  ];
}
