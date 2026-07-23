import '../models/profile.dart';
import 'json_converters.dart';

/// Wire format for [Profile].
class ProfileDto {
  const ProfileDto({
    required this.displayName,
    required this.neighborhood,
    required this.childInfo,
    required this.bio,
  });

  final String displayName;
  final String neighborhood;
  final String childInfo;
  final String bio;

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    return ProfileDto(
      displayName: JsonConverters.stringFromJson(json['displayName']),
      neighborhood: JsonConverters.stringFromJson(json['neighborhood']),
      childInfo: JsonConverters.stringFromJson(json['childInfo']),
      bio: JsonConverters.stringFromJson(json['bio']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'neighborhood': neighborhood,
      'childInfo': childInfo,
      'bio': bio,
    };
  }

  Profile toDomain() {
    return Profile(
      displayName: displayName,
      neighborhood: neighborhood,
      childInfo: childInfo,
      bio: bio,
    );
  }

  factory ProfileDto.fromDomain(Profile profile) {
    return ProfileDto(
      displayName: profile.displayName,
      neighborhood: profile.neighborhood,
      childInfo: profile.childInfo,
      bio: profile.bio,
    );
  }
}
