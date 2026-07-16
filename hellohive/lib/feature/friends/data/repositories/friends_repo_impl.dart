
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
        // friendsLocal.cacheFriend(getFriendsResult);
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

      if (localFriends.isNotEmpty) {
        return Right(localFriends);
      }

      // Cache is empty, check internet
      if (await networkInfo.isConnected) {
        final remoteFriends =
            await friendsRemote.getFriendsByListIdRemote(params);

        await friendsLocal.cacheFriendsByListIdLocal(remoteFriends);

        return Right(remoteFriends);
      }

      return Left(NetworkFailure());
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