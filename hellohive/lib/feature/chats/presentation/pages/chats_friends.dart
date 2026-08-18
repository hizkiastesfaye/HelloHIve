
import 'package:flutter/material.dart';

class ChatsFriendsPage extends StatefulWidget {
  const ChatsFriendsPage({super.key});
  @override
  State<ChatsFriendsPage> createState() => _ChatsFriendsPageState();
  }

class _ChatsFriendsPageState extends State<ChatsFriendsPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Chats Friends Page'),
      ),
    );
  }
}