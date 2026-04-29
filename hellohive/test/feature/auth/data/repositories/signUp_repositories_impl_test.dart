import 'dart:convert';

import 'package:hellohive/feature/auth/auth_core/auth_usecase/auth_core_usecase.dart';
import 'package:hellohive/feature/auth/data/models/auth_models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/network/netowork_info.dart';
import 'package:hellohive/feature/auth/data/dataSources/auth_remote_data_source.dart';
import 'package:hellohive/feature/auth/data/repositories/auth_repositories_impl.dart';
import 'package:hellohive/feature/auth/domain/entities/auth_entities.dart';
import 'package:dartz/dartz.dart';

import '../../../../fixture/fixture.dart';
import 'signIn_repositories_impl_test.mocks.dart';

// @GenerateMocks([NetworkInfo, AuthRemoteDataSource])
void main(){
  late MockNetworkInfo mockNetworkInfo;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late AuthRepositoriesImpl repositories;

  setUp((){
  mockNetworkInfo = MockNetworkInfo();
  mockRemoteDataSource = MockAuthRemoteDataSource();
  repositories = AuthRepositoriesImpl(
    networkInfo: mockNetworkInfo, 
    remoteDataSource: mockRemoteDataSource
  );
  });
  final tAuthRes = json.decode(Fixture('auth.json'));
  final AuthParams tparams = AuthParams(email: tAuthRes['email'], password: 'password');

  final tAuthModels = AuthModels(
    id: tAuthRes['id'], 
    email: tAuthRes['email'], 
    isEmailVerified: tAuthRes['isEmailVerified']
  );
    final tAuthEntities = tAuthModels;
  void setupNetworkConnected(){
    when(mockNetworkInfo.isConnected)
      .thenAnswer((_) async => true);
  }
  test('should check if the device is online', () async{
    //arrange
    setupNetworkConnected();
    when(mockRemoteDataSource.signUpRemoteDataSource(any))
      .thenAnswer((_) async => tAuthModels);
    //act
    repositories.signUpRepository(tparams);
    //assert
    verify(mockNetworkInfo.isConnected);
  });

  group('sign up repository test', (){
    test('should return AuthEntities when call to remote data source is successful', () async{
      //arrange
      setupNetworkConnected();
      when(mockRemoteDataSource.signUpRemoteDataSource(any))
        .thenAnswer((_) async => tAuthModels);

      //act
      final result = await repositories.signUpRepository(tparams);
      print('--------------------------------------');
      print('--- $result ----');
      print('--------------------------------------');
      //assert
      verify(mockRemoteDataSource.signUpRemoteDataSource(tparams));
      expect(result, equals(Right(tAuthEntities)));
    });

    test('should return ServerFailure when call to remote data source is unsuccessful', () async{
      //arrange
      setupNetworkConnected();
      when(mockRemoteDataSource.signUpRemoteDataSource(any))
        .thenThrow(ServerException());
      //act
      final result = await repositories.signUpRepository(tparams);
      //assert
      verify(mockRemoteDataSource.signUpRemoteDataSource(tparams));
      expect(result, equals(Left(ServerFailure())));
    });
    test('should return AuthFailure when call to remote data source is unsuccessful', () async{
      //arrange
      setupNetworkConnected();
      when(mockRemoteDataSource.signUpRemoteDataSource(any))
        .thenThrow(AuthException('User already registered'));
      //act
      final result = await repositories.signUpRepository(tparams);
      //assert
      verify(mockRemoteDataSource.signUpRemoteDataSource(tparams));
      expect(result, equals(Left(AuthFailure('User already registered'))));
    });

    test('should return NetworkFailure when call to remote data source is unsuccessful', () async{
      //arrange
      when(mockNetworkInfo.isConnected)
        .thenAnswer((_) async => false);
      //act
      final result = await repositories.signUpRepository(tparams);
      //assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockNetworkInfo.isConnected);
      expect(result, equals(Left(NetworkFailure())));
    });
  });
}