import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model.dart';

class ChatStore {
  static const String key = 'all_chats';

  static Future<void> saveChats(List<List<MessageModel>> allChats) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = allChats
        .map((chat) => jsonEncode(chat.map((msg) => msg.toJson()).toList()))
        .toList();
    await prefs.setStringList(key, encoded);
  }

  static Future<List<List<MessageModel>>> loadChats() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(key);
    if (stored != null && stored.isNotEmpty) {
      return stored.map((chatString) {
        final decoded = jsonDecode(chatString) as List;
        return decoded.map((msg) => MessageModel.fromJson(msg)).toList();
      }).toList();
    } else {
      return [[]];
    }
  }

  static Future<void> clearChats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
