import '../repositories/chat_repository.dart';
import '../../domain/entities/message.dart';

class ReceiveMessagesUseCase {
  final ChatRepository repository;

  ReceiveMessagesUseCase(this.repository);

  Stream<Message> call(String chatId) {
    return repository.receiveMessages(chatId);
  }
}
