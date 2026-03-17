import 'package:flutter/material.dart';
import 'package:mini_ai_assistant/page/chat.page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = {
    '/chat': (context) => ChatPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      home: ChatPage(),
    );
  }
}
