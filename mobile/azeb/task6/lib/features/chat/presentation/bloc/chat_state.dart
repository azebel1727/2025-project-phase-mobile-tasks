import 'package:equatable/equatable.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/user.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}
final class chatoverview extends ChatState {
  final List<Chat> chats;
  final User myProfile;
  final List<User> users;

  const chatoverview({
    required this.chats,
    required this.myProfile,
    required this.users,
  });

  @override
  List<Object?> get props => [chats, myProfile, users];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final User myProfile;
  final List<User> users;
  final List<Chat> chats;
  final Chat? selectedChat;

  const ChatLoaded({
    required this.myProfile,
    required this.users,
    required this.chats,
    this.selectedChat,
  });

  @override
  List<Object?> get props => [myProfile, users, chats, selectedChat];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
