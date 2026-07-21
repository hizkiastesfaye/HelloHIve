import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hellohive/feature/friends/data/models/friends_hive_model.dart';
import 'package:hellohive/feature/friends/data/models/friends_model.dart';
import 'package:hive/hive.dart';

abstract class FriendSyncService {
  Future<void> initialize();
  Future<void> syncFriends(List<String> friendIds);
  Future<void> addFriend(String friendId);
  Future<void> removeFriend(String friendId);
  Future<void> dispose();
}

class FriendSyncServiceImpl implements FriendSyncService {
  FriendSyncServiceImpl({
    required FirebaseFirestore firestore,
    required Box<FriendsHiveModel> friendsBox,
  })  : _firestore = firestore,
        _friendsBox = friendsBox;

  final FirebaseFirestore _firestore;
  final Box<FriendsHiveModel> _friendsBox;

  final Map<String, StreamSubscription<DocumentSnapshot>>
      _subscriptions = {};

  @override
  Future<void> initialize() async {
    final ids = _friendsBox.keys.cast<String>().toList();

    await syncFriends(ids);
  }

  @override
  Future<void> syncFriends(List<String> friendIds) async {
    for (final id in friendIds) {
      await addFriend(id);
    }
  }

  @override
  Future<void> addFriend(String friendId) async {
    if (_subscriptions.containsKey(friendId)) {
      return;
    }

    final subscription = _firestore
        .collection('users') // <-- Change if needed
        .doc(friendId)
        .snapshots()
        .listen(
      (snapshot) async {
        try {
          if (!snapshot.exists) {
            await _friendsBox.delete(friendId);
            await removeFriend(friendId);
            return;
          }
          final data = snapshot.data();

          if (data == null) return;

          final friend = FriendsModel.fromJson({
            ...data,
            'uId': snapshot.id,
          });

          await _friendsBox.put(
            friendId,
            friend.toHiveModel(),
          );
        } catch (_) {
          // Optionally log the error.
        }
      },
      onError: (_) {
        // Optionally log Firestore listener errors.
      },
    );

    _subscriptions[friendId] = subscription;
  }

  @override
  Future<void> removeFriend(String friendId) async {
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