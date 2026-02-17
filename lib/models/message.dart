enum MessageType { text, audio, image }

class Message {
  final String senderId;
  final MessageType type;
  final String content; // text OR file URL
  final DateTime time;

  Message({
    required this.senderId,
    required this.type,
    required this.content,
    required this.time,
  });
}
