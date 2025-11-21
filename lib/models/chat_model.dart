class ChatMessage {
  final String text;
  final String sender;
  final bool isMe;
  final bool isRead;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.isMe,
    required this.isRead,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, String currentUser) {
    final sender = json["sender"].toString();

    return ChatMessage(
      text: json["pesan"] ?? "",
      sender: sender,
      isMe: sender == currentUser, // Perawat atau Keluarga
      isRead: json["is_read"] == true || json["is_read"] == 1,
      timestamp: DateTime.parse(json["created_at"]),
    );
  }
}
