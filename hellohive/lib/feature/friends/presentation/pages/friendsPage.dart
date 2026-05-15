import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellohive/feature/friends/presentation/bloc/friends_bloc.dart';
import '../widgets/widgets.dart';
class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});
  
  @override
  _FriendsPageState createState() => _FriendsPageState();
}
class _FriendsPageState extends State<FriendsPage> {


  @override
  void initState(){
    super.initState();
    Future.microtask(() {
      context.read<FriendsBloc>().add(GetRandomFriendsEvent());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      leading: FriendPhotoDisplayWidget(photoUrl:friend.photoUrl),
                      title: Text('${friend.firstName} ${friend.lastName}'),
                      subtitle: Text('@${friend.username}'),
                      onTap: (){
                        Navigator.pushNamed(context, '/addUserProfile');
                      },
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
