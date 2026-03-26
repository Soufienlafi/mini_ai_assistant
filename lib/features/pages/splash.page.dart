import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mini_project_genuisdk/features/pages/chat.page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _iconOpacity = 0.0;
  double _textOpacity = 0.0;
  double _iconScale = 0.5;

  @override
  void initState() {
    super.initState();

    // Animate the icon
    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _iconOpacity = 1.0;
        _iconScale = 1.0;
      });
    });

    // Animate the text slightly after icon
    Timer(const Duration(milliseconds: 800), () {
      setState(() {
        _textOpacity = 1.0;
      });
    });

    // Navigate to chatbot after 2 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GeminiChatBot()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _iconOpacity,
              duration: const Duration(milliseconds: 500),
              child: AnimatedScale(
                scale: _iconScale,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutBack,
                child: const Icon(Icons.chat, size: 80, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _textOpacity,
              duration: const Duration(milliseconds: 500),
              child: const Text(
                "Welcome Lexa",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}