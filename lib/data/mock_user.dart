import '../models/user.dart';

/// Simulated signed-in user for local MVP.
///
/// Single source of truth — import this (or [currentUserProvider]) only.
/// Later: delete and load identity from authentication.
const currentUserId = 'user_001';

const currentUser = User(
  id: currentUserId,
  name: 'Demo User',
);
