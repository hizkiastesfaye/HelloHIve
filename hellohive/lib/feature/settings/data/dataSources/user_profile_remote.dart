
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/feature/settings/data/models/user_profile_models.dart';

import '../../userProfile_core/user_profile_core.dart';

abstract class UserProfileRemote {
  Future<UserProfileModels>getUserProfileRemote(String uId);
  Future<Unit> addUserProfileRemote(UserProfParams params);
  Future<Unit> updateSingleUserProfileRemote(UserSingleParams params);
  Future<Unit> updateUserProfileRemote(UserProfParams params);
  Future<Unit> deleteUserProfileRemote(UserProfParams params);
  Stream<UserStatusModels> getUserStatusRemote(String uId);
}

class UserProfileRemoteImpl implements UserProfileRemote{
  final FirebaseDatabase firebaseDatabase;
  final FirebaseFirestore firebaseFirestore;

  UserProfileRemoteImpl({
    required this.firebaseDatabase, 
    required this.firebaseFirestore
  });

  @override
  Future<UserProfileModels>getUserProfileRemote(String uId)async{
    try{
      final user = FirebaseAuth.instance.currentUser;
      // print("#############################@@@@@@@@@@@@@@@@");

      // print('${user?.uid} ${user?.email}'); // should not be null

      final userDoc = await firebaseFirestore.collection('users').doc(user?.uid).get();
      if(!userDoc.exists){
        throw ServerException('User profile not found');
      }

      final data = userDoc.data()!;
      // data.forEach((key, value) {
      //   print('$key: $value');
      // });
      final userProfile = UserProfileModels(
        id: uId,
        uId: uId, 
        phone: data['phone'],
        username: data['username'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        photoUrl: data['photoUrl'],
        description: data['description'],
      );
      // print("#############################@@@@@@@@@@@@@@@@");
      // print("#############################@@@@@@@@@@@@@@@@");
      return userProfile;
    } on ServerException catch(e){
      throw ServerException(e.message);
    }catch (e){
      // print("#############################@@@@@@@@@@@@@@@@");
      // print("#############################@@@@@@@@@@@@@@@@");
      // print("#############################@@@@@@@@@@@@@@@@");
      // print("#############################@@@@@@@@@@@@@@@@");
      // print(e.toString());
      // print("#############################@@@@@@@@@@@@@@@@");
      // print("#############################@@@@@@@@@@@@@@@@");
      // print("#############################@@@@@@@@@@@@@@@@");
      // print("#############################@@@@@@@@@@@@@@@@");
      throw UnknownException();
    }
  }
  @override
  Future<Unit> addUserProfileRemote(UserProfParams params)async{
    try{
      await firebaseFirestore.collection('users').doc(params.uId).set({
        'uId':params.uId,
        'phone':params.phone,
        'username':params.username,
        'firstName':params.firstName,
        'lastName':params.lastName,
        'photoUrl':params.photoUrl,
        'description':params.description,
        'createdAt':FieldValue.serverTimestamp(),
        'updatedAt':FieldValue.serverTimestamp()
      });
      return Future.value(unit);
      
    } on FirebaseException catch(_){
      throw ServerException(('failed to add. Try again'));
    } catch(_){
      throw UnknownException();
    }
  }
  @override
  Future<Unit> updateSingleUserProfileRemote(UserSingleParams params) async{
    try{
      await firebaseFirestore.collection('users').doc(params.uId).update({
        params.fieldName: params.value,
        'updatedAt':FieldValue.serverTimestamp()
      });
      return Future.value(unit);
      
    } on FirebaseException catch(_){
      throw ServerException('Failed to update. Try again');
    } catch(_){
      throw UnknownException();
    }
  }
  @override
  Future<Unit> updateUserProfileRemote(UserProfParams params)async{
    try{
      await firebaseFirestore.collection('users').doc(params.uId).update({
        'phone':params.phone,
        'username':params.username,
        'firstName':params.firstName,
        'lastName':params.lastName,
        'description':params.description,
        'updatedAt':FieldValue.serverTimestamp()
      });
      return Future.value(unit);
      
    } on FirebaseException catch(_){
      throw ServerException('Failed to update. Try again');
    } catch(_){
      throw UnknownException();
    }
  }
  @override
  Future<Unit> deleteUserProfileRemote(UserProfParams params)async {
    try{
      await firebaseFirestore.collection('users').doc(params.uId).delete();
      return Future.value(unit);
      
    } on FirebaseException catch(_){
      throw ServerException('Failed to delete. Try again');
    } catch(_){
      throw UnknownException();
    }
  }
  @override
Stream<UserStatusModels> getUserStatusRemote(String uId) {
  final userStatusRef = firebaseDatabase.ref("status/$uId");
  final connectedRef = firebaseDatabase.ref(".info/connected");

  // Listen to connection state to manage presence
  connectedRef.onValue.listen((event) {
    final isConnected = event.snapshot.value as bool? ?? false;
    if (isConnected) {
      // 1. Set online
      userStatusRef.update({
        "isOnline": true, 
        "lastSeen": ServerValue.timestamp
      });

      // 2. Queue the offline update for later
      userStatusRef.onDisconnect().update({
        "isOnline": false, 
        "lastSeen": ServerValue.timestamp
      });
    }
  });

  // 3. Return the actual data stream for the UI
  return userStatusRef.onValue.map((event) {
    final data = event.snapshot.value;
    
    if (data != null && data is Map) {
      // We cast Map<dynamic, dynamic> to Map<String, dynamic>
      final formattedData = Map<String, dynamic>.from(data);
      return UserStatusModels.fromJson(formattedData);
    }
    // Fallback if data doesn't exist
    throw ServerException('user status not found');
  });
}
}