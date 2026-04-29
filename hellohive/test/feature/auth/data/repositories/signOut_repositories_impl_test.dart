import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hellohive/feature/auth/auth_core/auth_usecase/auth_core_usecase.dart';
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

  test('should signout successfully', () async{
    //arrange
    when(mockRemoteDataSource.signOutRemoteDataSource())
      .thenAnswer((_) async => Future.value());
    //act
    final result = await repositories.signOutRepository();
    //assert
    verify(mockRemoteDataSource.signOutRemoteDataSource());
    expect(result, Right('Sign out successful'));
  });
  test('should return ServerFailure when sign out fails', () async{
    //arrange
    when(mockRemoteDataSource.signOutRemoteDataSource())
      .thenThrow(ServerException());
    //act
    final result = await repositories.signOutRepository();
    //assert
    verify(mockRemoteDataSource.signOutRemoteDataSource());
    expect(result, Left(ServerFailure()));
  });
}