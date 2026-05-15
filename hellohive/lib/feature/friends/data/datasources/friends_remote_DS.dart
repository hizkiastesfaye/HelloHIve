
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/feature/friends/data/models/friends_model.dart';

import '../../friends_core/friends_usecases_core.dart';

abstract class FriendsRemoteDS {
  Future<List<FriendsModel>> getFriendsRemote(FriendsParams params);
  Future<List<FriendsModel>> getRandomFriendsRemote();
}

class FriendsRemoteDsImpl implements FriendsRemoteDS {

  final FirebaseFirestore firebaseFirestore;

  FriendsRemoteDsImpl(this.firebaseFirestore);
  @override
  Future<List<FriendsModel>> getFriendsRemote(FriendsParams params) async{
    
    try{
      Query<Map<String,dynamic>> query = firebaseFirestore.collection('users');
      if(params.fieldName == 'name'){
        final parts = params.value.trim().split(' ');
        final firstName = parts[0];
        if (parts.length > 1) {
          final lastName = parts[1];

          query = query.where(
            Filter.or(
              Filter('firstName', isEqualTo: firstName),
              Filter('lastName', isEqualTo: lastName),
            ),
          );
        } else {
          query = query.where(
            'firstName',
            isEqualTo: firstName,
          );
        }
      }
      else{
        query = query.where(
          params.fieldName,
          isEqualTo: params.value
        );
      }

      final querySnapshot = await query.get();
      // return querySnapshot.docs
      //   .map((doc) => FriendsModel.fromJson(doc.data()))
      //   .toList();
      final result = querySnapshot.docs
        .where((doc) {
          final data = doc.data();

          return data['username'] != null &&
              data['username'].toString().trim().isNotEmpty &&
              data['firstName'] != null &&
              data['firstName'].toString().trim().isNotEmpty &&
              data['lastName'] != null &&
              data['lastName'].toString().trim().isNotEmpty;
        })
        .map((friend) => FriendsModel.fromJson({
          ...friend.data(),
          'uId': friend.id,
          })).toList();
      return result;
    } on ServerException catch (e){
      throw ServerException(e.message);
    } catch (e){
      throw UnknownException();
    }
  }
  @override
  Future<List<FriendsModel>> getRandomFriendsRemote() async{
    try{
      final querySnapshot = await firebaseFirestore
        .collection('users')
        .limit(20)
        .get();

      final result = querySnapshot.docs
        .where((doc) {
          final data = doc.data();

          return data['username'] != null &&
              data['username'].toString().trim().isNotEmpty &&
              data['firstName'] != null &&
              data['firstName'].toString().trim().isNotEmpty &&
              data['lastName'] != null &&
              data['lastName'].toString().trim().isNotEmpty;
        })
        .map((friend) => FriendsModel.fromJson({
          ...friend.data(),
          'uId': friend.id,
          })).toList();
      result.shuffle();
      return result;
    } on ServerException catch (e){
      
      throw ServerException(e.message);
    } catch (e){
      print(e.toString());
      throw UnknownException();
    }
  }
}