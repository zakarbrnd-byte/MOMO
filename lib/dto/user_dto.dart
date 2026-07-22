import '../models/user.dart';
import 'child_dto.dart';
import 'json_converters.dart';

/// Wire format for [User].
///
/// Extra JSON keys (auth tokens, adminStatus, …) are ignored.
class UserDto {
  const UserDto({
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
  final String? profileImageUrl;
  final String? location;
  final List<ChildDto> children;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory UserDto.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'];
    final children = <ChildDto>[];
    if (rawChildren is List) {
      for (final item in rawChildren) {
        if (item is Map<String, dynamic>) {
          children.add(ChildDto.fromJson(item));
        } else if (item is Map) {
          children.add(
            ChildDto.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    return UserDto(
      id: JsonConverters.stringFromJson(json['id']),
      displayName: JsonConverters.stringFromJson(json['displayName']),
      profileImageUrl:
          JsonConverters.nullableStringFromJson(json['profileImageUrl']),
      location: JsonConverters.nullableStringFromJson(json['location']),
      children: children,
      createdAt: JsonConverters.dateTimeFromJson(json['createdAt']),
      updatedAt: JsonConverters.dateTimeFromJson(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      if (location != null) 'location': location,
      'children': [for (final child in children) child.toJson()],
      if (createdAt != null)
        'createdAt': JsonConverters.dateTimeToJson(createdAt),
      if (updatedAt != null)
        'updatedAt': JsonConverters.dateTimeToJson(updatedAt),
    };
  }

  User toDomain() {
    return User(
      id: id,
      displayName: displayName,
      profileImageUrl: profileImageUrl,
      location: location,
      children: [for (final child in children) child.toDomain()],
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory UserDto.fromDomain(User user) {
    return UserDto(
      id: user.id,
      displayName: user.displayName,
      profileImageUrl: user.profileImageUrl,
      location: user.location,
      children: [
        for (final child in user.children) ChildDto.fromDomain(child),
      ],
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}
