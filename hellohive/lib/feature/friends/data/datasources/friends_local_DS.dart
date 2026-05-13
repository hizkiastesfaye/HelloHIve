
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/feature/friends/data/models/friends_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FriendsLocalDS {
  Future<Unit> cacheRandomFriends(List<FriendsModel> friendsToCache);
  Future<List<FriendsModel>> getCachedRandomFriends();
}

class FriendsLocalDsImpl implements FriendsLocalDS {
  final SharedPreferences sharedPreferences;
  FriendsLocalDsImpl({
    required this.sharedPreferences
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
  
}