import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadChatData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatError) {
            return Center(child: Text(state.message));
          } else if (state is ChatLoaded) {
            final profile = state.myProfile;
            final users = state.users;
            final chats = state.chats;
            final selectedChat = state.selectedChat;

            return Column(
              children: [
                // Profile and Users row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    //backgroundcolor: const Color.fromARGB(255, 25, 21, 151),
                    children: [
                      // My profile
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          profile.name.isNotEmpty
                              ? profile.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Horizontal list of users
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: users.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return GestureDetector(
                                onTap: () {
                                  context.read<ChatBloc>().add(
                                    SelectChatUser(user.id),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey.shade300,
                                  child: Text(
                                    user.name.isNotEmpty
                                        ? user.name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Chats list or chat detail
                Expanded(
                  child: selectedChat == null
                      ? ListView.separated(
                          itemCount: chats.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Text(
                                  chat.user.name.isNotEmpty
                                      ? chat.user.name[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(chat.user.name),
                              subtitle: chat.messages.isNotEmpty
                                  ? Text(
                                      chat
                                          .messages
                                          .last
                                          .content, // use 'content' instead of 'message'
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const Text('Message'),

                              onTap: () {
                                context.read<ChatBloc>().add(
                                  SelectChatUser(chat.user.id),
                                );
                              },
                            );
                          },
                        )
                      : ChatDetail(chat: selectedChat),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class ChatDetail extends StatefulWidget {
  final chat;

  const ChatDetail({super.key, required this.chat});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessageEvent(widget.chat.id, message));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.chat;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: chat.messages.length,
            itemBuilder: (context, index) {
              final msg = chat.messages[index];
              final isMe =
                  msg.senderId == chat.user.id; // adjust logic if needed
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blueAccent : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    msg.message,
                    style: TextStyle(color: isMe ? Colors.white : Colors.black),
                  ),
                ),
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Enter message',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
            ],
          ),
        ),
      ],
    );
  }
}
