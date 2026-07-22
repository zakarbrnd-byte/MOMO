/// Lifecycle status for a [Playdate].
enum PlaydateStatus {
  active,
  cancelled,
  completed,
}

/// Lifecycle status for a [Post].
enum PostStatus {
  active,
  hidden,
  deleted,
}

/// Lifecycle status for a [Participant] join record.
enum ParticipantStatus {
  active,
  left,
  removed,
}
