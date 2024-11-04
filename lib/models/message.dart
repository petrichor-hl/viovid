enum MessageType { image, text }

class Message {
  String content; // Sử dụng lớp cha cho nội dung
  bool isUserMessage;
  MessageType type;

  Message({
    required this.content,
    required this.isUserMessage,
    required this.type,
  });
}
