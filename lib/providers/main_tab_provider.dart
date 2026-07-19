import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../navigation/app_navigation.dart';

/// Bottom-nav index: [MainTabs.home] · [MainTabs.create] · [MainTabs.profile]
final mainTabProvider = StateProvider<int>((ref) => MainTabs.home);
