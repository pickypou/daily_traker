import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/daily_task/presentation/pages/daily_task_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Tracker',
      builder: (context, child) {
        return Theme(data: AppTheme().theme(context), child: child!);
      },
      home: const DailyTaskHomePage(),
    );
  }
}
