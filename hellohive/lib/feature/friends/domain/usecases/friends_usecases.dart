
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

class GetFriendUseCases extends UseCase<FriendsEntities,FriendParams>{
  final FriendsRepo friendsRepo;
  GetFriendUseCases(this.friendsRepo);
  @override
  Future<Either<Failure, FriendsEntities>> call(FriendParams params){
    return friendsRepo.getFriend(params);
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

class GetFriendsByListIdUsecases extends UseCase<List<FriendsEntities>,FriendsIdsParams>{
  final FriendsRepo friendsRepo;
  GetFriendsByListIdUsecases(this.friendsRepo);
    @override
  Future<Either<Failure, List<FriendsEntities>>> call(FriendsIdsParams params) {
    return friendsRepo.getFriendsByListId(params);
  }
}