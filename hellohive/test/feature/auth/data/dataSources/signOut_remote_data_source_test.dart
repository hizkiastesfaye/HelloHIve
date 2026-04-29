import 'package:flutter_test/flutter_test.dart';
import 'package:hellohive/feature/auth/data/dataSources/auth_remote_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/feature/auth/auth_core/auth_usecase/auth_core_usecase.dart';
import 'package:hellohive/feature/auth/data/models/auth_models.dart';
import 'package:mockito/mockito.dart'; 
import '../../../../fixture/fixture.dart';
import 'signUp_remote_data_source_test.mocks.dart';
// @GenerateMocks([FirebaseAuth, UserCredential, User])
void main() {

  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseDatabase mockFirebaseDatabase;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockDatabaseReference mockPresenceRef;
  late AuthRemoteDataSourceImpl remoteDataSource;
  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockFirebaseDatabase = MockFirebaseDatabase();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockPresenceRef = MockDatabaseReference();
    remoteDataSource = AuthRemoteDataSourceImpl(
      firebaseAuth: mockFirebaseAuth,
      firebaseFirestore: mockFirebaseFirestore,
      firebaseDatabase: mockFirebaseDatabase,
    );
  });

  final tAuthRes = json.decode(Fixture('auth.json'));
  final AuthParams tparams = AuthParams(
    email: tAuthRes['email'], 
    password: 'password'
  );
  void authSetUp(){
    when(mockFirebaseAuth.signInWithEmailAndPassword(
      email: tparams.email, 
      password: tparams.password ))
      .thenAnswer((_) async=> mockUserCredential);
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn(tAuthRes['id']);
    when(mockUser.email).thenReturn(tAuthRes['email']);
    when(mockUser.emailVerified).thenReturn(tAuthRes['isEmailVerified']);
  }

  void tRealtimeDatabaseSetup(){
    when(mockFirebaseDatabase.ref('presence/${tAuthRes['id']}'))
      .thenReturn(mockPresenceRef);
    when(mockPresenceRef.set(any))
      .thenAnswer((_) async => Future.value());
  }

  test('should singOut successfully', () async{
    //arrange
    authSetUp();
    tRealtimeDatabaseSetup();
    when(mockFirebaseAuth.signOut()).thenAnswer((_) async => Future.value());
    //act
    await remoteDataSource.signInRemoteDataSource(tparams);
    await remoteDataSource.signOutRemoteDataSource();
    //assert
    verify(mockFirebaseAuth.signOut());
  });

  
}


