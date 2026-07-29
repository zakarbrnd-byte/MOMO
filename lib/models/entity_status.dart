/// Lifecycle status for a [Playdate] (legacy foundation entity).
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

/// Lifecycle status for a [Participant] join record (legacy playdate).
enum ParticipantStatus {
  active,
  left,
  removed,
}

/// Lifecycle status for an [EventAnnouncement].
enum EventStatus {
  scheduled,
  cancelled,
  completed,
}

/// RSVP response for an [EventAnnouncement].
enum RsvpStatus {
  attending,
  notAttending,
  undecided,
}
