/// Shared validation helpers and copy for MOMO forms.
///
/// Keep wording consistent across Create, Login, Profile Edit, etc.
abstract final class FormValidators {
  static const String titleRequired = 'Please enter a title.';
  static const String contentRequired = 'Please enter content.';
  static const String locationRequired = 'Please enter a location.';
  static const String dateRequired = 'Please select a date.';
  static const String capacityInvalid =
      'Please enter a valid participant limit.';

  /// Common max lengths for text inputs (future screens reuse these).
  static const int shortTitleMax = 80;
  static const int longTextMax = 2000;
  static const int mediumTextMax = 1000;

  static String? requiredTrimmed(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? maxLength(String? value, int max, {String? fieldLabel}) {
    if (value == null) return null;
    if (value.trim().length > max) {
      final label = fieldLabel ?? 'This field';
      return '$label must be $max characters or fewer.';
    }
    return null;
  }

  static String? minLength(String? value, int min, {String? fieldLabel}) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.trim().length < min) {
      final label = fieldLabel ?? 'This field';
      return '$label must be at least $min characters.';
    }
    return null;
  }

  /// Optional positive integer (empty is allowed).
  static String? optionalPositiveInt(String? value, {String? message}) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return null;
    final parsed = int.tryParse(raw);
    if (parsed == null || parsed <= 0) {
      return message ?? capacityInvalid;
    }
    return null;
  }

  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
