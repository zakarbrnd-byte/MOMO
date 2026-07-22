import '../models/playdate.dart';

/// Contract for playdate access used by providers.
///
/// Persistence is provided by a [PlaydateDataSource] (mock today, Supabase later).
/// Implementations: [PlaydateRepositoryImpl].
abstract class PlaydateRepository {
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

  /// Replaces by id, or inserts at the front when the id is new.
  Future<void> updatePlaydate(Playdate playdate);

  /// Cancels/deletes a playdate. Only the creator may delete.
  Future<bool> deletePlaydate(String playdateId, String requestingUserId);

  Future<bool> joinPlaydate(String playdateId, String userId);

  Future<bool> leavePlaydate(String playdateId, String userId);
}
