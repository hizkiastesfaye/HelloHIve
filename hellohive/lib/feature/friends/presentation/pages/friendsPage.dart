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
  String _selectedField = 'username';
  bool _isGetFriends = false;
    final List<String> fields = [
    'name',
    'username',
  ];

  final TextEditingController _searchText = TextEditingController();
  void _onSubmitSearch(){
    String searchText = _searchText.text;
    if(_searchText.text.isEmpty || _searchText.text == '' || _searchText.text == ' ' ){
      setState(() {
        _isSearchBox = false;
        _selectedField = 'username';
        _isGetFriends = false;
      });
    }
    else{
      setState(() {
        _isGetFriends = true;
      });
      context.read<FriendsBloc>().add(GetFriendsEvent(
        fieldName: _selectedField,
        value: searchText
      ));
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
                              onPressed: _onSubmitSearch,
                          ),
                          ),                   
                        ) 
              
                      : SizedBox()
                    ),

                  ),
                  if (_isSearchBox)
                  Container(
                    height: 60,
                    width: 50,

                    // decoration: BoxDecoration(
                    //   color: Colors.grey[200],
                    //   borderRadius: BorderRadius.circular(10),
                    // ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,

                      children: [

                        PopupMenuButton<String>(

                          padding: EdgeInsets.zero,

                          constraints: const BoxConstraints(),

                          position: PopupMenuPosition.under,

                          offset: const Offset(30, 0),

                          onSelected: (value) {
                            setState(() {
                              _selectedField = value;
                            });
                          },

                          itemBuilder: (context) {
                            return fields.map((field) {

                              return PopupMenuItem<String>(
                                value: field,
                                child: Text(field),
                              );

                            }).toList();
                          },

                          child: const Icon(
                            Icons.filter_list,
                            size: 14,
                          ),
                        ),

                        const SizedBox(height: 1),

                        Flexible(
                          child: Text(
                            _selectedField,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
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
            _isSearchBox ? Align(
              alignment: Alignment.centerRight,
            child:SizedBox(
              height: 20,
              child: IconButton(
                icon: Icon(Icons.close) ,
                onPressed: (){
                  setState(() {
                    _isGetFriends = false;
                    _isSearchBox = false;
                  });
                  _selectedField = 'username';
                  _searchText.text = '';
                  context.read<FriendsBloc>().add(GetRandomFriendsEvent());
                },
                ),
            )
            )       
              : SizedBox(),

            _isGetFriends ? Center(
              child: BlocBuilder<FriendsBloc, FriendsState>(
                builder: (context, state) {
                  if(state is FriendsLoading){
                    return Center(child: CircularProgressIndicator());
                  }
                  else if(state is FriendsLoaded){
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
            ) 
            : Center(
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
