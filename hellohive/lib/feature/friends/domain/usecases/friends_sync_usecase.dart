

import 'package:dartz/dartz.dart';
import 'package:hellohive/feature/friends/domain/repositories/friend_sync_repo.dart';
import 'package:hellohive/feature/friends/friends_core/friends_usecases_core.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';


class SyncFriendsUseCase
    extends UseCase<Unit, FriendsIdsParams> {

  final FriendSyncRepository repository;

  SyncFriendsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(
    FriendsIdsParams params,
  ) {
    return repository.syncFriends(params);
  }
}

class DisposeFriendSyncUseCase
    extends UseCase<Unit, NoParams> {

  final FriendSyncRepository repository;

  DisposeFriendSyncUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(
    NoParams params,
  ) {
    return repository.dispose();
  }
}