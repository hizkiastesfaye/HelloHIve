import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
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
  final tUserStatusJson = json.decode(Fixture('user_status.json'));
  final uId = tUserProfileJson['uId'];
  final tUserStatusModel = UserStatusModels(
    isOnline: tUserStatusJson['isOnline'], 
    lastSeen: tUserStatusJson['lastSeen']
  );
  final UserStatusEntities tUserStatusEntities = UserStatusEntities(
    isOnline: tUserStatusJson['isOnline'], 
    lastSeen: tUserStatusJson['lastSeen']
  );

test('should emit Right(UserStatusEntities) when remote succeeds', () async {
  // arrange
  when(mockUserProfileRemote.getUserStatusRemote(any))
      .thenAnswer((_) => Stream.value(tUserStatusModel));

  when(mockUserProfileLocal.cacheUserStatusLocal(any))
      .thenAnswer((_) async=>unit);

  // act
  final stream = userProfileRepoImpl.getUserStatusRepo(uId);

  // assert (IMPORTANT: await)
  await expectLater(
    stream,
    emits(
      predicate<Either<Failure, UserStatusEntities>>(
        (either) =>
            either.isRight() &&
            either.getOrElse(() => throw '').isOnline == true,
      ),
    ),
  );

  // verify AFTER stream is consumed
  verify(mockUserProfileRemote.getUserStatusRemote(uId)).called(1);
  verify(mockUserProfileLocal.cacheUserStatusLocal(tUserStatusModel)).called(1);
});

test('should emit Right(LocalData) when remote throws but local has data', () async {
  // arrange
  when(mockUserProfileRemote.getUserStatusRemote(any))
      .thenAnswer((_) => Stream.error(Exception('Remote error')));

  when(mockUserProfileLocal.getUserStatusLocal())
      .thenAnswer((_) async => tUserStatusModel);

  // act
  final stream = userProfileRepoImpl.getUserStatusRepo(uId);

  // assert
  await expectLater(
    stream,
    emitsInOrder([
      predicate<Either<Failure, UserStatusEntities>>(
        (either) => either.isRight() &&
        either.getOrElse(() => throw '').isOnline == true,
      ),
      emitsDone,
    ]),
  );

  verify(mockUserProfileLocal.getUserStatusLocal()).called(1);
});

}