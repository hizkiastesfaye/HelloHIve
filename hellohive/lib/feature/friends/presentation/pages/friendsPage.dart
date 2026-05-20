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

  bool _isSearchBox = false;
  final TextEditingController _searchText = TextEditingController();
  void _onSubmitSearch(){
    String searchText = _searchText.text;
    if(_searchText.text.isEmpty || _searchText.text == '' || _searchText.text == ' ' ){
      setState(() {
        _isSearchBox = false;
      });
    }
    else{
      // context.read<FriendsBloc>().add(GetFriendsEvent(
      //   value: searchText
      // ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 20,),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width* 0.7,
                      child: _isSearchBox 
              
                        ? TextField(
                          controller: _searchText,                       
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.grey[150],
                            
                            hintText: 'search',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20), // smaller radius
                              borderSide: BorderSide(
                                width: 1, // thinner border
                                color: Colors.grey,
                              ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey[800]!,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {
                                setState(() {
                                  _isSearchBox = false;
                                });
                                
                                print('you entered');
                              },
                          ),
                          ),                   
                        ) 
              
                      : SizedBox()
                    ),
                  ),
                  !_isSearchBox ? Container(
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: (){
                        setState(() {
                                  _isSearchBox = true;
                                });
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey[00],
                        ),
                    )
                  )
                  : SizedBox(width: 40,)
                ],
              ),
            ),
            Center(
              child: BlocBuilder<FriendsBloc, FriendsState>(
                builder: (context, state) {
                  if(state is FriendsLoading){
                    return Center(child: CircularProgressIndicator());
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
          ],
        ),
      ),
    );
  }
}
