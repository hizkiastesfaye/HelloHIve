import 'dart:async';

import 'package:hellohive/feature/friends/data/models/friends_model.dart';

import '../datasources/friends_local_ds.dart';
import '../datasources/friends_remote_ds.dart';

abstract class FriendSyncService {
  Future<void> initialize(List<String> friendIds);
  Future<void> syncFriends(List<String> friendIds);
  Future<void> startListeningToFriend(String friendId);
  Future<void> stopListeningToFriend(String friendId,);
  Future<void> dispose();
}

class FriendSyncServiceImpl implements FriendSyncService {
  final FriendsRemoteDS remoteDatasource;
  final FriendsLocalDS localDatasource;

  FriendSyncServiceImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  final Map<String, StreamSubscription<FriendsModel>>
      _subscriptions = {};

  @override
  Future<void> initialize(List<String> friendIds) async {
    await syncFriends(friendIds);
  }

  @override
  Future<void> syncFriends(List<String> friendIds) async {
    final currentIds = _subscriptions.keys.toSet();
    final newIds = friendIds.toSet();

    // Stop listeners for removed friends
    for (final id in currentIds.difference(newIds)) {
      await stopListeningToFriend(id);
    }

    // Start listeners for newly added friends
    for (final id in newIds.difference(currentIds)) {
      await startListeningToFriend(id);
    }
  }

  @override
  Future<void> startListeningToFriend(
    String friendId,
  ) async {
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
        // Friend deleted or unavailable.
        // Stop listening.
        await stopListeningToFriend(friendId);
      },
    );

    _subscriptions[friendId] = subscription;
  }

  @override
  Future<void> stopListeningToFriend(
    String friendId,
  ) async {
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