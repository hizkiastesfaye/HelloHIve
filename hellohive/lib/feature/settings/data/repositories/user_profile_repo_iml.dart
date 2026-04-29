
import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/network/netowork_info.dart';
import 'package:hellohive/feature/settings/data/dataSources/user_profile_local.dart';
import 'package:hellohive/feature/settings/data/dataSources/user_profile_remote.dart';
import 'package:hellohive/feature/settings/data/models/user_profile_models.dart';
import 'package:hellohive/feature/settings/domain/repositories/user_profile_repo.dart';

import '../../domain/entities/user_profile_entities.dart';
import '../../userProfile_core/user_profile_core.dart';
import 'dart:async';

class UserProfileRepoImpl implements UserProfileRepo{
  final NetworkInfo networkInfo;
  final UserProfileRemote userProfileRemote;
  final UserProfileLocal userProfileLocal;

  UserProfileRepoImpl(
    {
      required this.networkInfo, 
      required this.userProfileRemote, 
      required this.userProfileLocal
    }
  );
  
  @override
  Future<Either<Failure,UserProfileEntities>> getUserProfileRepo(String uId)async{
    if(await networkInfo.isConnected){
      try{
        final getUserProfileResult = await userProfileRemote.getUserProfileRemote(uId);
        userProfileLocal.cacheUserProfileLocal(getUserProfileResult);

        return Right(getUserProfileResult);
      } on ServerException catch(e){
        // print("@@@@@@@@@@@@@@@@");
        // print("@@@@@@@@@@@@@@@@");   
        return Left(ServerFailure(e.message));
      } on UnknownException catch(e){
        // print("#############################");
        // print("#############################");   
        return Left(UnknownFailure(e.message));
      }
    }
    else{
      try{  
        return Right(await userProfileLocal.getUserProfileLocal());
      } on CacheException catch(e){
        return Left(CacheFailure(e.message));
      } catch(_){
        return Left(UnknownFailure());
      }
    }
  }
  @override
  Future<Either<Failure,Unit>> addUserProfileRepo(UserProfParams params)async{
    if(await networkInfo.isConnected){
      try{
        final addUserProfileResult = await userProfileRemote.addUserProfileRemote(params);
        return Right(addUserProfileResult);
      } on ServerException catch(e){
        return Left(ServerFailure(e.message));
      } catch (_){
        return Left(UnknownFailure());
      }
    }
    else{
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure,Unit>> updateSingleUserProfileRepo(UserSingleParams params)async{
    if(await networkInfo.isConnected){
      try{
        final updateSingleUserProfileResult = await userProfileRemote.updateSingleUserProfileRemote(params);
        return Right(updateSingleUserProfileResult);
      } on ServerException catch(e){
        return Left(ServerFailure(e.message));
      } catch (_){
        return Left(UnknownFailure());
      }
    }
    else{
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure,Unit>> updateUserProfileRepo(UserProfParams params)async{
    if(await networkInfo.isConnected){
      try{
        final updateUserProfileResult = await userProfileRemote.updateUserProfileRemote(params);
        return Right(updateUserProfileResult);
      } on ServerException catch(e){
        return Left(ServerFailure(e.message));
      } catch (_){
        return Left(UnknownFailure());
      }
    }
    else{
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure,Unit>> deleteUserProfileRepo(UserProfParams params)async{
    if(await networkInfo.isConnected){
      try{
        final deleteUserProfileResult = await userProfileRemote.deleteUserProfileRemote(params);
        return Right(deleteUserProfileResult);
      } on ServerException catch(e){
        return Left(ServerFailure(e.message));
      } catch (_){
        return Left(UnknownFailure());
      }
    }
    else{
      return Left(NetworkFailure());
    }
  }
  @override
  Stream<Either<Failure, UserStatusEntities>> getUserStatusRepo(String uId) async* {
    try {
        // 1. Listen to the remote source
        // Using 'await for' ensures we handle every event coming from the remote stream
        await for (final status in userProfileRemote.getUserStatusRemote(uId)) {
          
          // 2. Side Effect: Cache the data locally
          await userProfileLocal.cacheUserStatusLocal(status);
          
          // 3. Emit the successful data wrapped in 'Right'
          yield Right<Failure, UserStatusEntities>(status);
        }
      } catch (error) {
        // 4. Recovery: If remote fails, try the local database
        try {
          final localData = await userProfileLocal.getUserStatusLocal();
          
          // 5. This 'yield' is the key! It pushes data into the stream 
          // even though an error occurred previously.
          yield Right<Failure, UserStatusEntities>(localData);
        } 
        catch (e) {
            // 6. Total Failure: If local also fails, emit the Left failure
            yield Left<Failure, UserStatusEntities>(
              CacheFailure("Local storage empty or unavailable"),
            );
        }
    }
}


//?   Stream.handleError is a "swallow" mechanism, not a "map" mechanism. ### The Problem
//? In Dart's standard handleError method, if you return a value, the stream ignores it. It only allows you to do two things:
//? Throw a new error: (to change the type of error).
//? Do nothing: (to suppress the error).
  // Stream<Either<Failure, UserStatusEntities>> getUserStatusRepo(String uId) {
  //   return userProfileRemote.getUserStatusRemote(uId)
  //     .asyncMap<Either<Failure, UserStatusEntities>>((status) async {
  //       // 1. This is safe! It waits for the DB before moving to the next item.
  //       await userProfileLocal.cacheUserStatusLocal(status);
  //       return Right(status); 
  //     })
  //     .handleError((error) async {
  //       // 2. This also waits for the DB if an error happens.
  //       try {
  //         final localData = await userProfileLocal.getUserStatusLocal();
  //         return Right(localData);
  //       } catch (e) {
  //         return Left(CacheFailure("Local storage empty"));
  //       }
  //     }
  //   );
  // }


  //?The problem with below code is async inside handleData or handleError of a StreamTransformer 
  //?is that the Sink is not designed to wait. If a second error arrives while your 
  //?first await is still fetching local data, the order of your results could get 
  //?mixed up (a "race condition").
  //!If you remove async, you can't talk to your database properly even the transformer runs instantly as data arrives.
  //!If you keep async, you risk the data getting mixed up.

  // Stream<Either<Failure, UserStatusEntities>> getUserStatusRepo(String uId) {
  //   return userProfileRemote.getUserStatusRemote(uId)
  //     .transform(
  //       StreamTransformer<UserStatusModels,
  //           Either<Failure, UserStatusEntities>>.fromHandlers(
  //         handleData: (status, sink) {
  //           userProfileLocal.cacheUserStatusLocal(status);
  //           sink.add(Right(status)); // ✔ no mapping needed
  //         },
  //         handleError: (error, stackTrace, sink) async {
  //           try {
  //             final localData =
  //                 await userProfileLocal.getUserStatusLocal();
  //             sink.add(Right(localData));
  //           } catch (_) {
  //             sink.add(
  //               Left(CacheFailure("Local data also unavailable")),
  //             );
  //           }
  //         },
  //       ),
  //     );
  // }
  


}