import '../../models/group.dart';

/// Raw group / membership / event / RSVP persistence.
///
/// Implementations: [MockGroupDataSource] today,
/// future `SupabaseGroupDataSource` later — repositories stay stable.
abstract class GroupDataSource {
  Future<List<Group>> getGroups();

  Future<Group?> getGroupById(String id);

  Future<List<GroupMember>> getGroupMembers(String groupId);

  /// Group ids the user belongs to (single membership-store query).
  Future<Set<String>> getJoinedGroupIds(String userId);

  Future<void> joinGroup({
    required String groupId,
    required String userId,
    required String userName,
  });

  Future<void> leaveGroup({required String groupId, required String userId});

  Future<List<EventAnnouncement>> getEventsByGroup(String groupId);

  Future<EventAnnouncement?> getEventById(String id);

  Future<List<Rsvp>> getRsvpsByEvent(String eventId);

  Future<void> setRsvp(Rsvp rsvp);

  Future<void> createGroup({
    required String name,
    required String description,
    required String category,
    required String location,
    required String ownerId,
    required String ownerName,
    List<String> childAgeRanges = const [],
    List<String> interestTags = const [],
    String? coverEmoji,
    bool isFeatured = false,
  });

  Future<void> createEvent({
    required String groupId,
    required String creatorId,
    required String creatorName,
    required String title,
    required String description,
    required DateTime dateTime,
    required String location,
    String childAgeRange = '',
    int? participantLimit,
  });
}
