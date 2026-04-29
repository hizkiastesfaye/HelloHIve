// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/feature/auth/auth_core/auth_usecase/auth_core_usecase.dart';
import 'package:hellohive/feature/auth/data/models/auth_models.dart';
abstract class AuthRemoteDataSource {
  Future<AuthModels> signInRemoteDataSource(AuthParams params);
  Future<AuthModels> signUpRemoteDataSource(AuthParams params);
  Future<void> signOutRemoteDataSource();
  Future<AuthModels>getAuthUserDataSource();
  Future<Unit>verifyEmailDataSource();
  Future<Unit>emailVerifiedDataSource();
  Future<Unit>resetPasswordDataSource(String email);
  Future<Unit>updatePasswordDatasource(String password);

  
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseDatabase firebaseDatabase;
  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.firebaseDatabase,
  });
  @override
  Future<AuthModels> signUpRemoteDataSource(AuthParams params) async{
    try{
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      ).timeout(
          const Duration(seconds: 10),
          onTimeout:(){
            throw AuthException('time out');
          }
        );

      final user = userCredential.user;
      if(user == null){
        throw AuthException('User creation failed');
      }

        // Create user document in Firestore
      final userDoc = firebaseFirestore.collection('users').doc(user.uid);

        // 'firstname': '',
        // 'lastname': '',
        // 'phone': '',
        // "username": '',
        // "description": '',
        // "profilePhotoUrl": '',
      await userDoc.set({
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      }).timeout(
          const Duration(seconds: 10),
          onTimeout:(){
            throw AuthException('time out');
          }
      );

      // Set initial presence in Realtime Database
      final presenceRef = firebaseDatabase.ref('presence/${user.uid}');
      await presenceRef.set({
        'isOnline': false,
        'lastSeen': ServerValue.timestamp,
      }).timeout(
          const Duration(seconds: 10),
          onTimeout:(){
            throw AuthException('time out');
          }
      );

      return AuthModels(
        id: user.uid,
        email: user.email ?? '',
        isEmailVerified: user.emailVerified,
      );
      
    } on TimeoutException catch (_){
        throw AuthException();
    } on FirebaseAuthException catch (e) {
      switch(e.code){
        case 'email-already-in-use':
          throw AuthException('email already in use.');
        default:
          throw AuthException('Authentication failed. try again');
      }
    } on FirebaseException catch (_) {
      throw ServerException('Failed. try again');
    } 
    catch (e) {
      throw UnknownException(e.toString());
    }

  }

  @override
  Future<AuthModels> signInRemoteDataSource(AuthParams params) async {
    try{
      
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: params.email, 
        password: params.password
      );
      
      final user = userCredential.user;
      if(user == null){
        throw AuthException('Sign in failed');
        }
      // if(!user.emailVerified){
      //   throw VerifyException('Email not verified');
      // }
    
      return AuthModels(
        id: user.uid, 
        email: user.email ?? '', 
        isEmailVerified: user.emailVerified
      );
    } on FirebaseAuthException catch (e) {
      switch(e.code){
        case 'INVALID_LOGIN_CREDENTIALS':
          throw AuthException('Wrong email or password');
        case 'wrong-password':
          throw AuthException('Wrong email or password');
        default:
          throw AuthException('Authentication failed. try again');
      }
    } on FirebaseException catch (_) {
      throw ServerException('Failed, try again');
    }
    catch (e) {
      throw UnknownException(e.toString());
    }
  }
  @override
  Future<void> signOutRemoteDataSource() async{
    try{
      final user = firebaseAuth.currentUser;
      if(user != null){
        final uid = user.uid;
        final presenceRef = firebaseDatabase.ref('presence/${uid}');
        presenceRef.set({
          'isOnline': false,
          'lastSeen': ServerValue.timestamp,
        });
      }
      await firebaseAuth.signOut();
    } on FirebaseException catch (_) {
      throw ServerException('failed, try again');
    }
    catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<AuthModels> getAuthUserDataSource() async{
    try{
      final user = firebaseAuth.currentUser;
      if(user == null){
        throw AuthException('user not found');
      }
      return AuthModels(
        id: user.uid, 
        email: user.email ?? '', 
        isEmailVerified: user.emailVerified
      );

    } on FirebaseException catch(_){
      throw AuthException('failed to get user.');
    } catch (_){
      throw UnknownException('unable to get user');
    }
  }

  @override
  Future<Unit> emailVerifiedDataSource() async{
    try{
      final user = firebaseAuth.currentUser;
      if(user ==null){
        throw AuthException('user not found');
      }
      await user.reload().timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw AuthException('Verification check timed out'),
      );
      if(!user.emailVerified){
        throw AuthException('email is not verifed.');
      }
      return unit;

    }on AuthException catch(e){
      throw AuthException(e.message);
    } on FirebaseAuthException catch(_){
      throw AuthException('failed to verify');
    } catch (_){
      throw UnknownException('unable to verify');
    }
  }

  @override
  Future<Unit> verifyEmailDataSource() async{
    try{
      final user = firebaseAuth.currentUser;
      if(user ==null){
        throw AuthException('user not found');
      }
      if(user.emailVerified){
        throw AuthException('email is already verifed.');
      }
      await user.sendEmailVerification();
      return unit;
    } on FirebaseAuthException catch(_){
      throw AuthException('failed to send link');
    } catch (_){
      throw UnknownException('unable to send link');
    }
  }
  Future<Unit> resetPasswordDataSource(String email)async{
    try{
      await firebaseAuth
        .sendPasswordResetEmail(email: email)
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw AuthException('Password reset request timed out'),
        );
      return unit;
    } on AuthException catch(e){
      throw AuthException(e.message);
    } on FirebaseAuthException catch(_){
      throw AuthException('Failed to send reset link.');
    } catch (_){
      throw UnknownException();
    }
  }
  Future<Unit>updatePasswordDatasource(String password)async{
    try{
      final user = firebaseAuth.currentUser;
      if(user ==null){
        throw AuthException('user not found');
      }
      await user.updatePassword(password);
      await user.reload();
      return(unit);
    } on AuthException catch(e){
      throw AuthException(e.message);
    } on FirebaseAuthException catch(_){
      throw AuthException('Failed to update password.');
    } catch (_){
      throw UnknownException();
    }
  }
  
}