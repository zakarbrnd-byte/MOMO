import '../../models/playdate.dart';

/// Raw playdate persistence. No UI / provider knowledge.
///
/// Implementations: [MockPlaydateDataSource] today,
/// future `SupabasePlaydateDataSource` later — repositories stay stable.
abstract class PlaydateDataSource {
  Future<List<Playdate>> getPlaydates();

  Future<void> createPlaydate({
    required String title,
    required String date,
    required String time,
    required String location,
    required String childAge,
    required String description,
    required String creatorId,
    String? hostName,
    int? maxParticipants,
  });

  /// Insert or replace by id (raw upsert).
  Future<void> updatePlaydate(Playdate playdate);

  /// Removes by id with no ownership check (repository enforces rules).
  Future<bool> deletePlaydate(String playdateId);

  /// Appends [userId] when the playdate exists (repository enforces rules).
  Future<bool> joinPlaydate(String playdateId, String userId);

  /// Removes [userId] when present (repository enforces rules).
  Future<bool> leavePlaydate(String playdateId, String userId);
}
