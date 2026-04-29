import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:hellohive/feature/settings/domain/entities/user_profile_entities.dart';
import 'package:hellohive/feature/settings/domain/usecases/user_profile_useCase.dart';
import 'package:hellohive/feature/settings/userProfile_core/user_profile_core.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hellohive/feature/settings/domain/repositories/user_profile_repo.dart';
import 'package:mockito/mockito.dart';
import 'user_profile_usecase_test.mocks.dart';
import '../../../../fixture/fixture.dart';

@GenerateMocks([UserProfileRepo])
void main(){
  late MockUserProfileRepo mockUserProfileRepo;
  late GetUserProfileUsecase getUserProfileUsecase;
  late AddUserProfileUsecase addUserProfileUsecase;
  late UpdateUserProfileUsecase updateUserProfileUsecase;
  late UpdateSingleUserProfileUsecase updateSingleUserProfileUsecase;
  late DeletUserProfileUsecase deletUserProfileUsecase;
  late GetUserStatusUsecase getUserStatusUsecase;

  setUp((){
    mockUserProfileRepo = MockUserProfileRepo();
    getUserProfileUsecase = GetUserProfileUsecase(mockUserProfileRepo);
    addUserProfileUsecase = AddUserProfileUsecase(mockUserProfileRepo);
    updateUserProfileUsecase = UpdateUserProfileUsecase(mockUserProfileRepo);
    updateSingleUserProfileUsecase = UpdateSingleUserProfileUsecase(mockUserProfileRepo);
    deletUserProfileUsecase = DeletUserProfileUsecase(mockUserProfileRepo);
    getUserStatusUsecase = GetUserStatusUsecase(mockUserProfileRepo);
  });
  final tUserProfileJson = json.decode(Fixture('user_profile.json'));
  final tUserProfileEntities = UserProfileEntities(
    id: tUserProfileJson['id'],
    uId: tUserProfileJson['uId'],
    username: tUserProfileJson['username'],
    phone: tUserProfileJson['phone'],
    firstName: tUserProfileJson['firstName'],
    lastName: tUserProfileJson['lastName'],
    description: tUserProfileJson['description'],
    photoUrl: tUserProfileJson['photoUrl'],
  );
  final tUserProfParams = UserProfParams(
    tUserProfileJson['uId'],
    tUserProfileJson['username'],
    tUserProfileJson['phone'],
    tUserProfileJson['firstName'],
    tUserProfileJson['lastName'],
    tUserProfileJson['description'],
    tUserProfileJson['photoUrl'],
  );
  final tUserStatusJson = json.decode(Fixture('user_status.json'));
  final tUserStatusEntities = UserStatusEntities(
    isOnline: tUserStatusJson['isOnline'], 
    lastSeen: tUserStatusJson['lastSeen']
  );
  test('should get user profile from the repository', () async {
    // Arrange
    when(mockUserProfileRepo.getUserProfileRepo(any))
      .thenAnswer((_) async=> Right(tUserProfileEntities));
    // Act
    final result = await getUserProfileUsecase(tUserProfileJson['uId']);
    // Assert
    expect(result, Right(tUserProfileEntities));
    verify(mockUserProfileRepo.getUserProfileRepo(tUserProfileJson['uId']));
    verifyNoMoreInteractions(mockUserProfileRepo);
  });

  test('should add user profile to the repository', () async {
    // Arrange
    when(mockUserProfileRepo.addUserProfileRepo(any))
      .thenAnswer((_) async=> Right(unit));
    // Act
    final result = await addUserProfileUsecase(tUserProfParams);
    // Assert
    expect(result, Right(unit));
    verify(mockUserProfileRepo.addUserProfileRepo(tUserProfParams));
    verifyNoMoreInteractions(mockUserProfileRepo);
  });

  test('should update user profile in the repository', () async {
    // Arrange
    when(mockUserProfileRepo.updateUserProfileRepo(any))
      .thenAnswer((_) async=> Right(unit));
    // Act
    final result = await updateUserProfileUsecase(tUserProfParams);
    // Assert
    expect(result, Right(unit));
    verify(mockUserProfileRepo.updateUserProfileRepo(tUserProfParams));
    verifyNoMoreInteractions(mockUserProfileRepo);
  });

  test('should delete user profile from the repository', () async {
    // Arrange
    when(mockUserProfileRepo.deleteUserProfileRepo(any))
      .thenAnswer((_) async=> Right(unit));
    // Act
    final result = await deletUserProfileUsecase(tUserProfParams);
    // Assert
    expect(result, Right(unit));
    verify(mockUserProfileRepo.deleteUserProfileRepo(tUserProfParams));
    verifyNoMoreInteractions(mockUserProfileRepo);
  });

  test('should get user status from the repository', () async {
    // Arrange
    // final tUserStatusEntities = UserStatusEntities(isOnline: true, lastSeen: '2024-01-01T12:00:00Z');
    when(mockUserProfileRepo.getUserStatusRepo(any))
      .thenAnswer((_) => Stream.value(Right(tUserStatusEntities)));
    // Act
    final resultStream = getUserStatusUsecase(tUserProfileJson['uId']);
    // Assert
    expectLater(resultStream, emitsInOrder([Right(tUserStatusEntities)]));
    verify(mockUserProfileRepo.getUserStatusRepo(tUserProfileJson['uId']));
    verifyNoMoreInteractions(mockUserProfileRepo);
  });

}