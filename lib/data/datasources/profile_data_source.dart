import '../../models/profile.dart';

/// Raw profile access. Mock today; Supabase later.
abstract class ProfileDataSource {
  /// MVP completes synchronously; network sources return real [Future]s.
  Future<Profile> getProfile();
}
