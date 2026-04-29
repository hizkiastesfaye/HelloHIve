import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/auth/auth_core/auth_usecase/auth_core_usecase.dart';
import 'package:hellohive/feature/auth/domain/entities/auth_entities.dart';

abstract class AuthRepositories{
  Future<Either<Failure, AuthEntities>> signInRepository(AuthParams params);
  Future<Either<Failure, AuthEntities>> signUpRepository(AuthParams params);
  Future<Either<Failure, String>> signOutRepository();
  Future<Either<Failure, AuthEntities>>getAuthUser();
  Future<Either<Failure, Unit>>verifyEmail();
  Future<Either<Failure,Unit>>emailVerified();
  Future<Either<Failure,Unit>>resetPassword(String email);
  Future<Either<Failure,Unit>>updatePassword(String password);
}