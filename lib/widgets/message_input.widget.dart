import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInput({super.key, required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Expanded(
            flex: 20,
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.black, fontSize: 17),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Ask Anything',
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: const CircleAvatar(
              radius: 25,
              backgroundColor: Color.fromRGBO(99, 42, 232, 1),
              child: Icon(Icons.send, color: Colors.white, size: 25),
            ),
          ),
        ],
      ),
    );
  }
}