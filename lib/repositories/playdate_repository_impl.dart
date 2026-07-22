import 'package:flutter/foundation.dart';

import '../data/datasources/playdate_data_source.dart';
import '../dto/playdate_dto.dart';
import '../models/playdate.dart';
import 'playdate_repository.dart';

/// Playdate access with business rules; persistence via [PlaydateDataSource].
///
/// Providers depend on [PlaydateRepository] only — never on a data source.
class PlaydateRepositoryImpl implements PlaydateRepository {
  PlaydateRepositoryImpl(this._dataSource);

  final PlaydateDataSource _dataSource;

  @override
  Future<List<Playdate>> getPlaydates() {
    return _dataSource.getPlaydates().then((items) {
      return [
        for (final item in items) PlaydateDto.fromDomain(item).toDomain(),
      ];
    });
  }

  @override
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
  }) {
    return _dataSource.createPlaydate(
      title: title,
      date: date,
      time: time,
      location: location,
      childAge: childAge,
      description: description,
      creatorId: creatorId,
      hostName: hostName,
      maxParticipants: maxParticipants,
    );
  }

  @override
  Future<void> updatePlaydate(Playdate playdate) {
    return _dataSource.updatePlaydate(playdate);
  }

  @override
  Future<bool> deletePlaydate(String playdateId, String requestingUserId) {
    return _findById(playdateId).then((playdate) {
      if (playdate == null || !playdate.isOwner(requestingUserId)) {
        return SynchronousFuture(false);
      }
      return _dataSource.deletePlaydate(playdateId);
    });
  }

  @override
  Future<bool> joinPlaydate(String playdateId, String userId) {
    return _findById(playdateId).then((playdate) {
      if (playdate == null ||
          playdate.isOwner(userId) ||
          playdate.hasUserJoined(userId) ||
          playdate.isFull) {
        return SynchronousFuture(false);
      }
      return _dataSource.joinPlaydate(playdateId, userId);
    });
  }

  @override
  Future<bool> leavePlaydate(String playdateId, String userId) {
    return _findById(playdateId).then((playdate) {
      if (playdate == null ||
          playdate.isOwner(userId) ||
          !playdate.hasUserJoined(userId)) {
        return SynchronousFuture(false);
      }
      return _dataSource.leavePlaydate(playdateId, userId);
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
