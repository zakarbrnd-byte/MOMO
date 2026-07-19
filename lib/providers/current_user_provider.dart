import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_user.dart';
import '../models/user.dart';

/// Single source for the active user.
///
/// Today: returns [currentUser] from mock data.
/// Later: replace body with auth session / repository lookup.
final currentUserProvider = Provider<User>((ref) => currentUser);
