import 'package:flutter/foundation.dart';

import '../../../models/playdate.dart';
import '../../mock_feed.dart';
import '../playdate_data_source.dart';

/// In-memory playdate store seeded from [mockPlaydates].
///
/// Owns mock collections — repositories must not hold seed lists.
class MockPlaydateDataSource implements PlaydateDataSource {
  MockPlaydateDataSource({List<Playdate>? seed})
      : _items = List<Playdate>.from(seed ?? mockPlaydates);

  final List<Playdate> _items;

  @override
  Future<List<Playdate>> getPlaydates() {
    return SynchronousFuture(List<Playdate>.from(_items));
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
    final now = DateTime.now();
    final playdate = Playdate(
      id: 'pd_${now.millisecondsSinceEpoch}',
      creatorId: creatorId,
      title: title.trim(),
      date: date.trim(),
      time: time.trim(),
      location: location.trim(),
      childAge: childAge.trim(),
      description: description.trim(),
      hostName: hostName?.trim().isNotEmpty == true
          ? hostName!.trim()
          : mockProfile.displayName,
      participantIds: const [],
      maxParticipants: maxParticipants,
      createdAt: now,
      updatedAt: now,
    );
    _items.insert(0, playdate);
    return SynchronousFuture(null);
  }

  @override
  Future<void> updatePlaydate(Playdate playdate) {
    final index = _items.indexWhere((item) => item.id == playdate.id);
    if (index >= 0) {
      _items[index] = playdate;
    } else {
      _items.insert(0, playdate);
    }
    return SynchronousFuture(null);
  }

  @override
  Future<bool> deletePlaydate(String playdateId) {
    final before = _items.length;
    _items.removeWhere((item) => item.id == playdateId);
    return SynchronousFuture(_items.length < before);
  }

  @override
  Future<bool> joinPlaydate(String playdateId, String userId) {
    final playdate = _byId(playdateId);
    if (playdate == null) return SynchronousFuture(false);
    if (playdate.hasUserJoined(userId)) return SynchronousFuture(false);

    final now = DateTime.now();
    _replace(
      playdate.copyWith(
        participantIds: [...playdate.participantIds, userId],
        updatedAt: now,
      ),
    );
    return SynchronousFuture(true);
  }

  @override
  Future<bool> leavePlaydate(String playdateId, String userId) {
    final playdate = _byId(playdateId);
    if (playdate == null) return SynchronousFuture(false);
    if (!playdate.hasUserJoined(userId)) return SynchronousFuture(false);

    final now = DateTime.now();
    _replace(
      playdate.copyWith(
        participantIds: [
          for (final id in playdate.participantIds)
            if (id != userId) id,
        ],
        updatedAt: now,
      ),
    );
    return SynchronousFuture(true);
  }

  Playdate? _byId(String id) {
    for (final playdate in _items) {
      if (playdate.id == id) return playdate;
    }
    return null;
  }

  void _replace(Playdate updated) {
    final index = _items.indexWhere((item) => item.id == updated.id);
    if (index >= 0) {
      _items[index] = updated;
    }
  }
}
