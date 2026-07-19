import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_feed.dart';
import '../models/playdate.dart';

/// In-memory playdate list. Seeded from mock data; ready to swap for a repository later.
class PlaydateNotifier extends Notifier<List<Playdate>> {
  @override
  List<Playdate> build() => List<Playdate>.from(mockPlaydates);

  List<Playdate> get playdates => state;

  void addPlaydate(Playdate playdate) {
    state = [playdate, ...state];
  }

  /// Builds a playdate from form fields and prepends it to local state.
  void createPlaydate({
    required String title,
    required String date,
    required String time,
    required String location,
    required String childAge,
    required String description,
    String? hostName,
  }) {
    addPlaydate(
      Playdate(
        id: 'pd_${DateTime.now().millisecondsSinceEpoch}',
        title: title.trim(),
        date: date.trim(),
        time: time.trim(),
        location: location.trim(),
        childAge: childAge.trim(),
        description: description.trim(),
        hostName: hostName?.trim().isNotEmpty == true
            ? hostName!.trim()
            : mockProfile.displayName,
      ),
    );
  }

  void updatePlaydate(Playdate playdate) {
    state = [
      for (final item in state)
        if (item.id == playdate.id) playdate else item,
    ];
  }
}

final playdateProvider =
    NotifierProvider<PlaydateNotifier, List<Playdate>>(PlaydateNotifier.new);
