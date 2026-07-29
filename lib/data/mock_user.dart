import '../models/child.dart';
import '../models/user.dart';

/// Simulated signed-in user for local MVP.
///
/// Single source of truth — import this (or [currentUserProvider]) only.
/// Later: delete and load identity from authentication.
const currentUserId = 'user_001';

const currentUser = User(
  id: currentUserId,
  displayName: '장하은',
  location: 'Koreatown, Los Angeles',
  children: [
    Child(id: 'child_001', displayName: '첫째', ageLabel: '4'),
  ],
  interestTags: [
    '도서관',
    '놀이터',
    '한인타운',
    '주말',
  ],
);
