import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task6/features/chat/domain/entities/message.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/chat.dart';
import '../../domain/usecases/get_my_profile_usecase.dart';
import '../../domain/usecases/get_users_usecase.dart';
import 'package:task6/features/chat/domain/usecases/get_chats_usecase.dart'
    as get_chats;
import 'package:task6/features/chat/domain/usecases/send_message_usecase.dart'
    as send_message;
import '../../domain/usecases/receive_messages_usecase.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMyProfileUseCase getMyProfileUseCase;
  final GetUsersUseCase getUsersUseCase;
  final get_chats.GetChatsUseCase getChatsUseCase;
  final send_message.SendMessageUseCase sendMessageUseCase;
  final ReceiveMessagesUseCase receiveMessagesUseCase;

  ChatBloc({
    required this.getMyProfileUseCase,
    required this.getUsersUseCase,
    required this.getChatsUseCase,
    required this.sendMessageUseCase,
    required this.receiveMessagesUseCase,
  }) : super(ChatInitial()) {
    // on<Overview>(_onOverview);
    on<LoadChatData>(_onLoadChatData);
    on<SelectChatUser>(_onSelectChatUser);
    on<SendMessageEvent>(_onSendMessage);
  }
  Future<void> _onLoadChatData(
    LoadChatData event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      debugPrint('Loading user profile...');
      final myProfile = await getMyProfileUseCase();
      print(myProfile);
      debugPrint('Loading users...');
      final users = await getUsersUseCase();
      debugPrint('Loading chats...');
      final chats = await getChatsUseCase();
      debugPrint('Loaded chats...');
      emit(ChatLoaded(myProfile: myProfile, users: users, chats: chats));
      debugPrint('Listening for incoming messages...');
    } catch (e) {
      emit(ChatError(e.toString()));
      debugPrint('ChatBloc loading chat data: ${e.toString()}');
    }
  }

  void _onSelectChatUser(SelectChatUser event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final selectedChat = currentState.chats.firstWhere(
        (chat) => chat.user.id == event.userId,
        orElse: () => Chat(
          id: '',
          user: currentState.users.firstWhere((u) => u.id == event.userId),
          messages: <Message>[],
          lastMessage: '',
          lastUpdated: DateTime.now(), // <== Add this to fix error
        ),
      );

      emit(
        ChatLoaded(
          myProfile: currentState.myProfile,
          users: currentState.users,
          chats: currentState.chats,
          selectedChat: selectedChat,
        ),
      );
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      try {
        await sendMessageUseCase(event.chatId, event.message);
        final chats = await getChatsUseCase();
        emit(
          ChatLoaded(
            myProfile: currentState.myProfile,
            users: currentState.users,
            chats: chats,
            selectedChat: chats.firstWhere((chat) => chat.id == event.chatId),
          ),
        );
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    }
  }
}
