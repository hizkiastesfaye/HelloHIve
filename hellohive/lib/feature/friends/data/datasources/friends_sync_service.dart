import 'dart:async';

import 'package:hellohive/feature/friends/data/datasources/friends_local_ds.dart';
import 'package:hellohive/feature/friends/data/datasources/friends_remote_ds.dart';
import 'package:hellohive/feature/friends/data/models/friends_model.dart';

abstract class FriendSyncService {
  /// Starts syncing all friends currently stored locally.
  Future<void> syncFriends();

  /// Stops all active listeners.
  Future<void> dispose();
}

class FriendSyncServiceImpl implements FriendSyncService {
  final FriendsRemoteDS remoteDatasource;
  final FriendsLocalDS localDatasource;

  FriendSyncServiceImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  final Map<String, StreamSubscription<FriendsModel>> _subscriptions = {};

  @override
  Future<void> syncFriends() async {
    final localFriendIds =
        (await localDatasource.getFriendsIdsLocal()).toSet();

    final listeningIds = _subscriptions.keys.toSet();

    // Stop listening to friends that no longer exist locally.
    for (final friendId in listeningIds.difference(localFriendIds)) {
      await _stopListening(friendId);
    }

    // Start listening to newly added friends.
    for (final friendId in localFriendIds.difference(listeningIds)) {
      await _startListening(friendId);
    }
  }

  Future<void> _startListening(String friendId) async {
    if (_subscriptions.containsKey(friendId)) {
      return;
    }

    final subscription = remoteDatasource
        .watchFriend(friendId)
        .listen(
      (friend) async {
        await localDatasource.cacheFriendLocal(friend);
      },
      onError: (_) async {
        await _stopListening(friendId);
      },
    );

    _subscriptions[friendId] = subscription;
  }

  Future<void> _stopListening(String friendId) async {
    final subscription = _subscriptions.remove(friendId);

    await subscription?.cancel();
  }

  @override
  Future<void> dispose() async {
    for (final subscription in _subscriptions.values) {
      await subscription.cancel();
    }

    _subscriptions.clear();
  }
}