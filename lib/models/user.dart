import 'child.dart';

/// Domain user. Ready for auth / profile sync; MVP uses local mock identity.
class User {
  const User({
    required this.id,
    required this.displayName,
    this.profileImageUrl,
    this.location,
    this.children = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String displayName;

  /// Remote avatar URL when available.
  final String? profileImageUrl;

  /// Neighborhood / city label.
  final String? location;

  final List<Child> children;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Backward-compatible alias used by existing call sites.
  String get name => displayName;

  User copyWith({
    String? id,
    String? displayName,
    Object? profileImageUrl = _unset,
    Object? location = _unset,
    List<Child>? children,
    Object? createdAt = _unset,
    Object? updatedAt = _unset,
  }) {
    return User(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      profileImageUrl: identical(profileImageUrl, _unset)
          ? this.profileImageUrl
          : profileImageUrl as String?,
      location: identical(location, _unset)
          ? this.location
          : location as String?,
      children: children ?? this.children,
      createdAt: identical(createdAt, _unset)
          ? this.createdAt
          : createdAt as DateTime?,
      updatedAt: identical(updatedAt, _unset)
          ? this.updatedAt
          : updatedAt as DateTime?,
    );
  }
}

const _unset = Object();
