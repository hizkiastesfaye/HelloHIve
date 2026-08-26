
import 'package:equatable/equatable.dart';

class FriendsEntities extends Equatable{
  final String uId;
  final String firstName;
  final String lastName;
  final String username;
  final String photoUrl;
  final String description;


  const FriendsEntities({
    required this.uId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.photoUrl,
    required this.description,
  });

  @override
  List<Object?> get props => [
    uId, firstName,lastName, 
    username, photoUrl, description
    ];
}