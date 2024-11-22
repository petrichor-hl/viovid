enum MessageType { image, text }

class Message {
  dynamic content; // String or Uint8List
  bool isUserMessage;
  MessageType type;

  Message({
    required this.content,
    required this.isUserMessage,
    required this.type,
  });
}
