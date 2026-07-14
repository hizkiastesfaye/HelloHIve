
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/feature/friends/data/models/friends_model.dart';
import 'package:hellohive/feature/friends/friends_core/friends_usecases_core.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/friends_hive_model.dart';

abstract class FriendsLocalDS {
  Future<Unit> cacheRandomFriends(List<FriendsModel> friendsToCache);
  Future<List<FriendsModel>> getCachedRandomFriends();
  Future<List<FriendsModel>> getFriendsByListIdLocal(FriendsIdsParams params);
  Future<Unit> cacheFriendsByListIdLocal(List<FriendsModel> friends);

  Future<FriendsModel> getFriendLocal(String friendId);
  Future<List<FriendsModel>> getFriendsLocal();

  Future<Unit> cacheFriendLocal(FriendsModel friend);
  Future<Unit> cacheFriendsLocal(List<FriendsModel> friends);
}

class FriendsLocalDsImpl implements FriendsLocalDS {
  final Box<FriendsHiveModel> friendsBox;
  final SharedPreferences sharedPreferences;

  FriendsLocalDsImpl({
    required this.friendsBox,
    required this.sharedPreferences,
  });

  @override
  Future<Unit> cacheRandomFriends(List<FriendsModel> friendsToCache)async{
    if(friendsToCache.isEmpty){
      throw CacheException();
    }
    try{
      final friendsJson = jsonEncode(
        friendsToCache.map((friend)=> friend.toJson()).toList()
      );
      await sharedPreferences.setString('randomFriends',friendsJson);
      return unit;
    } catch (e){
      throw CacheException();
    }
  }
  @override
  Future<List<FriendsModel>> getCachedRandomFriends() async{
    try{
      final jsonString = await sharedPreferences.getString('randomFriends');
      if(jsonString == null || jsonString.isEmpty){
        throw CacheException('No data in catch');
      }
      final decodeJson = jsonDecode(jsonString) as List;
      return decodeJson.map((friend)=> FriendsModel.fromJson(friend)).toList();
    }
    catch(_){
      throw CacheException();
    }
  }

  @override
  Future<List<FriendsModel>> getFriendsByListIdLocal(
    FriendsIdsParams params,
  ) async {
    try {
      final friends = <FriendsModel>[];

      for (final id in params.friendsIds) {
        final friend = friendsBox.get(id);

        if (friend != null) {
          friends.add(friend.toModel());
        }
      }

      return friends;
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<Unit> cacheFriendsByListIdLocal(
    List<FriendsModel> friends,
  ) async {
    try {
      if (friends.isEmpty) {
        return unit;
      }

      await friendsBox.putAll({
        for (final friend in friends)
          friend.uId: friend.toHiveModel(),
      });

      return unit;
    } catch (_) {
      throw CacheException();
    }
  }


  @override
  Future<Unit> cacheFriendLocal(
    FriendsModel friend,
  ) async {
    try {
      await friendsBox.put(
        friend.uId,
        friend.toHiveModel(),
      );

      return unit;
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<Unit> cacheFriendsLocal(
    List<FriendsModel> friends,
  ) async {
    try {
      if (friends.isEmpty) {
        return unit;
      }

      await friendsBox.putAll({
        for (final friend in friends)
          friend.uId: friend.toHiveModel(),
      });

      return unit;
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<FriendsModel> getFriendLocal(
    String friendId,
  ) async {
    try {
      final friend = friendsBox.get(friendId);

      if (friend == null) {
        throw CacheException('Friend not found');
      }

      return friend.toModel();
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<FriendsModel>> getFriendsLocal() async {
    try {
      return friendsBox.values
          .map((friend) => friend.toModel())
          .toList();
    } catch (_) {
      throw CacheException();
    }
  }
}


// class FriendsLocalDsImpl implements FriendsLocalDS {
//   final SharedPreferences sharedPreferences;
//   FriendsLocalDsImpl({
//     required this.sharedPreferences
//   });
  

  // @override
  // Future<List<FriendsModel>> getFriendsByListIdLocal(FriendsIdsParams params) async{
  //   try{
  //     final jsonString = await sharedPreferences.getString('friendsByListId_${params.ids.join(',')}');
  //     if(jsonString == null || jsonString.isEmpty){
  //       throw CacheException('No data in catch');
  //     }
  //     final decodeJson = jsonDecode(jsonString) as List;
  //     return decodeJson.map((friend)=> FriendsModel.fromJson(friend)).toList();
  //   }
  //   catch(_){
  //     throw CacheException();
  //   }
  // }
  
// }