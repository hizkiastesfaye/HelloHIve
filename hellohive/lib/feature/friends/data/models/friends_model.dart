
import '../../domain/entities/friends_entities.dart';

class FriendsModel extends FriendsEntities {
  FriendsModel({
    required uId,
    required String name,
    required String username,
    required String photoUrl,
  }) : super(
          uId: uId,
          name: name,
          username: username,
          photoUrl: photoUrl,
        );

  factory FriendsModel.fromJson(Map<String, dynamic> json) {
    return FriendsModel(
      uId: json['uId'],
      name: json['name'],
      username: json['username'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'name': name,
      'username': username,
      'photoUrl': photoUrl,
    };
  } 
}