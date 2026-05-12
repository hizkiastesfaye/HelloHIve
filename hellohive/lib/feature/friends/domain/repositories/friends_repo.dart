

import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/friends/domain/entities/friends_entities.dart';
import 'package:hellohive/feature/friends/friends_core/friends_usecases_core.dart';

abstract class FriendsRepo {
  Future<Either<Failure, List<FriendsEntities>>> getFriends(FriendsParams params);
  Future<Either<Failure, List<FriendsEntities>>> getRandomFriends();
}