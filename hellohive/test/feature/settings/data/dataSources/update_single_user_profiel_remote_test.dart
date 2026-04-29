import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/network/netowork_info.dart';
import 'package:hellohive/feature/settings/data/dataSources/user_profile_local.dart';
import 'package:hellohive/feature/settings/data/dataSources/user_profile_remote.dart';
import 'package:hellohive/feature/settings/data/models/user_profile_models.dart';
import 'package:hellohive/feature/settings/userProfile_core/user_profile_core.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
// import '/get_user_profile_repo_test.mocks.dart';
import '../../../../fixture/fixture.dart';
import 'get_user_profile_remote_test.mocks.dart';


void main(){
  late MockFirebaseDatabase mockFirebaseDatabase;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockDatabaseReference mockUserProfileRef;
  late MockCollectionReference<Map<String, dynamic>> mockUserProfileCollection;
  late MockDocumentReference<Map<String, dynamic>> mockUserProfileDoc;
  late MockDocumentSnapshot<Map<String, dynamic>> mockUserProfileSnapshot;
  late UserProfileRemote userProfileRemote;

  setUp((){
    mockFirebaseDatabase = MockFirebaseDatabase();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockUserProfileRef = MockDatabaseReference();
    mockUserProfileCollection = MockCollectionReference();
    mockUserProfileDoc = MockDocumentReference();
    mockUserProfileSnapshot = MockDocumentSnapshot();
    userProfileRemote = UserProfileRemoteImpl(
      firebaseDatabase: mockFirebaseDatabase,
      firebaseFirestore: mockFirebaseFirestore,
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
  final tSingleUserProfParams = UserSingleParams(
    uId:tUserProfileJson['uId'],
    fieldName: 'username',
    value:tUserProfileJson['username'],
  );

  test('should successful when call to update single user profile remote data source', () async{
    //arrange
    when(mockFirebaseFirestore.collection(any)).thenReturn(mockUserProfileCollection);
    when(mockUserProfileCollection.doc(any)).thenReturn(mockUserProfileDoc);
    when(mockUserProfileDoc.update(any)).thenAnswer((_) async => Future.value());
    //act
    final result = await userProfileRemote.updateSingleUserProfileRemote(tSingleUserProfParams);
    //assert
    verify(mockFirebaseFirestore.collection('users'));
    verify(mockUserProfileCollection.doc(tSingleUserProfParams.uId));
    verify(mockUserProfileDoc.update({
      tSingleUserProfParams.fieldName: tSingleUserProfParams.value,
      'updatedAt': FieldValue.serverTimestamp()
     }));
     expect(result, equals(unit));
  });

  test('should return serverFailure when call to update single user profile remote data source', () async{
    //arrange
    when(mockFirebaseFirestore.collection(any)).thenReturn(mockUserProfileCollection);
    when(mockUserProfileCollection.doc(any)).thenReturn(mockUserProfileDoc);
    when(mockUserProfileDoc.update(any)).thenThrow(
      FirebaseException(plugin: 'firestore', message: 'Update failed'),
    );
    //act
     expect(
    () => userProfileRemote.updateSingleUserProfileRemote(tSingleUserProfParams),
    throwsA(isA<ServerException>()),
  );
    //assert
    verify(mockFirebaseFirestore.collection('users'));
    verify(mockUserProfileCollection.doc(tSingleUserProfParams.uId));
    verify(mockUserProfileDoc.update(any));
  });

  test('should throw UnknownException when unexpected error occurs', () async {
  // arrange
  when(mockFirebaseFirestore.collection(any)).thenReturn(mockUserProfileCollection);
  when(mockUserProfileCollection.doc(any)).thenReturn(mockUserProfileDoc);
  when(mockUserProfileDoc.update(any)).thenThrow(Exception('Unexpected error'));

  // act & assert
  expect(
    () => userProfileRemote.updateSingleUserProfileRemote(tSingleUserProfParams),
    throwsA(isA<UnknownException>()),
  );
    verify(mockFirebaseFirestore.collection('users'));
    verify(mockUserProfileCollection.doc(tSingleUserProfParams.uId));
    verify(mockUserProfileDoc.update(any));
  });

}