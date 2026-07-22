/// A child linked to a [User] profile (backend-ready; MVP may leave empty).
class Child {
  const Child({
    this.id,
    this.displayName,
    this.ageLabel,
  });

  final String? id;
  final String? displayName;

  /// Free-form age label for MVP (e.g. "4", "3–5 years").
  final String? ageLabel;

  Child copyWith({
    Object? id = _unset,
    Object? displayName = _unset,
    Object? ageLabel = _unset,
  }) {
    return Child(
      id: identical(id, _unset) ? this.id : id as String?,
      displayName: identical(displayName, _unset)
          ? this.displayName
          : displayName as String?,
      ageLabel: identical(ageLabel, _unset)
          ? this.ageLabel
          : ageLabel as String?,
    );
  }
}

const _unset = Object();
