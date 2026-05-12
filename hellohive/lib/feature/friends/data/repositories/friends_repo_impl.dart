
import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/friends/domain/entities/friends_entities.dart';
import 'package:hellohive/feature/friends/domain/repositories/friends_repo.dart';
import 'package:hellohive/feature/friends/friends_core/friends_usecases_core.dart';

class FriendsRepoImpl implements FriendsRepo {
  final NetworkInfo networkInfo;
  final FriendsRemote friendsRemote;
  final FriendsLocal friendsLocal;
  @override
  Future<Either<Failure, List<FriendsEntities>>> getFriends(FriendsParams params) {
    // TODO: Implement getFriends
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<FriendsEntities>>> getRandomFriends() {
    // TODO: Implement getRandomFriends
    throw UnimplementedError();
  }
}