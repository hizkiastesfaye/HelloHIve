import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hellohive/feature/friends/presentation/pages/friendsPage.dart';
import 'package:hellohive/feature/settings/presentation/pages/settingsPage.dart';
import 'package:hellohive/feature/chats/presentation/pages/chatsPage.dart';
class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  _HomePageState createState()=> _HomePageState();
}
class _HomePageState extends State<HomePage>{
  bool _isChatSelected = true;
  bool _isSettingsSelected = false;
  bool _isfriendsSelected = false;

  Widget _builder(){
    if(_isChatSelected){
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chat Home Page'),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, '/oldLogin');
              },
              child: Text('Go to Login'),
            ),
          ],
      );
    }else if(_isSettingsSelected){
      // return Text('Settings Page');
      return SettingsPage();
    }else if(_isfriendsSelected){
      return FriendsPage();
    }else{
      return ChatsPage();
    }
  }
  @override
  Widget build(BuildContext context){

    Color chatSelectedColor = _isChatSelected ? Colors.blue : const Color.fromARGB(255, 59, 59, 59);
    Color settingsSelectedColor = _isSettingsSelected ? Colors.blue : const Color.fromARGB(255, 59, 59, 59);
    Color friendsSelectedColor = _isfriendsSelected ? Colors.blue : const Color.fromARGB(255, 59, 59, 59);
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
            icon:Icon(Icons.more_vert),
            onPressed: (){}
        ),
        title: Row(children: [
          SizedBox(width: 8),
          Text('Hello Hive'),
        ],),
      ),
      body: Align(
        alignment: Alignment.center,
        child: _builder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                // color: Color.fromARGB(255, 139, 139, 139).withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 58,
                  // spreadRadius: 2,
                  offset: Offset(0, 0),
                ),]
              ),
        
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                  style: TextButton.styleFrom(
                      // This changes the actual button background
                      backgroundColor: _isChatSelected ? Colors.blue.withValues(alpha: 0.1) : Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),                   
                    onPressed: (){
                      setState(() {
                        _isChatSelected = true;
                        _isSettingsSelected = false;
                        _isfriendsSelected = false;
                      });
                    },
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded, color: chatSelectedColor),
                        Text('Chat', style: TextStyle(color: chatSelectedColor)),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
        
                  TextButton(
                  style: TextButton.styleFrom(
                      // This changes the actual button background
                      backgroundColor: _isSettingsSelected ? Colors.blue.withValues(alpha: 0.1) : Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: (){
                      setState(() {
                        _isChatSelected = false;
                        _isSettingsSelected = true;
                        _isfriendsSelected = false;
                      });
                    },
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.settings, color: settingsSelectedColor),
                        Text('Settings', style: TextStyle(color: settingsSelectedColor)),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
        
                  TextButton(
                  style: TextButton.styleFrom(
                      // This changes the actual button background
                      backgroundColor: _isfriendsSelected ? Colors.blue.withValues(alpha: 0.1) : Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: (){
                      setState(() {
                        _isChatSelected = false;
                        _isSettingsSelected = false;
                        _isfriendsSelected = true;
                      });
                    },
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person, color: friendsSelectedColor),
                        Text('Friends', style: TextStyle(color: friendsSelectedColor)),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                ],),
            ),
          ),
        ),
      )
    );
  }
}