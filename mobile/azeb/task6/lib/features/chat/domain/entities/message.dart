class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String type;
  final DateTime? timestamp;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.type,
    this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Message(
        id: '',
        chatId: '',
        senderId: '',
        content: '',
        type: '',
        timestamp: null,
      );
    }

    return Message(
      id: json['_id']?.toString() ?? '',
      chatId: json['chat']?['_id']?.toString() ?? '',
      senderId: json['sender']?['_id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'chat': {'_id': chatId},
      'sender': {'_id': senderId},
      'content': content,
      'type': type,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
