import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ChatListPage extends StatelessWidget {
  ChatListPage({super.key}); // ❌ Remove const

  final List<Map<String, String>> chats = [
    {"name": "Alice", "last": "Hello 👋", "time": "12:30"},
    {"name": "Bob", "last": "Voice message", "time": "11:10"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: Stack(
              children: [
                const CircleAvatar(radius: 24, child: Icon(Icons.person)),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(chat["name"]!),
            subtitle: Text(chat["last"]!),
            trailing: Text(chat["time"]!, style: const TextStyle(fontSize: 12)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(name: chat["name"]!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
