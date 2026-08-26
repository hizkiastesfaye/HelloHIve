import 'package:hellohive/feature/friends/data/models/friends_model.dart';
import 'package:hive/hive.dart';

part 'friends_hive_model.g.dart';

@HiveType(typeId: 20)
class FriendsHiveModel extends FriendsModel {
  @HiveField(0)
  @override
  final String uId;

  @HiveField(1)
  @override
  final String firstName;

  @HiveField(2)
  @override
  final String lastName;

  @HiveField(3)
  @override
  final String username;

  @HiveField(4)
  @override
  final String photoUrl;

  @HiveField(5)
  @override
  final String description;

  FriendsHiveModel({
    required this.uId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.photoUrl,
    required this.description,
  }) : super(
          uId: uId,
          firstName: firstName,
          lastName: lastName,
          username: username,
          photoUrl: photoUrl,
          description: description,
        );
}

extension FriendsModelMapper on FriendsModel {
  FriendsHiveModel toHiveModel({String? hiveId, bool isPendingSync = false}) {
    return FriendsHiveModel(
      uId: uId,
      firstName: firstName,
      lastName: lastName,
      username: username,
      photoUrl: photoUrl,
      description: description,
    );
  }
}

extension FriendsHiveModelMapper on FriendsHiveModel {
  FriendsModel toModel() {
    return FriendsModel(
      uId: uId,
      firstName: firstName,
      lastName: lastName,
      username: username,
      photoUrl: photoUrl,
      description: description,
    );
  }
}