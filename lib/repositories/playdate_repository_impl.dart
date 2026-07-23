import 'package:flutter/foundation.dart';

import '../core/result/result.dart';
import '../data/datasources/playdate_data_source.dart';
import '../dto/playdate_dto.dart';
import '../models/playdate.dart';
import 'playdate_repository.dart';

/// Playdate access with business rules; persistence via [PlaydateDataSource].
///
/// Mapping: data source domain objects → [PlaydateDto] round-trip → domain.
/// Future: JSON → DTO → domain inside / beside the data source.
class PlaydateRepositoryImpl implements PlaydateRepository {
  PlaydateRepositoryImpl(this._dataSource);

  final PlaydateDataSource _dataSource;

  @override
  Future<List<Playdate>> load() {
    return _dataSource.getPlaydates().then((items) {
      return [
        for (final item in items) PlaydateDto.fromDomain(item).toDomain(),
      ];
    });
  }

  @override
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
  }) {
    return _dataSource
        .createPlaydate(
          title: title,
          date: date,
          time: time,
          location: location,
          childAge: childAge,
          description: description,
          creatorId: creatorId,
          hostName: hostName,
          maxParticipants: maxParticipants,
        )
        .then((_) => const Success(true));
  }

  @override
  Future<Result<bool>> update(Playdate playdate) {
    return _dataSource
        .updatePlaydate(playdate)
        .then((_) => const Success(true));
  }

  @override
  Future<Result<bool>> delete(String playdateId, String requestingUserId) {
    return _findById(playdateId).then((playdate) {
      if (playdate == null) {
        return SynchronousFuture(
          const Failure('Playdate not found.'),
        );
      }
      if (!playdate.isOwner(requestingUserId)) {
        return SynchronousFuture(
          const Failure('Only the creator can cancel this playdate.'),
        );
      }
      return _dataSource.deletePlaydate(playdateId).then((ok) {
        return ok
            ? const Success(true)
            : const Failure('Could not cancel playdate.');
      });
    });
  }

  @override
  Future<Result<bool>> join(String playdateId, String userId) {
    return _findById(playdateId).then((playdate) {
      if (playdate == null) {
        return SynchronousFuture(
          const Failure('Playdate not found.'),
        );
      }
      if (playdate.isOwner(userId)) {
        return SynchronousFuture(
          const Failure('Owners cannot join their own playdate.'),
        );
      }
      if (playdate.hasUserJoined(userId)) {
        return SynchronousFuture(
          const Failure('You already joined this playdate.'),
        );
      }
      if (playdate.isFull) {
        return SynchronousFuture(
          const Failure('This playdate is full.'),
        );
      }
      return _dataSource.joinPlaydate(playdateId, userId).then((ok) {
        return ok
            ? const Success(true)
            : const Failure('Could not join playdate.');
      });
    });
  }

  @override
  Future<Result<bool>> leave(String playdateId, String userId) {
    return _findById(playdateId).then((playdate) {
      if (playdate == null) {
        return SynchronousFuture(
          const Failure('Playdate not found.'),
        );
      }
      if (playdate.isOwner(userId)) {
        return SynchronousFuture(
          const Failure('Owners cannot leave as a participant.'),
        );
      }
      if (!playdate.hasUserJoined(userId)) {
        return SynchronousFuture(
          const Failure('You are not in this playdate.'),
        );
      }
      return _dataSource.leavePlaydate(playdateId, userId).then((ok) {
        return ok
            ? const Success(true)
            : const Failure('Could not leave playdate.');
      });
    });
  }

  Future<Playdate?> _findById(String id) {
    return _dataSource.getPlaydates().then((items) {
      for (final playdate in items) {
        if (playdate.id == id) return playdate;
      }
      return null;
    });
  }
}
