import 'dart:convert';

import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/feature/settings/data/models/user_profile_models.dart';
import 'package:hellohive/feature/settings/userProfile_core/user_profile_core.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hellohive/feature/settings/data/dataSources/user_profile_remote.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixture/fixture.dart';
import 'get_user_profile_remote_test.mocks.dart';
@GenerateMocks([
  FirebaseDatabase,
  FirebaseFirestore,
  DatabaseReference,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
])

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
  final tUserProfParams = UserProfParams(
    tUserProfileJson['uId'],
    tUserProfileJson['username'],
    tUserProfileJson['phone'],
    tUserProfileJson['firstName'],
    tUserProfileJson['lastName'],
    tUserProfileJson['description'],
    tUserProfileJson['photoUrl'],
  );
test('should return UserProfileModels when user exists', () async {
  // Arrange
  when(mockFirebaseFirestore.collection('users')).thenReturn(mockUserProfileCollection);
  when(mockUserProfileCollection.doc(any)).thenReturn(mockUserProfileDoc);
  when(mockUserProfileDoc.get()).thenAnswer((_) async => mockUserProfileSnapshot);
  when(mockUserProfileSnapshot.exists).thenReturn(true);
  when(mockUserProfileSnapshot.data()).thenReturn(tUserProfileJson);

  // Act
  final result = await userProfileRemote.getUserProfileRemote(tUserProfileJson['uId']);

  // Assert
  expect(result.id, tUserProfileJson['id']);
  expect(result.username, tUserProfileJson['username']);
  expect(result.phone, tUserProfileJson['phone']);
  expect(result.firstName, tUserProfileJson['firstName']);
  expect(result.lastName, tUserProfileJson['lastName']);
  expect(result.photoUrl, tUserProfileJson['photoUrl']);
  expect(result.description, tUserProfileJson['description']);
});

test('should throw ServerException when user does not exist', () async {
  // Arrange
  when(mockFirebaseFirestore.collection('users')).thenReturn(mockUserProfileCollection);
  when(mockUserProfileCollection.doc(any)).thenReturn(mockUserProfileDoc);
  when(mockUserProfileDoc.get()).thenAnswer((_) async => mockUserProfileSnapshot);
  when(mockUserProfileSnapshot.exists).thenReturn(false);

  // Act & Assert
  expect(
    () => userProfileRemote.getUserProfileRemote(tUserProfileJson['uId']),
    throwsA(isA<ServerException>()),
  );
});
test('should throw UnknownException on unexpected error', () async {
  // Arrange
  when(mockFirebaseFirestore.collection('users')).thenReturn(mockUserProfileCollection);
  when(mockUserProfileCollection.doc(any)).thenReturn(mockUserProfileDoc);
  when(mockUserProfileDoc.get()).thenThrow(Exception('Firestore error'));

  // Act & Assert
  expect(
    () => userProfileRemote.getUserProfileRemote(tUserProfileJson['uId']),
    throwsA(isA<UnknownException>()),
  );
});



}