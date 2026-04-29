import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/feature/auth/auth_core/auth_usecase/auth_core_usecase.dart';
import 'package:hellohive/feature/auth/data/models/auth_models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fixture/fixture.dart';
import 'signUp_remote_data_source_test.mocks.dart';
import 'package:hellohive/feature/auth/data/dataSources/auth_remote_data_source.dart';
// @GenerateMocks([
//   FirebaseAuth, 
//   FirebaseFirestore, 
//   FirebaseDatabase,  
//   UserCredential,
//   User,
//   CollectionReference,
//   DocumentReference,
//   DatabaseReference
// ])

void main(){
  late MockFirebaseAuth firebaseAuth;
  late MockFirebaseFirestore firebaseFirestore;
  late MockFirebaseDatabase firebaseDatabase;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late AuthRemoteDataSourceImpl remoteDataSource;

  setUp((){
    firebaseAuth = MockFirebaseAuth();
    firebaseFirestore = MockFirebaseFirestore();
    firebaseDatabase = MockFirebaseDatabase();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    remoteDataSource = AuthRemoteDataSourceImpl(
      firebaseAuth: firebaseAuth,
      firebaseFirestore: firebaseFirestore,
      firebaseDatabase: firebaseDatabase,
    );

  });

    final tAuthRes = json.decode(Fixture('auth.json'));
    final AuthParams tparams = AuthParams(
      email: tAuthRes['email'], 
      password: 'password'
    );
  void authSetUp(){
    when(firebaseAuth.signInWithEmailAndPassword(
      email: tparams.email, 
      password: tparams.password ))
      .thenAnswer((_) async=> mockUserCredential);
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn(tAuthRes['id']);
    when(mockUser.email).thenReturn(tAuthRes['email']);
    when(mockUser.emailVerified).thenReturn(tAuthRes['isEmailVerified']);
  }

  test('should sign in user remotely and return AuthModels', () async{
    //arrange
    authSetUp();
    //act
    final result = await remoteDataSource.signInRemoteDataSource(tparams);
    //assert
    expect(result, isA<AuthModels>());
    expect(result.id, tAuthRes['id']);
    expect(result.email, tAuthRes['email']);
    expect(result.isEmailVerified, tAuthRes['isEmailVerified']);
  });

  test('should throw AuthException when sign in fails', () async{
    //arrange
    when(firebaseAuth.signInWithEmailAndPassword(
      email: tparams.email, 
      password: tparams.password ))
      .thenThrow(FirebaseAuthException(code: 'user-not-found'));
    //act
    final call = remoteDataSource.signInRemoteDataSource;
    //assert
    expect(() => call(tparams), throwsA(isA<AuthException>()));
  });
  test('should throw ServerException on FirebaseException', () async{
    //arrange
    when(firebaseAuth.signInWithEmailAndPassword(
      email: tparams.email, 
      password: tparams.password ))
      .thenThrow(FirebaseException(plugin: 'firebase_auth'));
    //act
    final call = remoteDataSource.signInRemoteDataSource;
    //assert
    expect(() => call(tparams), throwsA(isA<ServerException>()));
  });
  test('should throw UnknownException on generic exception', () async{
    //arrange
    when(firebaseAuth.signInWithEmailAndPassword(
      email: tparams.email, 
      password: tparams.password ))
      .thenThrow(Exception());
    //act
    final call = remoteDataSource.signInRemoteDataSource;
    //assert
    expect(() => call(tparams), throwsA(isA<UnknownException>()));
  });
  
}