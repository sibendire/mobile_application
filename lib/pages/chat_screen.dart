import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../models/message.dart';

class ChatScreen extends StatelessWidget {
  final String name;

  ChatScreen({super.key, required this.name});

  // 🔹 TEMP DATA (later comes from backend)
  final List<Message> messages = [
    Message(
      senderId: "1",
      type: MessageType.text,
      content: "Hello!",
      time: DateTime.now(),
    ),
    Message(
      senderId: "2",
      type: MessageType.audio,
      content: "audio_url_here",
      time: DateTime.now(),
    ),
    Message(
      senderId: "1",
      type: MessageType.image,
      content: "https://via.placeholder.com/200",
      time: DateTime.now(),
    ),
  ];

  // 🔹 Message renderer (IMO-style logic)
  Widget buildMessage(Message msg) {
    switch (msg.type) {
      case MessageType.text:
        return ChatBubble(text: msg.content);

      case MessageType.audio:
        return Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: const [
              Icon(Icons.play_arrow),
              SizedBox(width: 8),
              Text("Voice message"),
            ],
          ),
        );

      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(msg.content, width: 200),
        );
    }
  }

  // 🔹 REQUIRED build() method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: messages[index].senderId == "1"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: buildMessage(messages[index]),
                );
              },
            ),
          ),

          // 🔹 Input area (IMO-style)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    decoration:
                        const InputDecoration(hintText: "Type a message"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
