import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mini_project_genuisdk/pages/splash.page.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatBot',
      home: SplashScreen(),
    );
  }
}
