import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini_ai_assistant/config/global.params.dart';
import 'package:mini_ai_assistant/menu/drawer.widget.dart';

class ChatPage extends StatefulWidget {
  final String? conversationId;
  ChatPage({this.conversationId});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> messages = [];
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late String currentConversationId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentConversationId = widget.conversationId ?? DateTime.now().millisecondsSinceEpoch.toString();
    loadConversation();
  }

  Future<void> loadConversation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? convoData = prefs.getString('conversation_$currentConversationId');
    if (convoData != null) {
      setState(() {
        messages = List<Map<String, dynamic>>.from(json.decode(convoData));
      });
      _scrollToBottom();
    }
  }

  Future<void> saveConversation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('conversation_$currentConversationId', json.encode(messages));
    List<String> allConvos = prefs.getStringList('all_conversations') ?? [];
    if (!allConvos.contains(currentConversationId)) {
      allConvos.add(currentConversationId);
      await prefs.setStringList('all_conversations', allConvos);
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({"role": "user", "content": text});
      textController.clear();
      isLoading = true;
    });

    _scrollToBottom();
    await saveConversation();

    try {
      String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${GlobalParams.geminiApiKey}";

      Map<String, dynamic> body = {
        "contents": [
          {
            "parts": [
              {"text": text}
            ]
          }
        ]
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String aiResponse = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          messages.add({"role": "model", "content": aiResponse});
          isLoading = false;
        });
        _scrollToBottom();
        await saveConversation();
      } else {
        setState(() {
          messages.add({"role": "model", "content": "Erreur de connexion avec l'API Gemini."});
          isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        messages.add({"role": "model", "content": "Erreur: $err"});
        isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mini AI Assistant'),
        backgroundColor: Colors.blue,
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                bool isUser = msg['role'] == 'user';
                return Card(
                  color: isUser ? Colors.blue[100] : Colors.grey[200],
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(
                            isUser ? Icons.person : Icons.smart_toy,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            msg['content'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: "Posez votre question...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSubmitted: sendMessage,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue, size: 30),
                  onPressed: () => sendMessage(textController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
