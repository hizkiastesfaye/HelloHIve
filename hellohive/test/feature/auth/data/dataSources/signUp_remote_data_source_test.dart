import 'dart:convert';

import 'package:hellohive/feature/auth/data/models/auth_models.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'signUp_remote_data_source_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth, 
  FirebaseFirestore, 
  FirebaseDatabase,  
  UserCredential,
  User,
  CollectionReference,
  DocumentReference,
  DatabaseReference
])

void main(){
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockFirebaseDatabase mockrealtimeDatabase;
  late AuthRemoteDataSource remoteDataSource;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockCollectionReference<Map<String, dynamic>> mockUsersCollection;
  late MockDocumentReference<Map<String, dynamic>> mockUserDoc;
  late MockDatabaseReference mockPresenceRef;
  

  setUp((){
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockrealtimeDatabase = MockFirebaseDatabase();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockUsersCollection = MockCollectionReference();
    mockUserDoc = MockDocumentReference();
    mockPresenceRef = MockDatabaseReference();
    remoteDataSource = AuthRemoteDataSourceImpl(
      firebaseAuth: mockFirebaseAuth,
      firebaseFirestore: mockFirebaseFirestore,
      firebaseDatabase: mockrealtimeDatabase,
    );
  });

    final tAuthRes = json.decode(Fixture('auth.json'));
    final AuthParams tparams = AuthParams(
      email: tAuthRes['email'], 
      password: 'password'
    );

    void tAuthSetUp(){
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'), 
        password: anyNamed('password')))
        .thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn(tAuthRes['id']);
      when(mockUser.email).thenReturn(tAuthRes['email']);
      when(mockUser.emailVerified).thenReturn(tAuthRes['isEmailVerified']);
    }

    void tFirebaseSetup(){
      when(mockFirebaseFirestore.collection('users'))
        .thenReturn(mockUsersCollection);
      when(mockUsersCollection.doc(any))
        .thenReturn(mockUserDoc);
      when(mockUserDoc.set(any))
        .thenAnswer((_) async => Future.value());
    }

    void tRealtimeDatabaseSetup(){
      when(mockrealtimeDatabase.ref('presence/${tAuthRes['id']}'))
        .thenReturn(mockPresenceRef);
      when(mockPresenceRef.set(any))
        .thenAnswer((_) async => Future.value());
    }
  group('Sign Up Remote Data Source Test',(){

    final tAuthModels = AuthModels(
      id: tAuthRes['id'], 
      email: tAuthRes['email'], 
      isEmailVerified: tAuthRes['isEmailVerified']
    );

    test('should return AuthModels when sign up is successful', () async{
      //arrange of Auth
      tAuthSetUp();
      tFirebaseSetup();
      tRealtimeDatabaseSetup();
      //act
      final result = await remoteDataSource.signUpRemoteDataSource(tparams);

      //assert
      expect(result, isA<AuthModels>());
      // expect(result, equals(tAuthModels));
      expect(result.email, equals(tAuthModels.email));
      expect(result.id, equals(tAuthModels.id));
      expect(result.isEmailVerified, equals(tAuthModels.isEmailVerified));

      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: tparams.email,
        password: tparams.password,
      )).called(1);
    });
    test('should set firestore user document with correct data', () async{
      //arrange of Auth
      tAuthSetUp();
      // arrange of FireStore
      tFirebaseSetup();
      tRealtimeDatabaseSetup();
      //act
      await remoteDataSource.signUpRemoteDataSource(tparams);
      //assert
      verify(mockFirebaseFirestore.collection('users')).called(1);
      verify(mockUsersCollection.doc(tAuthRes['id'])).called(1);
      verify(mockUserDoc.set({
        'firstname': null,
        'lastname': null,
        'phone': null,
        "username": null,
        "description": null,
        "profilePhotoUrl": null,
        "updatedAt": FieldValue.serverTimestamp(),
      })).called(1);
    });

    test('should set realtime database presence with correct data', () async{
      //arrange of Auth
      tAuthSetUp();
      //arrange of Realtime Database
      tFirebaseSetup();
      tRealtimeDatabaseSetup();
      //act
      await remoteDataSource.signUpRemoteDataSource(tparams);
      //assert
      verify(mockrealtimeDatabase.ref('presence/${tAuthRes['id']}')).called(1);
      verify(mockPresenceRef.set(any)).called(1);
    });
    test('should throw AuthException when FirebaseAuthException occurs', () async{
      //arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'), 
        password: anyNamed('password')))
        .thenThrow(FirebaseAuthException(code: 'email-already-in-use'));
      //act
      final call = remoteDataSource.signUpRemoteDataSource;
      //assert
      expect(() => call(tparams), throwsA(isA<AuthException>()));
    });
    test('should throw ServerException when FirebaseException occurs', () async{
      //arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'), 
        password: anyNamed('password')))
        .thenThrow(FirebaseException(plugin: 'firebase_auth', message: 'Some Firebase error'));
      //act
      final call = remoteDataSource.signUpRemoteDataSource;
      //assert
      expect(() => call(tparams), throwsA(isA<ServerException>()));
    });
    test('should throw UnknownException for any other exceptions', () async{
      //arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'), 
        password: anyNamed('password')))
        .thenThrow(Exception('Some unknown error'));
      //act
      final call = remoteDataSource.signUpRemoteDataSource;
      //assert
      expect(() => call(tparams), throwsA(isA<UnknownException>()));
  });
  });
}