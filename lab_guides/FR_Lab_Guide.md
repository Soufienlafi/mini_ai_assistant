# Travaux Pratiques : Créez votre Assistant IA avec Flutter et Gemini

**Langue** : Français (FR)
**Description** : Tutoriel simple pour créer un chatbot IA avec Flutter et l'API Gemini de Google.

---

## Étape 1 : Création du projet et des dépendances

Nous allons créer un nouveau projet Flutter pour notre application.

Ouvrez votre terminal et exécutez ces commandes :

```bash
flutter create mini_project_genuisdk
cd mini_project_genuisdk
```

Explication :
Cette commande crée un dossier avec un projet Flutter de base.

Pour que notre application puisse parler à l'IA Gemini, nous ajoutons des outils externes.

Fichier : `pubspec.yaml`
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_dotenv: ^5.1.0
  google_generative_ai: ^0.4.7
  # ... autres dépendances (intl, shared_preferences, etc.)
```

Explication :
Ici, nous ajoutons le paquet `google_generative_ai` pour pouvoir utiliser l'API Gemini, et d'autres paquets utiles pour le design.

[SCREENSHOT: Terminal affichant le succès de l'installation des paquets]

---

## Étape 2 : Créer le modèle de message

Nous devons définir ce qu'est un "message" dans notre application (est-ce l'utilisateur ou l'IA ? quel est le texte ? à quelle heure ?).

Fichier : `lib/model.dart`
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
  
  // (Méthodes toJson et fromJson ignorées pour la simplicité)
}
```

Explication :
Cette classe stocke les informations pour chaque message envoyé ou reçu. Le champ `isUser` nous permet de savoir qui a écrit le message.

[SCREENSHOT: Structure du modèle de données de message]

---

## Étape 3 : Sauvegarder les conversations

Nous allons utiliser `SharedPreferences` pour sauvegarder l'historique de chat sur le téléphone de l'utilisateur.

Fichier : `lib/store/chat.store.dart`
```dart
import 'package:shared_preferences/shared_preferences.dart';

class ChatStore {
  static const String key = 'all_chats';

  static Future<void> saveChats(List<List<MessageModel>> allChats) async {
    final prefs = await SharedPreferences.getInstance();
    // Le code transforme la liste des messages en texte (JSON) 
    // pour la sauvegarder dans la mémoire du téléphone.
    await prefs.setStringList(key, encoded);
  }
}
```

Explication :
Cette fonction `saveChats` prend notre liste de messages et la sauvegarde en toute sécurité dans la mémoire locale de l'appareil.

[SCREENSHOT: Fichier store créé dans l'explorateur (VS Code)]

---

## Étape 4 : Le champ de saisie (Message Input)

Nous avons besoin d'une barre en bas de l'écran où l'utilisateur peut taper sa question.

Fichier : `lib/widgets/message_input.widget.dart`
```dart
TextField(
  controller: controller, // Gère le texte tapé par l'utilisateur
  decoration: InputDecoration(
    hintText: 'Demandez n\'importe quoi', // Texte affiché par défaut
  ),
),
```

Explication :
Le `TextField` est le composant graphique de Flutter qui permet d'afficher un clavier virtuel et de laisser l'utilisateur saisir du texte. 

[SCREENSHOT: Champ de saisie et bouton d'envoi en bas de l'écran]

---

## Étape 5 : La bulle de message (Message Bubble)

Chaque message doit apparaître dans une jolie "bulle" de couleur pour différencier l'utilisateur de l'IA.

Fichier : `lib/widgets/message_bubble.widget.dart`
```dart
Container(
  decoration: BoxDecoration(
    // Gris pour l'utilisateur, violet pour l'IA
    color: message.isUser ? Colors.grey[300] : Colors.deepPurple,
    borderRadius: BorderRadius.circular(25),
  ),
  child: MarkdownBody(data: message.message), // Affiche le texte
)
```

Explication :
Nous utilisons un `Container` (une boîte) avec des bords arrondis. La couleur change automatiquement selon qui a envoyé le message (`message.isUser`).

[SCREENSHOT: Bulle de message affichée dans le chat]

---

## Étape 6 : Le menu latéral (Drawer)

Pour gérer plusieurs conversations à la fois, nous ajoutons un menu glissant sur le côté (Drawer).

Fichier : `lib/widgets/chat_drawer.dart`
```dart
return Drawer(
  child: Column(
    children: [
      DrawerHeader(child: Text('Chats')),
      Expanded(
        child: ListView.builder(
          itemCount: allChats.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(chatTitle(index)), // Affiche un ancien chat
          ),
        ),
      ),
    ],
  ),
);
```

Explication :
Ici, on ajoute un `Drawer` au `Scaffold` principal. Le `ListView.builder` crée une liste qui s'adapte automatiquement au nombre de conversations sauvegardées.

[SCREENSHOT: Menu Drawer affiché dans l'application avec la liste des chats]

---

## Étape 7 : L'écran principal et l'API Gemini

C'est ici que toute la magie opère. Nous relions notre interface graphique (UI) à l'intelligence artificielle Gemini en ligne.

Fichier : `lib/pages/chat.page.dart`
```dart
// 1. Définir le modèle IA et la clé secrète API
static const apiKey = 'VOTRE_CLÉ_API_ICI';
final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

Future<void> sendMessage() async {
  // 2. Envoyer le texte de l'utilisateur à l'IA Gemini
  final content = [Content.text(messageController.text)];
  final response = await model.generateContent(content);

  // 3. Ajouter la réponse de l'IA à l'affichage de l'écran
  setState(() {
    chat.add(MessageModel(isUser: false, message: response.text));
  });
}
```

Explication :
Nous créons l'objet modèle IA avec notre clé secrète de Google. Ensuite, la fonction `sendMessage` envoie notre question à l'API et affiche la réponse reçue (`response.text`) sur l'écran.

[SCREENSHOT: Écran principal du ChatBot en action avec des messages]

---

## Étape 8 : Démarrage de l'application

Enfin, nous devons indiquer à Flutter d'afficher notre page de ChatBot dès le lancement de l'application.

Fichier : `lib/main.dart`
```dart
void main() {
  runApp(const MaterialApp(
    home: GeminiChatBot(), // L'écran principal de notre application
  ));
}
```

Explication :
La fonction `main()` est le point de départ de toute application Flutter. Elle indique à l'appareil d'afficher immédiatement la page `GeminiChatBot`.

[SCREENSHOT: Application Flutter lancée avec succès sur un émulateur]

---

**Félicitations ! Vous venez de créer votre propre assistant IA avec Flutter.**
