import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mini_project_genuisdk/model.dart';
import 'package:mini_project_genuisdk/store/chat.store.dart';
import 'package:mini_project_genuisdk/widgets/chat_drawer.dart';
import 'package:mini_project_genuisdk/widgets/message_bubble.widget.dart';
import 'package:mini_project_genuisdk/widgets/message_input.widget.dart';

class GeminiChatBot extends StatefulWidget {
  const GeminiChatBot({super.key});

  @override
  State<GeminiChatBot> createState() => _GeminiChatBotState();
}

class _GeminiChatBotState extends State<GeminiChatBot> {
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  late final GenerativeModel model;

  List<List<MessageModel>> allChats = [[]];
  TextEditingController messageController = TextEditingController();
  int currentChatIndex = 0;
  List<MessageModel> get chat => allChats[currentChatIndex];

  @override
  void initState() {
    super.initState();

    model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
    loadChats();
  }

  Future<void> loadChats() async {
    allChats = await ChatStore.loadChats();
    if (allChats.isEmpty) allChats = [[]];
    setState(() {});
  }

  String currentChatTitle() {
    final current = chat;
    if (current.isEmpty) return "New Chat";
    final firstMsg = current[0].message;
    return firstMsg.length > 20 ? '${firstMsg.substring(0, 20)}...' : firstMsg;
  }

  String chatTitle(int index) {
    final chatList = allChats[index];
    if (chatList.isEmpty) return "New Chat";
    final firstMsg = chatList[0].message;
    return firstMsg.length > 20 ? '${firstMsg.substring(0, 20)}...' : firstMsg;
  }

  Future<void> sendMessage() async {
    final message = messageController.text;

    setState(() {
      messageController.clear();
      chat.add(
        MessageModel(isUser: true, message: message, time: DateTime.now()),
      );
    });

    final content = [Content.text(message)];

    try {
      final response = await model.generateContent(content);

      setState(() {
        chat.add(
          MessageModel(
            isUser: false,
            message: response.text ?? 'Sorry, no response.',
            time: DateTime.now(),
          ),
        );
      });
    } catch (e) {
      setState(() {
        chat.add(
          MessageModel(
            isUser: false,
            message: 'Error: Failed to generate response.',
            time: DateTime.now(),
          ),
        );
      });
      print("Error: $e");
    }
    await ChatStore.saveChats(allChats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 237, 237),
      drawer: ChatDrawer(
        allChats: allChats,
        currentChatIndex: currentChatIndex,
        onSelectChat: (index) {
          setState(() => currentChatIndex = index);
          Navigator.pop(context);
        },
        onAddChat: () async {
          setState(() {
            allChats.add([]);
            currentChatIndex = allChats.length - 1;
          });

          await ChatStore.saveChats(allChats);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
        },
        onDeleteChat: (index) async {
          setState(() {
            allChats.removeAt(index);
            if (allChats.isEmpty) {
              allChats = [[]];
              currentChatIndex = 0;
            } else {
              if (index < currentChatIndex) {
                currentChatIndex--;
              } else if (currentChatIndex >= allChats.length) {
                currentChatIndex = allChats.length - 1;
              }
            }
          });
          await ChatStore.saveChats(allChats);
        },
      ),
      appBar: AppBar(
        elevation: 3,
        backgroundColor: const Color.fromARGB(255, 237, 237, 237),
        title: Text(currentChatTitle()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chat.length,
              itemBuilder: (context, index) =>
                  MessageBubble(message: chat[index]),
            ),
          ),
          MessageInput(controller: messageController, onSend: sendMessage),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: () async {
            setState(() {
              allChats.add([]);
              currentChatIndex = allChats.length - 1;
            });
            await ChatStore.saveChats(allChats);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
