import '../core/result/result.dart';
import '../models/group.dart';

/// Standard group repository API (backend-request flow).
///
/// Convention: [load] / [getById] / [loadMembers] / [loadEvents] /
/// [loadRsvps] — reads; mutations return [Result] (`true` on success).
abstract class GroupRepository {
  /// Load all groups (future: GET /groups).
  Future<List<Group>> load();

  Future<Group?> getById(String id);

  Future<List<GroupMember>> loadMembers(String groupId);

  Future<Result<bool>> join({
    required String groupId,
    required String userId,
    required String userName,
  });

  Future<Result<bool>> leave({
    required String groupId,
    required String userId,
  });

  Future<List<EventAnnouncement>> loadEvents(String groupId);

  Future<EventAnnouncement?> getEventById(String id);

  Future<List<Rsvp>> loadRsvps(String eventId);

  Future<Result<bool>> setRsvp(Rsvp rsvp);

  Future<Result<bool>> createGroup({
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

  Future<Result<bool>> createEvent({
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
