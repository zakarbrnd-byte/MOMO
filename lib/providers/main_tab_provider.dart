import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom-nav index: 0 Home · 1 Create · 2 Profile
final mainTabProvider = StateProvider<int>((ref) => 0);
