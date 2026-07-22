import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/friends/friends_core/friends_usecases_core.dart';

abstract class FriendSyncRepository {
  Future<Either<Failure, Unit>> syncFriends(
    FriendsIdsParams params,
  );

  Future<Either<Failure, Unit>> dispose();
}