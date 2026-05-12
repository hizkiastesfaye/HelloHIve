
import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/friends/data/models/friends_model.dart';

import '../../friends_core/friends_usecases_core.dart';

abstract class FriendsRemoteDS {
  Future<Either<Failure, List<FriendsModel>>> getFriendsRemote(FriendsParams params);
  Future<Either<Failure, List<FriendsModel>>> getRandomFriendsRemote();
}