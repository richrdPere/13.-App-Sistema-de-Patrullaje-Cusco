import 'package:flutter/material.dart';

void main() {
  runApp(const ChatsScreen());
}

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat de Patrullaje"),
      ),
      body: const ChatList(),
    );
  }
}

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  final List<Map<String, dynamic>> chats = const [
    {
      "name": "Patrullero Juan",
      "lastMessage": "Todo en orden por aquí",
      "avatar": "https://i.pravatar.cc/150?img=1"
    },
    {
      "name": "Patrullero Luis",
      "lastMessage": "Revisando la zona central",
      "avatar": "https://i.pravatar.cc/150?img=2"
    },
    {
      "name": "Operador Central",
      "lastMessage": "Recibido, mantente alerta",
      "avatar": "https://i.pravatar.cc/150?img=3"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(chat['avatar']),
          ),
          title: Text(chat['name'],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(chat['lastMessage']),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChatDetailScreen(chat['name'], chat['avatar']),
              ),
            );
          },
        );
      },
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String avatar;

  const ChatDetailScreen(this.name, this.avatar, {super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [
    {"sender": "other", "text": "Hola, ¿cómo va el patrullaje?"},
    {"sender": "me", "text": "Todo en orden, sin novedades."},
    {"sender": "other", "text": "Mantente alerta, cualquier cosa avísanos."},
  ];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({"sender": "me", "text": _controller.text});
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.avatar)),
            const SizedBox(width: 10),
            Text(widget.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['sender'] == "me";
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message['text']!,
                        style: TextStyle(
                            color: isMe ? Colors.white : Colors.black)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                        hintText: "Escribe un mensaje..."),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
