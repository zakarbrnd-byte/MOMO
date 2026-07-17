# Design System

Warm  
Minimal  
Rounded Cards  
Large Typography  

## Tokens (code)

| Area | Location |
|------|----------|
| Colors | `lib/core/theme/app_colors.dart` |
| Typography | `lib/core/theme/app_typography.dart` |
| Spacing | `lib/core/theme/app_spacing.dart` |
| Card style | `lib/core/theme/app_card_style.dart` |
| Button style | `lib/core/theme/app_button_style.dart` |
| Theme | `lib/core/theme/app_theme.dart` |

## Card chrome ownership

Feed cards use **`BaseCard` + `AppCardStyle`** (`lib/shared/widgets/cards/`).

- `PlaydateCard` and `PostCard` compose `BaseCard` for radius, border, padding, and tap ink.
- `ThemeData.cardTheme` is configured in `AppTheme` but **not used by feed cards today**.
- Treat `BaseCard` as the source of truth for feed card chrome until Create/Detail screens prove otherwise.
