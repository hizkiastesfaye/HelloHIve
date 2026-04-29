
import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/usecases/usecase.dart';
import 'package:hellohive/feature/settings/domain/entities/user_profile_entities.dart';
import 'package:hellohive/feature/settings/domain/repositories/user_profile_repo.dart';
import 'package:hellohive/feature/settings/userProfile_core/user_profile_core.dart';

class GetUserProfileUsecase extends UseCase<UserProfileEntities,String>{
  final UserProfileRepo userProfileRepo;
  GetUserProfileUsecase(this.userProfileRepo);

  @override
  Future<Either<Failure,UserProfileEntities>> call(String uId){
    // print("#############################@@@@@@@@@@@@@@@@");

    return userProfileRepo.getUserProfileRepo(uId);
  }
}
class AddUserProfileUsecase extends UseCase<Unit,UserProfParams>{
  final UserProfileRepo userProfileRepo;
  AddUserProfileUsecase(this.userProfileRepo);

  @override
  Future<Either<Failure,Unit>> call(UserProfParams params){
    return userProfileRepo.addUserProfileRepo(params);
  }
}

class UpdateUserProfileUsecase extends UseCase<Unit,UserProfParams>{
  final UserProfileRepo userProfileRepo;

  UpdateUserProfileUsecase(this.userProfileRepo);
  @override
  Future<Either<Failure,Unit>> call(UserProfParams params){
    return userProfileRepo.updateUserProfileRepo(params);
  }
}

class UpdateSingleUserProfileUsecase extends UseCase<Unit,UserSingleParams>{
  final UserProfileRepo userProfileRepo;

  UpdateSingleUserProfileUsecase(this.userProfileRepo);
  @override
  Future<Either<Failure,Unit>> call(UserSingleParams params){
    return userProfileRepo.updateSingleUserProfileRepo(params);
  }
}

class DeletUserProfileUsecase extends UseCase<Unit,UserProfParams>{
  final UserProfileRepo userProfileRepo;

  DeletUserProfileUsecase(this.userProfileRepo);
  @override
  Future<Either<Failure,Unit>> call(UserProfParams params){
    return userProfileRepo.deleteUserProfileRepo(params);
  }
}

class GetUserStatusUsecase extends UseCaseStream<UserStatusEntities,String>{
  final UserProfileRepo userProfileRepo;
  GetUserStatusUsecase(this.userProfileRepo);

  @override
  Stream<Either<Failure,UserStatusEntities>> call(String uId){
    return userProfileRepo.getUserStatusRepo(uId);
  }
}