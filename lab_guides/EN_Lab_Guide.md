# Practical Lab: Build Your AI Assistant with Flutter and Gemini

**Language**: English (EN)
**Description**: Simple step-by-step tutorial to create an AI chatbot with Flutter and Google's Gemini API.

---

## Step 1: Project Creation and Dependencies

We will create a new Flutter project for our application.

Open your terminal and run these commands:

```bash
flutter create mini_project_genuisdk
cd mini_project_genuisdk
```

Explanation:
This command creates a folder containing a basic Flutter project.

For our application to talk to the Gemini AI, we need to add external tools.

File: `pubspec.yaml`
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_dotenv: ^5.1.0
  google_generative_ai: ^0.4.7
  # ... other dependencies (intl, shared_preferences, etc.)
```

Explanation:
Here, we add the `google_generative_ai` package to use the Gemini API, alongside other packages useful for design.

[SCREENSHOT: Terminal showing successful installation of packages]

---

## Step 2: Create the Message Model

We need to define what a "message" is in our application (is it the user or the AI? what is the text? what time?).

File: `lib/model.dart`
```dart
class MessageModel {
  final bool isUser;
  final String message;
  final DateTime time;

  MessageModel({
    required this.isUser,
    required this.message,
    required this.time,
  });
  
  // (toJson and fromJson methods are ignored for simplicity)
}
```

Explanation:
This class stores the information for every message sent or received. The `isUser` field lets us know who wrote the message.

[SCREENSHOT: Data model structure of a message]

---

## Step 3: Save Conversations

We will use `SharedPreferences` to save the chat history on the user's phone.

File: `lib/store/chat.store.dart`
```dart
import 'package:shared_preferences/shared_preferences.dart';

class ChatStore {
  static const String key = 'all_chats';

  static Future<void> saveChats(List<List<MessageModel>> allChats) async {
    final prefs = await SharedPreferences.getInstance();
    // The code transforms the message list into text (JSON) 
    // to save it in the phone's memory.
    await prefs.setStringList(key, encoded);
  }
}
```

Explanation:
This `saveChats` function takes our list of messages and securely saves it into the local memory of the device.

[SCREENSHOT: Store file created in the explorer (VS Code)]

---

## Step 4: The Message Input

We need a bar at the bottom of the screen where the user can type their question.

File: `lib/widgets/message_input.widget.dart`
```dart
TextField(
  controller: controller, // Manages the text typed by the user
  decoration: InputDecoration(
    hintText: 'Ask Anything', // Text displayed by default
  ),
),
```

Explanation:
The `TextField` is the graphical Flutter component that allows the display of a virtual keyboard and lets the user type text.

[SCREENSHOT: Input field and send button at the bottom of the screen]

---

## Step 5: The Message Bubble

Every message should appear in a nice colored "bubble" to differentiate the user from the AI.

File: `lib/widgets/message_bubble.widget.dart`
```dart
Container(
  decoration: BoxDecoration(
    // Grey for the user, purple for the AI
    color: message.isUser ? Colors.grey[300] : Colors.deepPurple,
    borderRadius: BorderRadius.circular(25),
  ),
  child: MarkdownBody(data: message.message), // Displays the text
)
```

Explanation:
We use a `Container` (a box) with rounded borders. The color automatically changes depending on who sent the message (`message.isUser`).

[SCREENSHOT: Message bubble displayed in the chat]

---

## Step 6: The Sidebar Menu (Drawer)

To manage multiple conversations at once, we add a sliding menu on the side (Drawer).

File: `lib/widgets/chat_drawer.dart`
```dart
return Drawer(
  child: Column(
    children: [
      DrawerHeader(child: Text('Chats')),
      Expanded(
        child: ListView.builder(
          itemCount: allChats.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(chatTitle(index)), // Displays an old chat
          ),
        ),
      ),
    ],
  ),
);
```

Explanation:
Here, we add a `Drawer` to the main `Scaffold`. The `ListView.builder` creates a list that automatically adapts to the number of saved conversations.

[SCREENSHOT: Drawer menu displayed in the application with the chat list]

---

## Step 7: The Main Screen and Gemini API

This is where all the magic happens. We connect our graphical interface (UI) to the online Gemini artificial intelligence.

File: `lib/pages/chat.page.dart`
```dart
// 1. Define the AI model and the secret API key
static const apiKey = 'YOUR_API_KEY_HERE';
final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

Future<void> sendMessage() async {
  // 2. Send the user's text to the Gemini AI
  final content = [Content.text(messageController.text)];
  final response = await model.generateContent(content);

  // 3. Add the AI's response to the screen display
  setState(() {
    chat.add(MessageModel(isUser: false, message: response.text));
  });
}
```

Explanation:
We create the AI model object with our secret key from Google. Then, the `sendMessage` function sends our question to the API and displays the received answer (`response.text`) on the screen.

[SCREENSHOT: Main screen of the ChatBot in action with messages]

---

## Step 8: Starting the Application

Finally, we must tell Flutter to display our ChatBot page right when the app launches.

File: `lib/main.dart`
```dart
void main() {
  runApp(const MaterialApp(
    home: GeminiChatBot(), // The main screen of our application
  ));
}
```

Explanation:
The `main()` function is the starting point of any Flutter application. It tells the device to immediately display the `GeminiChatBot` page.

[SCREENSHOT: Flutter application successfully launched on an emulator]

---

**Congratulations! You have just created your own AI assistant with Flutter.**
