import '../repositories/auth_repositories.dart';
import '../entities/auth_entities.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../auth_core/auth_usecase/auth_core_usecase.dart';
import '../../../../core/usecases/usecase.dart';

class SignInUsecase extends UseCase<AuthEntities, AuthParams>{
  final AuthRepositories repositories;
  SignInUsecase(this.repositories);

  @override
  Future<Either<Failure, AuthEntities>> call(AuthParams params) {
    return repositories.signInRepository(params);
  }
}

class SignUpUsecase extends UseCase<AuthEntities,AuthParams>{
  final AuthRepositories repositories;
  SignUpUsecase(this.repositories);

  @override
  Future<Either<Failure, AuthEntities>> call(AuthParams params) {
    return repositories.signUpRepository(params);
  }
}

class SignOutUsecase extends UseCase<String, NoParams>{
  final AuthRepositories repositories;
  SignOutUsecase(this.repositories);

  @override
  Future<Either<Failure,String>> call(NoParams noParams){
    return repositories.signOutRepository();
  }
}

class GetAuthUserUsecase extends UseCase<AuthEntities,NoParams>{
  final AuthRepositories repositories;
  GetAuthUserUsecase(this.repositories);

  @override
  Future<Either<Failure,AuthEntities>> call(NoParams noParams){
    return repositories.getAuthUser();
  }
}

class VerifyEmailUsecase extends UseCase<Unit, NoParams>{
  final AuthRepositories repositories;
  VerifyEmailUsecase(this.repositories);
  @override
  Future<Either<Failure,Unit>> call(NoParams noParams){
    return repositories.verifyEmail();
  }
}

class EmailVerifiedUsecase extends UseCase<Unit, NoParams>{
  final AuthRepositories repositories;
  EmailVerifiedUsecase(this.repositories);
  @override
  Future<Either<Failure,Unit>> call(NoParams noParams){
    return repositories.emailVerified();
  }
}

class ResetPasswordUsecase extends UseCase<Unit,String>{
  final AuthRepositories repositories;
  ResetPasswordUsecase(this.repositories);
  @override
  Future<Either<Failure,Unit>> call(String email){
    return repositories.resetPassword(email);
  }
}

class UpdatePasswordUsecase extends UseCase<Unit,String>{
  final AuthRepositories repositories;
  UpdatePasswordUsecase(this.repositories);

  @override
  Future<Either<Failure,Unit>> call(String password){
    return repositories.updatePassword(password);
  }
}