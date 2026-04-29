
import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/settings/domain/entities/user_profile_entities.dart';
import 'package:hellohive/feature/settings/userProfile_core/user_profile_core.dart';

abstract class UserProfileRepo {
  Future<Either<Failure,UserProfileEntities>> getUserProfileRepo(String UId);
  Future<Either<Failure,Unit>> addUserProfileRepo(UserProfParams params);
  Future<Either<Failure,Unit>> updateSingleUserProfileRepo(UserSingleParams params);
  Future<Either<Failure,Unit>> updateUserProfileRepo(UserProfParams params);
  Future<Either<Failure,Unit>> deleteUserProfileRepo(UserProfParams params);
  Stream<Either<Failure,UserStatusEntities>> getUserStatusRepo(String uId);
}