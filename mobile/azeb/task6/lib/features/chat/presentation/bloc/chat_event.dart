import 'package:equatable/equatable.dart';
import 'package:task6/features/chat/domain/entities/chat.dart';
import 'package:task6/features/chat/domain/entities/user.dart';


abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}
// class Overview extends ChatEvent {
//   const Overview();
//   }

  // @override
  // List<Object?> get props => [chats, myProfile, users];


class LoadChatData extends ChatEvent {
  const LoadChatData();

  @override
  List<Object?> get props => [];
}

class SelectChatUser extends ChatEvent {
  final String userId;
  const SelectChatUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String message;
  const SendMessageEvent(this.chatId, this.message);

  @override
  List<Object?> get props => [chatId, message];
}

class ReceiveMessageEvent extends ChatEvent {
  final String chatId;
  final String senderId;
  final String message;
  const ReceiveMessageEvent(this.chatId, this.senderId, this.message);

  @override
  List<Object?> get props => [chatId, senderId, message];
}
