import 'package:flutter/material.dart';
import '../screens/root/app_shell.dart';
import '../utils/app_constants.dart';
import 'app_theme.dart';

class DigitalLibraryApp extends StatelessWidget {
  const DigitalLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppShell(),
    );
  }
}