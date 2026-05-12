
import 'package:equatable/equatable.dart';

class FriendsEntities extends Equatable{
  final String uId;
  final String name;
  final String username;
  final String photoUrl;

  const FriendsEntities({
    required this.uId,
    required this.name,
    required this.username,
    required this.photoUrl,
  });

  @override
  List<Object?> get props => [uId, name, username, photoUrl];
}