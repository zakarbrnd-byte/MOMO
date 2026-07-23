/// Backend request flow — architectural reference (Phase 3.4.5).
///
/// ## Standard path
///
/// ```
/// User tap
///   → Provider (exposes AsyncOpState / AsyncValue)
///   → Repository (rules + Result)
///   → Data Source (raw I/O)
///   → API / DB (future)
///   → Response up the same stack
///   → UI refresh
/// ```
///
/// ## Lifecycle (mutations)
///
/// ```
/// Idle → Loading → Success
///                ↘ Error → Retry → Loading …
/// ```
///
/// Driven by [AsyncOpState] via [MutationNotifier].
///
/// ## Mapping (future network)
///
/// ```
/// JSON → DTO → Domain → Provider → UI
/// ```
///
/// DTOs live under `lib/dto/`. Providers never import DTOs or data sources.
///
/// See `ARCHITECTURE.md` for full diagrams.
library;
