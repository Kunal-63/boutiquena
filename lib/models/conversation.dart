class Conversation {
  final int conversationId;
  final int user2Id;
  final String user2Type;
  final String name;
  final String? lastMessage;
  final DateTime updatedAt;

  Conversation({
    required this.conversationId,
    required this.user2Id,
    required this.user2Type,
    required this.name,
    this.lastMessage,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      conversationId: json['conversation_id'],
      user2Id: json['user2_id'],
      user2Type: json['user2_type'],
      name: json['name'],
      lastMessage: json['last_message'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
