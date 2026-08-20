import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hellohive/feature/friends/domain/entities/friends_entities.dart';
import 'package:hellohive/feature/friends/domain/usecases/friends_usecases.dart';
import 'package:hellohive/feature/friends/friends_core/friends_usecases_core.dart';



class FriendsListByIdPage extends StatefulWidget {
  const FriendsListByIdPage({
    super.key,
  });

  @override
  State<FriendsListByIdPage> createState() => _FriendsListByIdPageState();
}

class _FriendsListByIdPageState extends State<FriendsListByIdPage> {
  final GetFriendsByListIdUsecases getFriendsByListIdUsecases =
      GetIt.instance<GetFriendsByListIdUsecases>();

  final List<String> friendsIds = [
    'ZxHLcmKdfoh499xFizuQp73Rfon2',
    'kFe0FXpgqsZDWLM6g45nCzm1Wnl1',
    // 'PO7JWLCipETDQTCCsJM5KdgVZv83',
  ];

  List<FriendsEntities> friends = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final result = await getFriendsByListIdUsecases(
      FriendsIdsParams(
        friendsIds: friendsIds,
      ),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          isLoading = false;
          errorMessage = failure.message;
        });
      },
      (data) {
        setState(() {
          isLoading = false;
          friends = data;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFriends,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (friends.isEmpty) {
      return const Center(
        child: Text('No friends found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];

        return Card(
          child: ListTile(
            leading: Text(
              friend.uId,
            ),
            title: Text(
              '${friend.firstName} ${friend.lastName}',
            ),
            subtitle: Text('@${friend.username}'),
          ),
        );
      },
    );
  }
}