import 'package:flutter/material.dart';
import 'package:mini_project_genuisdk/features/pages/chat.page.dart';
import 'package:mini_project_genuisdk/features/pages/splash.page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
 @override

Widget build(BuildContext context) {
  return const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'ChatBot',
    home: SplashScreen(),
  );
}
}
