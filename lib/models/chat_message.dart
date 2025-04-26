class ChatMessage {
  final int? id;
  final int? conversationId;
  final int? senderId;
  final String? senderType;
  final int? receiverId;
  final String? receiverType;
  final String? message;
  final bool? isSeen;
  final DateTime? createdAt;

  ChatMessage({
    this.id,
    this.conversationId,
    this.senderId,
    this.senderType,
    this.receiverId,
    this.receiverType,
    this.message,
    this.isSeen,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      conversationId:
          json['conversation_id'] != null
              ? int.tryParse(json['conversation_id'].toString())
              : null,
      senderId:
          json['sender_id'] != null
              ? int.tryParse(json['sender_id'].toString())
              : null,
      senderType: json['sender_type'] as String?,
      receiverId:
          json['receiver_id'] != null
              ? int.tryParse(json['receiver_id'].toString())
              : null,
      receiverType: json['receiver_type'] as String?,
      message: json['message'] as String?,
      isSeen:
          json['is_seen'] != null
              ? (json['is_seen'] == 1 || json['is_seen'] == true)
              : null,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
    );
  }
}
