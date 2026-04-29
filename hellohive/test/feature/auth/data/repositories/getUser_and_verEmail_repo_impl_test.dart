

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/network/netowork_info.dart';
import 'package:hellohive/feature/auth/auth_core/auth_usecase/auth_core_usecase.dart';
import 'package:hellohive/feature/auth/data/dataSources/auth_remote_data_source.dart';
import 'package:hellohive/feature/auth/data/models/auth_models.dart';
import 'package:hellohive/feature/auth/data/repositories/auth_repositories_impl.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixture/fixture.dart';
import 'signIn_repositories_impl_test.mocks.dart';
void main(){
  late MockNetworkInfo networkInfo;
  late MockAuthRemoteDataSource authRemoteDataSource;
  late AuthRepositoriesImpl authRepositoriesImpl;

  setUp((){
    networkInfo = MockNetworkInfo();
    authRemoteDataSource = MockAuthRemoteDataSource();
    authRepositoriesImpl = AuthRepositoriesImpl(
      networkInfo: networkInfo, 
      remoteDataSource: authRemoteDataSource
    );
  });

  final tAuthRes = json.decode(Fixture('auth.json'));

  final tAuthModels = AuthModels(
    id: tAuthRes['id'], 
    email: tAuthRes['email'], 
    isEmailVerified: tAuthRes['isEmailVerified']
  );
    final tAuthEntities = tAuthModels;
  group('GetUser repository',(){
    test('should return tAuth Entities when successful',()async{
    //arrange
    when(authRemoteDataSource.getAuthUserDataSource())
      .thenAnswer((_)async=>tAuthModels);
    //act
    final result = await authRepositoriesImpl.getAuthUser();
    //assert
    verify(authRemoteDataSource.getAuthUserDataSource());
    expect(result, Right(tAuthEntities));
    });
    test('should return ServerFailure when call to remote data source is unsuccessful', () async{
      //arrange
      String errorMessage = 'failed to get user.';
      when(authRemoteDataSource.getAuthUserDataSource())
        .thenThrow(AuthException(errorMessage));
      //act
      final result = await authRepositoriesImpl.getAuthUser();
      //assert
      verify(authRemoteDataSource.getAuthUserDataSource());
      expect(result, equals(Left(AuthFailure(errorMessage))));
    });
  });

  group('verify email repository',(){
    
    test('should return unit when verifyEmail successful',()async{
      //arrange
      when(authRemoteDataSource.verifyEmailDataSource())
        .thenAnswer((_) async=> unit);
      when(networkInfo.isConnected)
        .thenAnswer((_) async=> true);
      //act
      final result = await authRepositoriesImpl.verifyEmail();
      //assert
      verify(authRemoteDataSource.verifyEmailDataSource());
      expect(result,Right(unit));
    });
  });
}