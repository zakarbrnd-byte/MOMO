import 'mom_user.dart';

/// Playdate card data — offline meetup details.
class Playdate {
  const Playdate({
    required this.id,
    required this.title,
    required this.startsAt,
    required this.location,
    required this.host,
    this.ageRange,
  });

  final String id;
  final String title;
  final DateTime startsAt;
  final String location;
  final MomUser host;

  /// Optional kid age hint, e.g. "3–5".
  final String? ageRange;
}
