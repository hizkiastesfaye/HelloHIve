import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/network/netowork_info.dart';
import 'package:hellohive/feature/settings/data/dataSources/user_profile_local.dart';
import 'package:hellohive/feature/settings/data/dataSources/user_profile_remote.dart';
import 'package:hellohive/feature/settings/data/models/user_profile_models.dart';
import 'package:hellohive/feature/settings/data/repositories/user_profile_repo_iml.dart';
import 'package:hellohive/feature/settings/domain/entities/user_profile_entities.dart';
import 'package:hellohive/feature/settings/domain/repositories/user_profile_repo.dart';
import 'package:hellohive/feature/settings/userProfile_core/user_profile_core.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture.dart';
import 'get_user_profile_repo_test.mocks.dart';

// @GenerateMocks([], customMocks: [
//   MockSpec<NetworkInfo>(as: #MockNetworkInfo),
//   MockSpec<UserProfileRemote>(as: #MockUserProfileRemote),
//   MockSpec<UserProfileLocal>(as: #MockUserProfileLocal),
//   MockSpec<UserProfileRepo>(as: #MockUserProfileRepo),
// ])

void main(){
  late MockNetworkInfo mockNetworkInfo;
  late MockUserProfileRemote mockUserProfileRemote;
  late MockUserProfileLocal mockUserProfileLocal;
  late UserProfileRepoImpl userProfileRepoImpl;

  setUp((){
    mockNetworkInfo = MockNetworkInfo();
    mockUserProfileRemote = MockUserProfileRemote();
    mockUserProfileLocal = MockUserProfileLocal();
    userProfileRepoImpl = UserProfileRepoImpl(
      networkInfo: mockNetworkInfo,
      userProfileRemote: mockUserProfileRemote,
      userProfileLocal: mockUserProfileLocal,
    );
  });
  final tUserProfileJson = json.decode(Fixture('user_profile.json'));
  final tUserProfileModel = UserProfileModels(
    id: tUserProfileJson['id'],
    uId: tUserProfileJson['uId'],
    username: tUserProfileJson['username'],
    phone: tUserProfileJson['phone'],
    firstName: tUserProfileJson['firstName'],
    lastName: tUserProfileJson['lastName'],
    description: tUserProfileJson['description'],
    photoUrl: tUserProfileJson['photoUrl'],
  );
  final UserProfileEntities tUserProfileEntities = tUserProfileModel;
  final tUserProfParams = UserProfParams(
    tUserProfileJson['uId'],
    tUserProfileJson['username'],
    tUserProfileJson['phone'],
    tUserProfileJson['firstName'],
    tUserProfileJson['lastName'],
    tUserProfileJson['description'],
    tUserProfileJson['photoUrl'],
  );
  void getSetup(){
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  }

  test('should update user profile successfully', () async {
    //arrange
    getSetup();
    when(mockUserProfileRemote.updateUserProfileRemote(any))
    .thenAnswer((_) async => unit);
    //act
    final result = await userProfileRepoImpl.updateUserProfileRepo(tUserProfParams);
    //assert
    verify(mockUserProfileRemote.updateUserProfileRemote(any));
    expect(result, equals(Right(unit)));
  });

  test('should return NetworkFailure when call to update remote data source',() async{
    //arrange
    when(mockNetworkInfo.isConnected)
    .thenAnswer((_) async => false);
    //act
    final result = await userProfileRepoImpl.updateUserProfileRepo(tUserProfParams);
    //assert
    verifyNoMoreInteractions(mockUserProfileRemote);
    verify(mockNetworkInfo.isConnected);
    expect(result, equals(Left(NetworkFailure())));
   });

   test('should return ServerFailure when to call update remote data source is unsuccessful', () async{
     getSetup();
     when(mockUserProfileRemote.updateUserProfileRemote(any))
     .thenThrow(ServerException());
     //act
     final result = await userProfileRepoImpl.updateUserProfileRepo(tUserProfParams);
     //assert
     verify(mockUserProfileRemote.updateUserProfileRemote(any));
     expect(result, equals(Left(ServerFailure("Server Exception"))));
   });
}
