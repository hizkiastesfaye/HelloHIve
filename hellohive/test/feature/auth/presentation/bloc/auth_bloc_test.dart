import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/auth/auth_core/auth_usecase/auth_core_usecase.dart';
import 'package:hellohive/feature/auth/domain/entities/auth_entities.dart';
import 'package:hellohive/feature/auth/domain/repositories/auth_repositories.dart';
import 'package:hellohive/feature/auth/domain/usecases/auth_usecases.dart';
import 'package:hellohive/feature/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../../../fixture/fixture.dart';
import 'auth_bloc_test.mocks.dart';
@GenerateMocks([
  SignInUsecase,
  SignUpUsecase,
  SignOutUsecase,
  EmailVerifiedUsecase,
  VerifyEmailUsecase,
  ResetPasswordUsecase,
])

void main(){
 late MockSignInUsecase mockSignInUsecase;
 late MockSignUpUsecase mockSignUpUsecase;
 late MockSignOutUsecase mockSignOutUsecase;
 late MockVerifyEmailUsecase mockVerifyEmailUsecase;
 late MockEmailVerifiedUsecase mockEmailVerifiedUsecase;
 late MockResetPasswordUsecase mockResetPasswordUsecase;
 late AuthBloc authBloc;

 setUp((){
    mockSignInUsecase = MockSignInUsecase();
    mockSignUpUsecase = MockSignUpUsecase();
    mockSignOutUsecase = MockSignOutUsecase();
    mockVerifyEmailUsecase = MockVerifyEmailUsecase();
    mockEmailVerifiedUsecase = MockEmailVerifiedUsecase();
    mockResetPasswordUsecase = MockResetPasswordUsecase();
    authBloc = AuthBloc(
      signInUsecase: mockSignInUsecase,
      signUpUsecase: mockSignUpUsecase,
      signOutUsecase: mockSignOutUsecase,
      verifyEmailUsecase: mockVerifyEmailUsecase,
      emailVerifiedUsecase: mockEmailVerifiedUsecase,
      resetPasswordUsecase: mockResetPasswordUsecase,
      
    );
  });
    final tAuthRes = json.decode(Fixture('auth.json'));
    final tAuthEntity = AuthEntities(
      id: tAuthRes['id'], 
      email: tAuthRes['email'], 
      isEmailVerified: tAuthRes['isEmailVerified']
    );
    final AuthParams tparams = AuthParams(
      email: tAuthRes['email'], 
      password: 'password'
    );
  test('initial state should be AuthInitial', (){
    //assert
    expect(authBloc.state, equals(AuthInitial()));
  });

  group('SignUp',(){
    test('should return AuthEntities when successful',() async{
      when(mockSignUpUsecase(any))
        .thenAnswer((_) async=> Right(tAuthEntity));
      //act
      authBloc.add(SignUpEvent(email: tAuthRes['email'], password: tparams.password));
      await untilCalled(mockSignUpUsecase(any));
      //assert
      verify(mockSignUpUsecase(tparams));
    });
    blocTest<AuthBloc, AuthState>(
      'emits [MyState] when MyEvent is added.',
      build: () {
        when(mockSignUpUsecase(any))
          .thenAnswer((_) async=> Right(tAuthEntity));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpEvent(email: tAuthRes['email'], password: tparams.password)),
      expect: () => [
        AuthLoading(),
        AuthSignedUpState(authEntities: tAuthEntity)
      ],
      verify:(_){
        verify(mockSignUpUsecase(tparams));
      }
    );
    blocTest('emits [AuthLoading, AuthError] when sign up fails',
      build: (){
        when(mockSignUpUsecase(any))
          .thenAnswer((_) async=> Left(ServerFailure('Server Failure')));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpEvent(email: tAuthRes['email'], password: tparams.password)),
      expect: () => [
        AuthLoading(),
        AuthError('Server Failure')
      ],
      verify:(_){
        verify(mockSignUpUsecase(tparams));
      }
    );
  });

}