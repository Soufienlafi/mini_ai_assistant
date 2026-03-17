import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini_ai_assistant/page/chat.page.dart';

class MyDrawer extends StatefulWidget {
  @override
  MyDrawerState createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> {
  List<String> allConvos = [];

  @override
  void initState() {
    super.initState();
    loadConvos();
  }

  Future<void> loadConvos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      allConvos = prefs.getStringList('all_conversations') ?? [];
      allConvos.sort((a, b) => int.parse(b).compareTo(int.parse(a)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue, Colors.white],
              ),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 80, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.chat, color: Colors.blue),
            title: Text(
              'Nouvelle Discussion',
              style: TextStyle(fontSize: 22),
            ),
            trailing: Icon(Icons.arrow_right, color: Colors.blue),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            },
          ),
          Divider(height: 4, color: Colors.blue),
          ...allConvos.map((convoId) {
            DateTime dt = DateTime.fromMillisecondsSinceEpoch(int.parse(convoId));
            String dateStr = "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
            return Column(
              children: [
                ListTile(
                  leading: Icon(Icons.history, color: Colors.blue),
                  title: Text(
                    'Chat $dateStr',
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Icon(Icons.arrow_right, color: Colors.blue),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(conversationId: convoId),
                      ),
                    );
                  },
                ),
                Divider(height: 4, color: Colors.blue),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
