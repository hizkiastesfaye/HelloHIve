import 'package:flutter/material.dart';
import 'package:hellohive/feature/chats/presentation/pages/chatpage.dart';
import 'package:hellohive/feature/chats/presentation/pages/chats_friends.dart';
import 'package:hellohive/feature/chats/presentation/pages/trypage.dart';
import 'package:hellohive/feature/friends/presentation/bloc/friends_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chats/chats_bloc.dart';

class ChatsPage extends StatefulWidget{
  
  const ChatsPage({super.key});
  @override
  __ChatsPageStateState createState() => __ChatsPageStateState();
}
class __ChatsPageStateState extends State<ChatsPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats Home Page'),
      ),
      body: Center( child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chat Home Page'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/oldLogin');
              },
              child: Text('Go to Login'),
            ),

            Text('Try Chats Page'),
            ElevatedButton(
              onPressed: () {
                // Navigator.pushNamed(context, '/tryChat');
                context.read<ChatsBloc>().add(
                  
                  ChatSyncEvent('kFe0FXpgqsZDWLM6g45nCzm1Wnl1')
                );

                Navigator.push(context, MaterialPageRoute(builder: (context) => TryChatPage()));
                
              },
              child: Text('Go to Try Chat'),
            ),
            ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FriendsListByIdPage(),
                ),
              );
            },
            child: const Text('Go to chat_friends'),
          ),
          ElevatedButton(
            onPressed: () {
              // context.read<ChatsBloc>().add(
              //   GetChatsEvent(userId: 'kFe0FXpgqsZDWLM6g45nCzm1Wnl1')
              // );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatPage(uId:'kFe0FXpgqsZDWLM6g45nCzm1Wnl1'),
                ),
              );
            },
            child: const Text('Go to chat chats'),
          )
          ],
        )
      ),
    );
  }
}