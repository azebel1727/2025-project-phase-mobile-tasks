// chat_remote_datasource.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '/features/auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';

class ChatRemoteDatasource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;
  final String wsUrl;

  WebSocketChannel? _channel;
  final _messageController = StreamController<Message>.broadcast();

  ChatRemoteDatasource({
    required this.client,
    required this.authLocalDataSource,
    required this.wsUrl,
  });

  Future<String> _getToken() async {
    final token = await authLocalDataSource.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No valid token found');
    }
    return token;
  }

  Future<List<Chat>> getChats() async {
    final token = await _getToken();
    final response = await client.get(
      Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/chats',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print("it is successful");
      print(response.body);
      final chatlist = json.decode(response.body) as Map<String, dynamic>;
      print(chatlist);
      final List<dynamic> data = chatlist['data'] as List<dynamic>? ?? [];
      return data.map((chatJson) => Chat.fromJson(chatJson)).toList();
    }
    print("it is failed");
    print(response.body);
    throw Exception('Failed to load chats');
  }

  Future<void> sendMessage(String chatId, String message) async {
    final token = await _getToken();
    final response = await client.post(
      Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/chats/$chatId/messages',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'message': message}),
    );

    if (response.statusCode != 200) {
      print("it is failed");
      print(response.body);
      throw Exception('Failed to send message');
    }
  }

  // Connect to WebSocket and listen for messages
  void connectToWebSocket(String chatId) async {
    final token = await _getToken();
    _channel = WebSocketChannel.connect(
      Uri.parse('$wsUrl?token=$token&chatId=$chatId'),
    );

    _channel!.stream.listen((event) {
      final decoded = json.decode(event);
      final msg = Message.fromJson(decoded);
      _messageController.add(msg);
    });
  }

  // Stream getter for incoming messages
  Stream<Message> get messageStream => _messageController.stream;

  void dispose() {
    _channel?.sink.close();
    _messageController.close();
  }
}
