import 'package:flutter/foundation.dart';

import '../../../models/profile.dart';
import '../profile_data_source.dart';

/// Seed profile previously exposed as `mockProfile` in mock_feed.
const seedProfile = Profile(
  displayName: 'Jiwoo Mom',
  neighborhood: 'Songpa-gu, Seoul',
  childInfo: 'Daughter, age 4',
  bio:
      'Looking for friendly playdates nearby. Love parks, libraries, and quiet café mornings.',
);

class MockProfileDataSource implements ProfileDataSource {
  MockProfileDataSource({Profile? seed}) : _profile = seed ?? seedProfile;

  final Profile _profile;

  @override
  Future<Profile> getProfile() => SynchronousFuture(_profile);
}
