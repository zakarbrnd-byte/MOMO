import '../core/result/result.dart';
import '../models/playdate.dart';

/// Standard playdate repository API (backend-request flow).
///
/// Convention (all async):
/// - [load] — read list
/// - [create] / [update] / [delete] — write
/// - [join] / [leave] — participation
///
/// Mutations return [Result] so failures propagate without UI knowledge.
/// Success payloads use `true` as a void stand-in.
abstract class PlaydateRepository {
  /// Load all playdates (future: GET /playdates).
  Future<List<Playdate>> load();

  /// Create a playdate (future: POST /playdates).
  Future<Result<bool>> create({
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

  /// Replace or insert by id (future: PATCH /playdates/:id).
  Future<Result<bool>> update(Playdate playdate);

  /// Cancel/delete. Only the creator may delete.
  Future<Result<bool>> delete(String playdateId, String requestingUserId);

  Future<Result<bool>> join(String playdateId, String userId);

  Future<Result<bool>> leave(String playdateId, String userId);
}
