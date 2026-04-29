
import 'package:dartz/dartz.dart';
import 'package:hellohive/feature/settings/data/models/user_profile_models.dart';

abstract class UserProfileLocal {
  Future<Unit>cacheUserProfileLocal(UserProfileModels userProfileModels);
  Future<UserProfileModels>getUserProfileLocal();
  Future<Unit>cacheUserStatusLocal(UserStatusModels userStatusModels);
  Future<UserStatusModels>getUserStatusLocal();
}

class UserProfileLocalImpl implements UserProfileLocal{
  final Map<String, dynamic> localStorage = {};

  @override
  Future<Unit> cacheUserProfileLocal(UserProfileModels userProfileModels) async {
    localStorage['userProfile'] = userProfileModels.toJson();
    return Future.value(unit);
  }

  @override
  Future<UserProfileModels> getUserProfileLocal() async {
    final data = localStorage['userProfile'];
    if(data != null){
      return Future.value(UserProfileModels.fromJson(data));
    } else {
      throw Exception('No cached user profile found');
    }
  }

  @override
  Future<Unit> cacheUserStatusLocal(UserStatusModels userStatusModels) async {
    localStorage['userStatus'] = userStatusModels.toJson();
    return Future.value(unit);
  }

  @override
  Future<UserStatusModels> getUserStatusLocal() async {
    final data = localStorage['userStatus'];
    if(data != null){
      return Future.value(UserStatusModels.fromJson(data));
    } else {
      throw Exception('No cached user status found');
    }
  }
}