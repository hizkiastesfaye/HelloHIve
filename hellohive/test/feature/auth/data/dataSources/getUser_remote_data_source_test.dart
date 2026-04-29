import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/feature/auth/auth_core/auth_usecase/auth_core_usecase.dart';
import 'package:hellohive/feature/auth/data/dataSources/auth_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hellohive/feature/auth/data/models/auth_models.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixture/fixture.dart';
import 'signUp_remote_data_source_test.mocks.dart';
void main(){
  late MockFirebaseAuth firebaseAuth;
  late MockFirebaseDatabase firebaseDatabase;
  late MockFirebaseFirestore firebaseFirestore;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockDatabaseReference mockPresenceRef;
  late AuthRemoteDataSourceImpl authRemoteDataSourceImpl;

  setUp((){
    firebaseAuth = MockFirebaseAuth();
    firebaseFirestore = MockFirebaseFirestore();
    firebaseDatabase = MockFirebaseDatabase();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockPresenceRef = MockDatabaseReference();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(
      firebaseAuth: firebaseAuth, 
      firebaseFirestore: firebaseFirestore, 
      firebaseDatabase: firebaseDatabase
    );
  });
  final tAuthRes = json.decode(Fixture('auth.json'));

  final tAuthModels = AuthModels(
    id: tAuthRes['id'], 
    email: tAuthRes['email'], 
    isEmailVerified: tAuthRes['isEmailVerified']
  );

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
    when(firebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn(tAuthRes['id']);
    when(mockUser.email).thenReturn(tAuthRes['email']);
    when(mockUser.emailVerified).thenReturn(tAuthRes['isEmailVerified']);
  }
  test('should return AuthModel when successful',()async{
    //arrange
    authSetUp();
    //act
    final result = await authRemoteDataSourceImpl.getAuthUserDataSource();
    //act
    verify(firebaseAuth.currentUser);
    expect(result, isA<AuthModels>());
    expect(result,tAuthModels);
  });
  test('should throw AuthExecption when failed',()async{
    //arrange
    String errorMessage = 'failed to get user.';
    when(firebaseAuth.currentUser)
      .thenThrow(FirebaseException(plugin: 'firebase_auth'));

    //act
    final result = authRemoteDataSourceImpl.getAuthUserDataSource;
    //assert
    expect(()=>result(),throwsA(isA<AuthException>()));
  });
}