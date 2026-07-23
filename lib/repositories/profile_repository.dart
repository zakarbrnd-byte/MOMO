import '../../models/profile.dart';

/// Profile access for the Profile tab.
abstract class ProfileRepository {
  Future<Profile> load();
}
