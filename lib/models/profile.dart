/// Display profile for the Profile tab (MVP local; future auth profile row).
class Profile {
  const Profile({
    required this.displayName,
    required this.neighborhood,
    required this.childInfo,
    required this.bio,
  });

  final String displayName;
  final String neighborhood;
  final String childInfo;
  final String bio;

  Profile copyWith({
    String? displayName,
    String? neighborhood,
    String? childInfo,
    String? bio,
  }) {
    return Profile(
      displayName: displayName ?? this.displayName,
      neighborhood: neighborhood ?? this.neighborhood,
      childInfo: childInfo ?? this.childInfo,
      bio: bio ?? this.bio,
    );
  }
}
