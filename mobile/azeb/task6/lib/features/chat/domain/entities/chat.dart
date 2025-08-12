import 'package:task6/features/chat/domain/entities/message.dart';
import 'user.dart';

class Chat {
  final String id;
  final User user;
  final List<Message> messages;
  final String lastMessage;
  final DateTime lastUpdated;

  Chat({
    required this.id,
    required this.user,
    required this.messages,
    required this.lastMessage,
    required this.lastUpdated,
  });

  factory Chat.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      // Handle null json by returning a default Chat or throw
      return Chat(
        id: '',
        user: User(id: '', name: ''),
        messages: [],
        lastMessage: '',
        lastUpdated: DateTime.now(),
      );
    }

    return Chat(
      id: json['id']?.toString() ?? '',
      user: User.fromJson(json['user'] as Map<String, dynamic>?),
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((msg) => Message.fromJson(msg as Map<String, dynamic>?))
              .toList() ??
          [],
      lastMessage: json['lastMessage']?.toString() ?? '',
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'lastMessage': lastMessage,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
