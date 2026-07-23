import '../../models/user.dart';

/// Raw current-user access. Mock today; auth session later.
abstract class UserDataSource {
  Future<User> getCurrentUser();
}
