import 'package:flutter/foundation.dart';

import '../../../models/user.dart';
import '../../mock_user.dart';
import '../user_data_source.dart';

/// Serves the simulated signed-in user from [currentUser].
class MockUserDataSource implements UserDataSource {
  MockUserDataSource({User? seed}) : _user = seed ?? currentUser;

  final User _user;

  @override
  Future<User> getCurrentUser() => SynchronousFuture(_user);
}
