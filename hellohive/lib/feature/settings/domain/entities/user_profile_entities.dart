
import 'package:equatable/equatable.dart';

class UserProfileEntities extends Equatable{
  final String id;
  final String uId;
  final String phone;
  final String username;
  final String firstName;
  final String lastName;
  final String photoUrl;
  final String description;
  UserProfileEntities({
    required this.id,
    required this.uId,
    required this.phone,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.photoUrl,
    required this.description,
  });

  @override
  List<Object> get props=> [id,uId,username,firstName,lastName,phone,photoUrl,description];

  @override
  String toString(){
    return 'UserProfileEntities(id: $id,uId: $uId, username:$username, full name:$firstName $lastName, phone:$phone, photoUrl:$photoUrl,description:$description)';
  }
}

class UserStatusEntities extends Equatable{
  final bool isOnline;
  final String lastSeen;

  UserStatusEntities({
    required this.isOnline, 
    required this.lastSeen
  });

  @override
  List<Object> get props => [isOnline, lastSeen];
}