import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mini_project_genuisdk/features/widgets/message_bubble.widget.dart';
import '../models/model.dart';
import '../../services/chat.service.dart';
import '../widgets/chat_drawer.dart';
 import '../widgets/message_input.widget.dart';

class GeminiChatBot extends StatefulWidget {
  const GeminiChatBot({super.key});

  @override
  State<GeminiChatBot> createState() => _GeminiChatBotState();
}

class _GeminiChatBotState extends State<GeminiChatBot> {
  static const apiKey = 'AIzaSyA4QMyuOwODIokz4SiTKYQ640IQkjLi5Ug';
  final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
  List<List<MessageModel>> allChats = [[]];
  TextEditingController messageController = TextEditingController();
  int currentChatIndex = 0;

  List<MessageModel> get chat => allChats[currentChatIndex];

  @override
  void initState() {
    super.initState();
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
    return firstMsg.length > 20 ? firstMsg.substring(0, 20) + "..." : firstMsg;
  }

  String chatTitle(int index) {
    final chatList = allChats[index];
    if (chatList.isEmpty) return "New Chat";
    final firstMsg = chatList[0].message;
    return firstMsg.length > 20 ? firstMsg.substring(0, 20) + "..." : firstMsg;
  }

  Future<void> sendMessage() async {
    final messageText = messageController.text;
    if (messageText.trim().isEmpty) return;

    setState(() {
      chat.add(MessageModel(
        isUser: true,
        message: messageText,
        time: DateTime.now(),
      ));

      chat.add(MessageModel(
        isUser: false,
        message: '',
        time: DateTime.now(),
        isLoading: true,
      ));

      messageController.clear();
    });

    final content = [Content.text(messageText)];
    final response = await model.generateContent(content);

    setState(() {
      final loadingIndex = chat.indexWhere((m) => m.isLoading);
      if (loadingIndex != -1) {
        chat[loadingIndex] = MessageModel(
          isUser: false,
          message: response.text ?? '',
          time: DateTime.now(),
        );
      }
    });

    await ChatStore.saveChats(allChats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
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
          WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pop(context));
        },
        onDeleteChat: (index) async {
          setState(() {
            allChats.removeAt(index);
            if (currentChatIndex >= allChats.length) currentChatIndex = allChats.length - 1;
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
              itemBuilder: (context, index) => MessageBubble(message: chat[index]),
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
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}