/// Korean relative-time labels for community feed metadata.
///
/// Pure formatting helper — no Flutter dependencies. Tests should pass a fixed
/// [now] instead of relying on the live clock.
abstract final class RelativeTimeKo {
  /// Returns a Korean relative label, or `null` when [timestamp] is missing.
  static String? format(DateTime? timestamp, {DateTime? now}) {
    if (timestamp == null) return null;

    final current = now ?? DateTime.now();
    final diff = current.difference(timestamp);

    // Future or clock skew → treat as just now.
    if (diff.isNegative || diff.inSeconds < 60) {
      return '방금 전';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    }

    final currentDay = DateTime(current.year, current.month, current.day);
    final timestampDay =
        DateTime(timestamp.year, timestamp.month, timestamp.day);
    final dayDiff = currentDay.difference(timestampDay).inDays;

    if (dayDiff == 1) {
      return '어제';
    }
    if (dayDiff < 7) {
      return '$dayDiff일 전';
    }

    return '${timestamp.month}월 ${timestamp.day}일';
  }

  /// Author label with optional relative time: `이름 · 2시간 전`.
  ///
  /// When [createdAt] is null, returns only the author name (no separator).
  static String authorWithTime(
    String authorName,
    DateTime? createdAt, {
    DateTime? now,
  }) {
    final name = authorName.trim().isEmpty ? 'A MOMO mom' : authorName.trim();
    final relative = format(createdAt, now: now);
    if (relative == null || relative.isEmpty) return name;
    return '$name · $relative';
  }
}
