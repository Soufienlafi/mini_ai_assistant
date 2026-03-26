import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quickalert/flutter_quickalert.dart';
import '../models/model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15)
          .copyWith(left: message.isUser ? 15 : 80, right: message.isUser ? 80 : 15),
      decoration: BoxDecoration(
        color: message.isUser
            ? const Color.fromRGBO(224, 224, 224, 1)
            : const Color.fromRGBO(99, 42, 232, 1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: message.isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: message.isUser ? Colors.black : Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'AI is typing...',
                  style: TextStyle(
                    color: message.isUser ? Colors.black : Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarkdownBody(
                  data: message.message,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      color: message.isUser
                          ? const Color.fromRGBO(99, 42, 232, 1)
                          : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: message.message));
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertTypes.success,
                          message: 'Message copied to clipboard.',
                        );
                      },
                      child: Icon(
                        Icons.copy,
                        size: 18,
                        color: message.isUser
                            ? const Color.fromRGBO(99, 42, 232, 1)
                            : Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat('hh:mm a').format(message.time),
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}