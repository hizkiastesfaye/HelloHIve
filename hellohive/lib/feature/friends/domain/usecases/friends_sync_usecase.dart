import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/usecases/usecase.dart';
import 'package:hellohive/feature/friends/domain/repositories/friend_sync_repo.dart';

class SyncFriendsUseCase extends UseCase<Unit, NoParams> {

  final FriendsSyncRepository repository;

  SyncFriendsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(
    NoParams params,
  ) {
    return repository.syncFriends();
  }
}

class DisposeFriendSyncUseCase extends UseCase<Unit, NoParams> {

  final FriendsSyncRepository repository;

  DisposeFriendSyncUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(
    NoParams params,
  ) {
    return repository.dispose();
  }
}