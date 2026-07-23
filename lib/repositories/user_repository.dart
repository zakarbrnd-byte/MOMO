import '../models/user.dart';

/// Current signed-in user (mock today; auth later).
abstract class UserRepository {
  Future<User> getCurrentUser();
}
