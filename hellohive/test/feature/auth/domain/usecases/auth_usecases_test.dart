import 'dart:convert';

import 'package:hellohive/core/usecases/usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:hellohive/feature/auth/domain/usecases/auth_usecases.dart';
import 'package:hellohive/feature/auth/domain/repositories/auth_repositories.dart';
import 'package:hellohive/feature/auth/auth_core/auth_usecase/auth_core_usecase.dart';
import 'package:hellohive/feature/auth/domain/entities/auth_entities.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixture/fixture.dart';
import 'auth_usecases_test.mocks.dart';

@GenerateMocks([AuthRepositories])
void main(){
  late MockAuthRepositories authRepositories;
  late SignInUsecase signInUsecase;
  late SignUpUsecase signUpUsecase;
  late SignOutUsecase signOutUsecase;
  late GetAuthUserUsecase getUserUsecase;
  late VerifyEmailUsecase verifyEmailUsecase;
  late EmailVerifiedUsecase emailVerifiedUsecase;

  setUp((){
    authRepositories = MockAuthRepositories();
    signInUsecase = SignInUsecase(authRepositories);
    signUpUsecase = SignUpUsecase(authRepositories);
    signOutUsecase = SignOutUsecase(authRepositories);
    getUserUsecase = GetAuthUserUsecase(authRepositories);
    verifyEmailUsecase = VerifyEmailUsecase(authRepositories);
    emailVerifiedUsecase = EmailVerifiedUsecase(authRepositories);

  });
    
    final params = AuthParams(email: "test@example.com", password: "password");
    final tauthRes = json.decode(Fixture('auth.json'));
    final tAuthEntities = AuthEntities(id: tauthRes['id'], email: tauthRes['email'], isEmailVerified: tauthRes['isEmailVerified']);

  test('sign in usecase test',() async{
    //arrange
    when(authRepositories.signInRepository(any))
      .thenAnswer((_) async =>Right(tAuthEntities));
    //act
    final result = await signInUsecase(params);
    //assert
    verify(authRepositories.signInRepository(params));
    expect(result , Right(tAuthEntities));
    verifyNoMoreInteractions(authRepositories);
  });
  test('sign up usecase test',() async{
    //arrange
    when(authRepositories.signUpRepository(any))
      .thenAnswer((_) async =>Right(tAuthEntities));
    //act
    final result = await signUpUsecase(params);
    //assert
    verify(authRepositories.signUpRepository(params));
    expect(result , Right(tAuthEntities));
    verifyNoMoreInteractions(authRepositories);
  });

    test('sign out usecase test',() async{
    //arrange
    final String tMessage = ("Successfully signed out");
    when(authRepositories.signOutRepository())
      .thenAnswer((_) async =>Right(tMessage));
    //act
    final result = await signOutUsecase(NoParams());
    //assert
    verify(authRepositories.signOutRepository());
    expect(result , Right(tMessage));
    verifyNoMoreInteractions(authRepositories);
  });

  test('getUser Uscase test',() async{
    //arrange 
    when(authRepositories.getAuthUser())
      .thenAnswer((_) async=>Right(tAuthEntities));
    //act
    final result = await getUserUsecase(NoParams());

    //assert
    verify(authRepositories.getAuthUser());
    expect(result, Right(tAuthEntities));
  });
  test('verify email when successful',()async{
    //arrange
    when(authRepositories.verifyEmail())
      .thenAnswer((_)async=>Right(unit));
    //act
    final result = await verifyEmailUsecase(NoParams());
    //assert
    verify(authRepositories.verifyEmail());
    expect(result, Right(unit));

  });

}