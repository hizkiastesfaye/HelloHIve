import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/friends/data/datasources/friends_sync_service.dart';
import 'package:hellohive/feature/friends/domain/repositories/friend_sync_repo.dart';
import 'package:hellohive/feature/friends/friends_core/friends_usecases_core.dart';

class FriendSyncRepositoryImpl
    implements FriendSyncRepository {

  final FriendSyncService syncService;

  FriendSyncRepositoryImpl({
    required this.syncService,
  });

  @override
  Future<Either<Failure, Unit>> syncFriends(
    FriendsIdsParams params,
  ) async {
    try {
      await syncService.syncFriends(
        params.friendsIds,
      );

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> dispose() async {
    try {
      await syncService.dispose();

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}