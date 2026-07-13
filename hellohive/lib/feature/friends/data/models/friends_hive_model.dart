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

  FriendsHiveModel({
    required this.uId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.photoUrl,
  }) : super(
          uId: uId,
          firstName: firstName,
          lastName: lastName,
          username: username,
          photoUrl: photoUrl,
        );
}

extension FriendsHiveModelMapper on FriendsModel {
  FriendsHiveModel toHiveModel({String? hiveId, bool isPendingSync = false}) {
    return FriendsHiveModel(
      uId: uId,
      firstName: firstName,
      lastName: lastName,
      username: username,
      photoUrl: photoUrl,
    );
  }
}

extension FriendsModelMapper on FriendsHiveModel {
  FriendsModel toModel() {
    return FriendsModel(
      uId: uId,
      firstName: firstName,
      lastName: lastName,
      username: username,
      photoUrl: photoUrl,
    );
  }
}