/// Host or author shown on cards.
class MomUser {
  const MomUser({
    required this.id,
    required this.displayName,
    this.neighborhood,
  });

  final String id;
  final String displayName;

  /// Optional area label, e.g. "Irvine".
  final String? neighborhood;
}
