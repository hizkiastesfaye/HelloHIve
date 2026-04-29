
import 'package:hellohive/feature/settings/domain/entities/user_profile_entities.dart';

class UserProfileModels extends UserProfileEntities{
  final String id;
  final String uId;
  final String phone;
  final String username;
  final String firstName;
  final String lastName;
  final String photoUrl;
  final String description;
  UserProfileModels({
    required this.id,
    required this.uId,
    required this.phone,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.photoUrl,
    required this.description,
  }):super(
    id:id,
    uId: uId,
    phone: phone,
    username: username,
    firstName: firstName,
    lastName: lastName,
    photoUrl: photoUrl,
    description: description
  );

  factory UserProfileModels.fromJson(Map<String,dynamic> json){
    return UserProfileModels(
      id: json['id'], 
      uId: json['uId'], 
      phone: json['phone'], 
      username: json['username'], 
      firstName: json['firstName'], 
      lastName: json['lastName'], 
      photoUrl: json['photoUrl'], 
      description: json['description']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'uId':uId,
      'phone':phone,
      'username':username,
      'firstName':firstName,
      'lastName':lastName,
      'photoUrl':photoUrl,
      'description':description
    };
  }
}

class UserStatusModels extends UserStatusEntities{
  final bool isOnline;
  final String lastSeen;

  UserStatusModels({
    required this.isOnline,
    required this.lastSeen
  }): super(
    isOnline: isOnline,
    lastSeen: lastSeen,
  );

  factory UserStatusModels.fromJson(Map<String,dynamic> json){
    return UserStatusModels(
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen']?.toString() ?? "Offline",
    );
  }
  Map<String,dynamic> toJson(){
    return {
      'isOnline': isOnline,
      'lastSeen': lastSeen
    };
  }
}