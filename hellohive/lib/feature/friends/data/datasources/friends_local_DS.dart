

import 'package:hellohive/core/errors/failure.dart';

abstract class FriendsLocalDS {
  Future<void> cacheFriends(List<FriendsModel> friendsToCache);
  Future<Either<Failure, List<FriendsModel>>> getCachedFriends();
}