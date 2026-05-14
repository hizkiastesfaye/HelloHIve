import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellohive/feature/friends/presentation/bloc/friends_bloc.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Friends')),
      body: SingleChildScrollView(
        child: Center(
          child: BlocBuilder<FriendsBloc, FriendsState>(
            builder: (context, state) {
              if(state is FriendsLoading){
                return CircularProgressIndicator();
              }
              else if(state is RandomFriendsLoaded){
                return Column(
                  children: state.friends.map((friend){
                    return ListTile(
                      title: Text(friend.username)
                    );
                  }).toList(),
                );
              }
              else{
                return Text('some Error');
              }
            },
          ),
        ),
      ),
    );
  }
}
