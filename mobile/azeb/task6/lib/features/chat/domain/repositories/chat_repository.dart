// domain/repositories/chat_repository.dart
import '../entities/chat.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<List<Chat>> getChats();
  Future<void> sendMessage(String chatId, String message);
  Stream<Message> receiveMessages(String chatId);
}
