/// Tiny display helpers for card meta text. No i18n package yet.
abstract final class CardFormat {
  static const _months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String playdateWhen(DateTime startsAt) {
    final month = _months[startsAt.month - 1];
    final day = startsAt.day;
    final time = _time(startsAt);
    return '$month $day · $time';
  }

  static String postWhen(DateTime createdAt, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final diff = current.difference(createdAt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    final month = _months[createdAt.month - 1];
    return '$month ${createdAt.day}';
  }

  static String _time(DateTime dt) {
    final hour24 = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    return '$hour12:$minute $period';
  }
}
