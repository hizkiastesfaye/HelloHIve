import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellohive/feature/chats/presentation/bloc/chats/chats_bloc.dart';
import 'package:hellohive/feature/chats/presentation/pages/chat_friend_detail.dart';
// import 'package:hellohive/feature/chats/presentation/pages/chat_message.dart';
import 'package:hellohive/feature/chats/presentation/pages/chatsPage.dart';
import 'package:hellohive/feature/chats/presentation/pages/message/chat_message_page.dart';
import 'package:hellohive/feature/friends/presentation/widgets/friend_photo_display_widget.dart';

class ChatPage extends StatefulWidget {
  final String uId;
  const ChatPage({super.key, required this.uId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
    @override
  void initState() {
    super.initState();

    context.read<ChatsBloc>().add(
      GetChatsEvent(
        // userId: 'kFe0FXpgqsZDWLM6g45nCzm1Wnl1',
        userId: widget.uId
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:ElevatedButton(
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>ChatsPage()));
              }, 
              child: Text('Go to Chatss chats')),
      ),
      body: BlocBuilder<ChatsBloc, ChatsState>(
        builder: (context, state) {
          if (state is ChatsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ChatsError) {
            return Center(child: Text(state.message));
          } else if (state is ChatsLoaded) {
            final chats = state.chats;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  shadowColor: Colors.black.withOpacity(0.1),
                  color: Colors.white,
                  child: ListTile(
                    leading:FriendPhotoDisplayWidget(photoUrl: chat.photoUrl),
                    title: Text(
                      '${chat.firstName} ${chat.lastName}',
                      style: TextTheme.of(context).titleLarge,
                      ),
                    subtitle: Text(
                      chat.lastMessageText?.isNotEmpty == true
                        ? chat.lastMessageText!
                        : 'say hi to your friend.',
                      style: TextTheme.of(context).bodySmall,
                      ),
                      trailing: Column(children: [
                        Text(
                          chat.lastMessageTime != null
                              ? '${chat.lastMessageTime!.hour}:${chat.lastMessageTime!.minute}'
                              : '${DateTime.now().hour}:${DateTime.now().minute}',
                          style: TextTheme.of(context).bodySmall,
                        ),
                        if (chat.unreadCount > 0)
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${chat.unreadCount}',
                              style: TextTheme.of(context).bodySmall?.copyWith(color: Colors.white),
                            ),
                          ),
                      ],),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatMessagePage(
                            allChatInfo:chat,
                            ),
                        ),
                        // MaterialPageRoute(
                        //   builder: (context) => ChatFriendDetail(allChatInfo: chat),
                        // ),
                      );
                      // Navigator.push(
                      //   context, 
                      //   MaterialPageRoute(
                      //     builder: (context) => ChatsPage()));
                      // Navigate to chat details page
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No chats available'));
          }
        },
      )
     
    );
  }
}