import 'package:flutter/material.dart';
import 'package:mini_project_genuisdk/model.dart';
 
class ChatDrawer extends StatelessWidget {
  final List<List<MessageModel>> allChats;
  final int currentChatIndex;
  final Function(int) onSelectChat;
  final VoidCallback onAddChat;
  final Function(int) onDeleteChat;

  const ChatDrawer({
    super.key,
    required this.allChats,
    required this.currentChatIndex,
    required this.onSelectChat,
    required this.onAddChat,
    required this.onDeleteChat,
  });

   String chatTitle(int index) {
    final chatList = allChats[index];
    if (chatList.isEmpty) return "New Chat";
    final firstMsg = chatList[0].message;
    return firstMsg.length > 20 ? firstMsg.substring(0, 20) + "..." : firstMsg;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: const Center(
              child: Text(
                'Chats',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allChats.length,
              itemBuilder: (context, index) => ListTile(
                selected: index == currentChatIndex,
                title: Text(chatTitle(index)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDeleteChat(index),
                ),
                onTap: () => onSelectChat(index),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("New Chat"),
            onTap: onAddChat,
          ),
        ],
      ),
    );
  }
}