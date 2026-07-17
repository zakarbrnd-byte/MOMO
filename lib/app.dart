import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'navigation/main_shell.dart';

class MomoApp extends StatelessWidget {
  const MomoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOMO',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MainShell(),
    );
  }
}
