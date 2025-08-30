import 'package:flutter/material.dart';
import 'package:social_app_fe/config/theme/app_theme.dart';
import 'package:social_app_fe/core/di/injection.dart';

Future<void> main() async {
  await initializeDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Namer App', theme: theme(), home: Container());
  }
}
