// lib/models/chat_message.dart

enum ChatSender { user, ai }

class ChatMessage {
  final ChatSender sender;
  final String message;
  final DateTime sentAt;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.sentAt,
  });

  bool get isUser => sender == ChatSender.user;
  bool get isAI => sender == ChatSender.ai;

  Map<String, dynamic> toJson() {
    return {
      'type': sender == ChatSender.user ? 'user' : 'ai',
      'message': message,
      'sent_at': sentAt.toIso8601String(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final type = (json['type'] ?? 'user').toString();
    return ChatMessage(
      sender: type == 'ai' ? ChatSender.ai : ChatSender.user,
      message: json['message']?.toString() ?? '',
      sentAt:
          DateTime.tryParse(json['sent_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
