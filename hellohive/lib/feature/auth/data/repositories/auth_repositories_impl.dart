import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/auth/domain/entities/auth_entities.dart';
import 'package:hellohive/feature/auth/domain/repositories/auth_repositories.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/network/netowork_info.dart';
import '../../auth_core/auth_usecase/auth_core_usecase.dart';
import '../dataSources/auth_remote_data_source.dart';

class AuthRepositoriesImpl implements AuthRepositories{
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoriesImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  }); 
  @override
  Future<Either<Failure, String>> signOutRepository() async{
    try{
      await remoteDataSource.signOutRemoteDataSource();
      return Right('Sign out successful');
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
        return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, AuthEntities>> signInRepository(AuthParams params) async {
    if (await networkInfo.isConnected){
      try{
      final authRes = await remoteDataSource.signInRemoteDataSource(params);
      return Right(authRes);
      } on AuthException catch(e){
        return Left(AuthFailure(e.message));
      } on VerifyException{
        return Left(VerifyFailure());
      } on ServerException {
        return Left(ServerFailure());
      } catch (_) {
        return Left(UnknownFailure());
      }
    }
    else{
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthEntities>> signUpRepository(AuthParams params) async {
    if(await networkInfo.isConnected){
      try{
        final authRes = await remoteDataSource.signUpRemoteDataSource(params);
        return Right(authRes);
      } on AuthException catch (e){
        return Left(AuthFailure(e.message));
      } on ServerException {
        return Left(ServerFailure());
      } catch (_) {
        return Left(UnknownFailure());
      }
    }
    else{
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure,AuthEntities>> getAuthUser()async {
    try{
      final result = await remoteDataSource.getAuthUserDataSource();
      return Right(result);
    } on AuthException catch (e){
      return Left(AuthFailure(e.message));
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  Future<Either<Failure,Unit>> verifyEmail()async{
    if(await networkInfo.isConnected){
      try{
        final result = await remoteDataSource.verifyEmailDataSource();
        return Right(result);
      } on AuthException catch (e){
        return Left(AuthFailure(e.message));
      } catch (_){
        return Left(UnknownFailure());
      }
    }
    else{
      return Left(NetworkFailure());
    }
  }
  Future<Either<Failure,Unit>> emailVerified()async{
    if(await networkInfo.isConnected){
      try{
        final result = await remoteDataSource.emailVerifiedDataSource();
        return Right(result);
      } on AuthException catch (e){
        return Left(AuthFailure(e.message));
      } catch (e){
        return Left(UnknownFailure(e.toString()));
      }
    }
    else{
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure,Unit>> resetPassword(String email)async{
    if(await networkInfo.isConnected){
      try{
        final resetPasswordResult = await remoteDataSource.resetPasswordDataSource(email);
        return Right(unit);
      } on AuthException catch (e){
          return Left(AuthFailure(e.message));
      } on ServerException {
        return Left(ServerFailure());
      } catch (_){
        return Left(UnknownFailure());
      }
    }
    else{
      return Left(NetworkFailure());
    }
    
  }@override
  Future<Either<Failure,Unit>>updatePassword(String password) async{
    if(await networkInfo.isConnected){
      try{
        final UpdatePasswordResult = await remoteDataSource.updatePasswordDatasource(password);
        return Right(unit);
      } on AuthException catch (e){
          return Left(AuthFailure(e.message));
      } on ServerException {
        return Left(ServerFailure());
      } catch (_){
        return Left(UnknownFailure());
      }
    }
    else{
      return Left(NetworkFailure());
    }
  }

}