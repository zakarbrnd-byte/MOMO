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

  void updatePlaydate(Playdate playdate) {
    state = [
      for (final item in state)
        if (item.id == playdate.id) playdate else item,
    ];
  }
}

final playdateProvider =
    NotifierProvider<PlaydateNotifier, List<Playdate>>(PlaydateNotifier.new);
