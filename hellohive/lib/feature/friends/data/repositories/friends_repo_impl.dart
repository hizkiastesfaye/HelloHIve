
import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/friends/domain/entities/friends_entities.dart';
import 'package:hellohive/feature/friends/domain/repositories/friends_repo.dart';
import 'package:hellohive/feature/friends/friends_core/friends_usecases_core.dart';
import '../datasources/friends_local_DS.dart';
import '../datasources/friends_remote_DS.dart';

import '../../../../core/network/netowork_info.dart';

class FriendsRepoImpl implements FriendsRepo {
  final NetworkInfo networkInfo;
  final FriendsRemoteDS friendsRemote;
  final FriendsLocalDS friendsLocal;

  FriendsRepoImpl({
    required this.networkInfo,
    required this.friendsLocal,
    required this.friendsRemote
  });

  @override
  Future<Either<Failure, List<FriendsEntities>>> getFriends(FriendsParams params) async{
    if(await networkInfo.isConnected){
      try{
        final getFriendsResult = await friendsRemote.getFriendsRemote(params);
        friendsLocal.cacheFriendsLocal(getFriendsResult);
        return Right(getFriendsResult);
      } on ServerException catch(e){
        return Left(ServerFailure(e.message));
      }  on UnknownException catch(e){
        return Left(UnknownFailure(e.message));
      } catch(_){
        return Left(UnknownFailure());
      }
    }
    else{
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<FriendsEntities>>> getRandomFriends() async{
    if(await networkInfo.isConnected){
      try{
        final getFriendsResult = await friendsRemote.getRandomFriendsRemote();
        friendsLocal.cacheRandomFriends(getFriendsResult);
        return Right(getFriendsResult);
      } on ServerException catch(e){
        return Left(ServerFailure(e.message));
      }  on UnknownException catch(e){
        return Left(UnknownFailure(e.message));
      } catch(_){
        return Left(UnknownFailure());
      }
    }
    else{
      try{
        return Right(await friendsLocal.getCachedRandomFriends());
      } on CacheException catch(e){
        return Left(CacheFailure(e.message));
      } catch (_){
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure,FriendsEntities>> getFriend(FriendParams params) async{
    if(await networkInfo.isConnected){
      try{
        final getFriendResult = await friendsRemote.getFriendRemote(params);
        friendsLocal.cacheFriendLocal(getFriendResult);
        return Right(getFriendResult);
      } on ServerException catch(e){
        return Left(ServerFailure(e.message));
      }  on UnknownException catch(e){
        return Left(UnknownFailure(e.message));
      } catch(_){
        return Left(UnknownFailure());
      }
    }
    else{
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<FriendsEntities>>> getFriendsByListId(
    FriendsIdsParams params,
  ) async {
    try {
      // Try local cache first
      final localFriends =
          await friendsLocal.getFriendsByListIdLocal(params);

      final localIds = localFriends.map((e) => e.uId).toSet();

      final missingIds = params.friendsIds
          .where((id) => !localIds.contains(id))
          .toList();

      if (missingIds.isEmpty) {
        return Right(localFriends);
      }

      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      final remoteFriends = await friendsRemote.getFriendsByListIdRemote(
        FriendsIdsParams(friendsIds: missingIds),
      );

      await friendsLocal.cacheFriendsLocal(remoteFriends);

      return Right([
        ...localFriends,
        ...remoteFriends,
      ]);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(e.message));
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

}