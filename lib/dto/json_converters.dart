/// Shared JSON helpers for DTOs (ISO-8601 dates, safe casts).
///
/// Kept in the data/DTO layer — domain models and UI never call these.
abstract final class JsonConverters {
  /// Parses an ISO-8601 string (or passthrough [DateTime]). Returns null if absent.
  static DateTime? dateTimeFromJson(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      return DateTime.parse(trimmed);
    }
    throw FormatException('Expected DateTime or ISO-8601 String, got $value');
  }

  /// Serializes to ISO-8601. Omits null by returning null (caller decides key).
  static String? dateTimeToJson(DateTime? value) => value?.toIso8601String();

  static String stringFromJson(Object? value, {String fallback = ''}) {
    if (value == null) return fallback;
    if (value is String) return value;
    return value.toString();
  }

  static String? nullableStringFromJson(Object? value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static int? intFromJson(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static bool boolFromJson(Object? value, {bool fallback = false}) {
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is num) return value != 0;
    return fallback;
  }

  static List<String> stringListFromJson(Object? value) {
    if (value == null) return const [];
    if (value is! List) return const [];
    return [
      for (final item in value) stringFromJson(item),
    ];
  }

  /// Reads a known enum by name; unknown / missing → [fallback].
  static T enumFromJson<T extends Enum>(
    Object? value,
    List<T> values, {
    required T fallback,
  }) {
    if (value is! String || value.isEmpty) return fallback;
    for (final item in values) {
      if (item.name == value) return item;
    }
    return fallback;
  }

  static String enumToJson(Enum value) => value.name;
}
