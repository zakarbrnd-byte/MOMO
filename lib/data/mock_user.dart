import '../models/child.dart';
import '../models/user.dart';

/// Simulated signed-in user for local MVP.
///
/// Single source of truth — import this (or [currentUserProvider]) only.
/// Later: delete and load identity from authentication.
const currentUserId = 'user_001';

const currentUser = User(
  id: currentUserId,
  displayName: 'Demo User',
  location: 'Songpa-gu, Seoul',
  children: [
    Child(id: 'child_001', displayName: 'Daughter', ageLabel: '4'),
  ],
);
