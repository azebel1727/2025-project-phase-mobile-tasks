import '../entities/message.dart';
import '../repositories/chat_repository.dart';
import '../entities/chat.dart';

class GetChatsUseCase {
  final ChatRepository repository;

  GetChatsUseCase(this.repository);

  Future<List<Chat>> call() async {
    return await repository.getChats();
  }
}

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call(String chatId, String message) async {
    await repository.sendMessage(chatId, message);
  }
}

class ReceiveMessagesUseCase {
  final ChatRepository repository;

  ReceiveMessagesUseCase(this.repository);

  Stream<Message> call(String chatId) {
    return repository.receiveMessages(chatId);
  }
}
