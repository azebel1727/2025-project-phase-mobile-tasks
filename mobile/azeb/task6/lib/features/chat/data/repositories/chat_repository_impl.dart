import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Chat>> getChats() async {
    // Await to ensure we get the list of chats asynchronously
    return (await remoteDataSource.getChats()).cast<Chat>();
  }

  @override
  Future<void> sendMessage(String chatId, String message) async {
    await remoteDataSource.sendMessage(chatId, message);
  }

  @override
  Stream<Message> receiveMessages(String chatId) {
    return remoteDataSource.messageStream.where((msg) => msg.chatId == chatId);
  }
}
