
import 'package:equatable/equatable.dart';

class UserProfParams extends Equatable{
  final String? uId;
  final String? phone;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? photoUrl;
  final String? description;

  UserProfParams({
    this.uId, 
    this.phone, 
    this.username, 
    this.firstName, 
    this.lastName, 
    this.photoUrl, 
    this.description
  });

  @override
  List<Object?> get props=>
    [
      uId,
      username,
      firstName,
      lastName,
      phone,
      photoUrl,
      description
    ];
}

class UserSingleParams extends Equatable{
  final String uId;
  final String fieldName;
  final dynamic value;

  UserSingleParams({required this.uId, required this.fieldName, required this.value});

  @override
  List<Object> get props=>[uId,fieldName,value];
}