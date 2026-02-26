import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/chat_bubble.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  const ChatScreen({super.key, required this.name});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = [
    Message(
      senderId: "1",
      type: MessageType.text,
      content: "Hello!",
      time: DateTime.now(),
    ),
  ];

  final TextEditingController _controller = TextEditingController();

  // 🔹 Pick an image file from the device
  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      String path = result.files.single.path!;
      setState(() {
        messages.add(Message(
          senderId: "1",
          type: MessageType.image,
          content: path,
          time: DateTime.now(),
        ));
      });
    }
  }

  // 🔹 Send a text message
  void sendMessage() {
    String text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add(Message(
          senderId: "1",
          type: MessageType.text,
          content: text,
          time: DateTime.now(),
        ));
        _controller.clear();
      });
    }
  }

  // 🔹 Build a message widget
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
              Text("Voice message (mock)"),
            ],
          ),
        );

      case MessageType.image:
        // Check if local file or network
        if (msg.content.startsWith("assets/") || File(msg.content).existsSync()) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(File(msg.content), width: 200),
          );
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(msg.content, width: 200),
          );
        }
    }
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
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
          // 🔹 Input area
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: "Type a message"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    // Add mock audio message
                    setState(() {
                      messages.add(Message(
                        senderId: "1",
                        type: MessageType.audio,
                        content: "audio_local_mock",
                        time: DateTime.now(),
                      ));
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
