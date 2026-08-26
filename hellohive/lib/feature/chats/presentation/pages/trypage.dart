import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellohive/feature/chats/presentation/bloc/chats/chats_bloc.dart';

class TryChatPage extends StatefulWidget {
  const TryChatPage({super.key});

  @override
  State<TryChatPage> createState() => _TryChatPageState();
}

class _TryChatPageState extends State<TryChatPage> {
  final currentUserController = TextEditingController();
  final userBController = TextEditingController();

  @override
  void dispose() {
    currentUserController.dispose();
    userBController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Try Chat'),
      ),
      body: BlocConsumer<ChatsBloc, ChatsState>(
        listener: (context, state) {
          if (state is ChatCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          if (state is ChatDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          if (state is ChatMuted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          if (state is ChatsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: currentUserController,
                  decoration: const InputDecoration(
                    labelText: 'Current User Id',
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: userBController,
                  decoration: const InputDecoration(
                    labelText: 'Other User Id',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatsBloc>().add(
                            CreateChatEvent(
                              // currentUserId:
                              // currentUserController.text,
                              // userBId: userBController.text,
                              currentUserId: 'kFe0FXpgqsZDWLM6g45nCzm1Wnl1',
                              // userBId: 'PO7JWLCipETDQTCCsJM5KdgVZv83'
                              userBId: 'ZxHLcmKdfoh499xFizuQp73Rfon2'
                            ),
                          );
                    },
                    child: const Text('Create Chat'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatsBloc>().add(
                            WatchChatsEvent(
                              userId:
                                  // currentUserController.text,
                                  'kFe0FXpgqsZDWLM6g45nCzm1Wnl1'
                            ),
                          );
                    },
                    child: const Text('Watch Chats'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatsBloc>().add(
                            GetChatsEvent(
                              userId:
                                  // currentUserController.text,
                                  'kFe0FXpgqsZDWLM6g45nCzm1Wnl1'
                            ),
                          );
                    },
                    child: const Text('Get Chats'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatsBloc>().add(
                            GetChatEvent(
                              currentUserId:
                                  // currentUserController.text,
                                  'kFe0FXpgqsZDWLM6g45nCzm1Wnl1',
                              userBId: 'PO7JWLCipETDQTCCsJM5KdgVZv83'
                            ),
                          );
                    },
                    child: const Text('Get a Chat'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatsBloc>().add(
                            GetChatByIdEvent(
                              chatId:  'PO7JWLCipETDQTCCsJM5KdgVZv83_kFe0FXpgqsZDWLM6g45nCzm1Wnl1',
                            ),
                          );
                    },
                    child: const Text('Get Chat by Id'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatsBloc>().add(
                            UpdateChatEvent(
                              // id:  'PO7JWLCipETDQTCCsJM5KdgVZv83_kFe0FXpgqsZDWLM6g45nCzm1Wnl1',
                              id: 'ZxHLcmKdfoh499xFizuQp73Rfon2_kFe0FXpgqsZDWLM6g45nCzm1Wnl1',
                              userAId:
                                  // currentUserController.text,
                                  'kFe0FXpgqsZDWLM6g45nCzm1Wnl1',
                              // userBId: 'PO7JWLCipETDQTCCsJM5KdgVZv83',
                              userBId: 'ZxHLcmKdfoh499xFizuQp73Rfon2',
                              unreadCount: {
                                'kFe0FXpgqsZDWLM6g45nCzm1Wnl1': 1,
                                // 'PO7JWLCipETDQTCCsJM5KdgVZv83':1
                                'ZxHLcmKdfoh499xFizuQp73Rfon2':0,
                              },
                              mutedBy:{
                                'kFe0FXpgqsZDWLM6g45nCzm1Wnl1': false,
                                // 'PO7JWLCipETDQTCCsJM5KdgVZv83':true
                                'ZxHLcmKdfoh499xFizuQp73Rfon2':false
                              },
                              deletedBy: {
                                'kFe0FXpgqsZDWLM6g45nCzm1Wnl1': false,
                                // 'PO7JWLCipETDQTCCsJM5KdgVZv83':false,
                                'ZxHLcmKdfoh499xFizuQp73Rfon2':false
                              }
                            ),
                          );
                    },
                    child: const Text('Update chats'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatsBloc>().add(
                            DeleteChatEvent(
                              userId:
                                  // currentUserController.text,
                                  'kFe0FXpgqsZDWLM6g45nCzm1Wnl1',
                              // chatId: 'PO7JWLCipETDQTCCsJM5KdgVZv83_kFe0FXpgqsZDWLM6g45nCzm1Wnl1',
                              chatId:'ZxHLcmKdfoh499xFizuQp73Rfon2_kFe0FXpgqsZDWLM6g45nCzm1Wnl1'

                            ),
                          );
                    },
                    child: const Text('Delete Chat'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatsBloc>().add(
                            MuteChatEvent(
                              currentUserId:
                                  // currentUserController.text,
                                  'kFe0FXpgqsZDWLM6g45nCzm1Wnl1',
                              chatId: 'PO7JWLCipETDQTCCsJM5KdgVZv83_kFe0FXpgqsZDWLM6g45nCzm1Wnl1',
                              isMuted: true,
                            ),
                          );
                    },
                    child: const Text('Mute Chat'),
                  ),
                ],
              ),


              const SizedBox(height: 20),

              if (state is ChatsLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              if (state is WatchChats)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.chats.length,
                    itemBuilder: (context, index) {
                      final chat = state.chats[index];

                      return Card(
                        child: ListTile(
                          title: Text(
                            '${chat.participants[0]} ↔ ${chat.participants[1]}',
                          ),
                          subtitle: Text(
                            chat.lastMessageText ?? 'No messages',
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                value: 'mute',
                                child: Text('Mute')
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'mute') {
                                context.read<ChatsBloc>().add(
                                      MuteChatEvent(
                                        currentUserId:
                                            // currentUserController.text,
                                            'kFe0FXpgqsZDWLM6g45nCzm1Wnl1',
                                        chatId: chat.id,
                                        isMuted: true,
                                      ),
                                    );
                              }

                              if (value == 'delete') {
                                context.read<ChatsBloc>().add(
                                      DeleteChatEvent(
                                        chatId: chat.id,
                                        userId:
                                            currentUserController.text,
                                      ),
                                    );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

              if (state is ChatsLoaded)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.chats.length,
                    itemBuilder: (context, index) {
                      final chat = state.chats[index];

                      return ListTile(
                        title: Column(
                          children: [
                            Text(chat.chatId),
                            Text(chat.firstName),
                          ],
                        ),
                        subtitle: Text(
                          
                          chat.lastMessageText ?? 'No messages',
                        ),
                      );
                    },
                  ),
                ),

              if (state is ChatLoaded)
                Expanded(
                  child: Center(
                    child: Text(
                      'Chat: ${state.chat.id}',
                    ),
                  ),
                ),
              if (state is ChatLoadedById)
                Expanded(
                  child: Center(
                    child: Text(
                      'Chat: ${state.chat.id}',
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}