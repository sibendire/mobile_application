import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/chat_bubble.dart';
import '../models/message.dart';
import 'call_page.dart';

class ChatScreen extends StatefulWidget {
  final String name;

  const ChatScreen({super.key, required this.name});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = [];

  final TextEditingController _controller = TextEditingController();

  final AudioRecorder _recorder = AudioRecorder();
  bool isRecording = false;
  String? audioPath;

  // 🔹 Pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() {
        messages.add(Message(
          senderId: "1",
          type: MessageType.image,
          content: result.files.single.path!,
          time: DateTime.now(),
        ));
      });
    }
  }

  // 🔹 Send text
  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      messages.add(Message(
        senderId: "1",
        type: MessageType.text,
        content: _controller.text.trim(),
        time: DateTime.now(),
      ));
      _controller.clear();
    });
  }

  // 🎙️ Record audio
  Future<void> handleRecording() async {
    if (!isRecording) {
      if (await _recorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        audioPath =
            '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _recorder.start(
          const RecordConfig(),
          path: audioPath!,
        );

        setState(() => isRecording = true);
      }
    } else {
      final path = await _recorder.stop();

      setState(() {
        isRecording = false;

        if (path != null) {
          messages.add(Message(
            senderId: "1",
            type: MessageType.audio,
            content: path,
            time: DateTime.now(),
          ));
        }
      });
    }
  }

  // 🔹 Message UI
  Widget buildMessage(Message msg) {
    switch (msg.type) {
      case MessageType.text:
        return ChatBubble(text: msg.content);

      case MessageType.image:
        return Image.file(File(msg.content), width: 200);

      case MessageType.audio:
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_arrow),
              SizedBox(width: 8),
              Text("Voice message"),
            ],
          ),
        );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          // 📞 Call button
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CallPage(channelId: "test123"),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (_, i) => buildMessage(messages[i]),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: pickImage,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(hintText: "Type message"),
                ),
              ),
              IconButton(
                icon: Icon(isRecording ? Icons.stop : Icons.mic),
                onPressed: handleRecording,
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendMessage,
              ),
            ],
          )
        ],
      ),
    );
  }
}