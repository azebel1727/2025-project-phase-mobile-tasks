import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call(String chatId, String message) async {
    await repository.sendMessage(chatId, message);
  }
}
