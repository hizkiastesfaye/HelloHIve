
import '../../domain/entities/friends_entities.dart';

class FriendsModel extends FriendsEntities {
  FriendsModel({
    required uId,
    required String firstName,
    required String lastName,
    required String username,
    required String photoUrl,
  }) : super(
          uId: uId,
          firstName:firstName,
          lastName: lastName,
          username: username,
          photoUrl: photoUrl,
        );

  factory FriendsModel.fromJson(Map<String, dynamic> json) {
    return FriendsModel(
      uId: json['uId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'photoUrl': photoUrl,
    };
  } 
}