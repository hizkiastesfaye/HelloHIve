import 'package:flutter/material.dart';

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
        title: Text('Chats'),
      ),
      body: Center(
        child: Text('Chats Page'),
      ),
    );
  }
}