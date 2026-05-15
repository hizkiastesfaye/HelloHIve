
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/usecases/usecase.dart';
import 'package:hellohive/feature/friends/friends_core/friends_usecases_core.dart';

import '../entities/friends_entities.dart';
import '../repositories/friends_repo.dart';

class GetFriendsUseCases extends UseCase<List<FriendsEntities>,FriendsParams>{
  final FriendsRepo friendsRepo;
  GetFriendsUseCases(this.friendsRepo);
  @override
  Future<Either<Failure, List<FriendsEntities>>> call(FriendsParams params) {
    return friendsRepo.getFriends(params);
  }
}

class GetRandomFriendsUseCases extends UseCase<List<FriendsEntities>,NoParams>{
  final FriendsRepo friendsRepo;
  GetRandomFriendsUseCases(this.friendsRepo);
  @override
  Future<Either<Failure, List<FriendsEntities>>> call(NoParams params) {
    return friendsRepo.getRandomFriends();
  }
}