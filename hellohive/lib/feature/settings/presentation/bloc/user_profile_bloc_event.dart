part of 'user_profile_bloc_bloc.dart';

@immutable
sealed class UserProfileBlocEvent extends Equatable{
  @override
  List<Object> get props=>[];
}

class GetUserProfileEvent extends UserProfileBlocEvent{
  final String uId;
  GetUserProfileEvent(this.uId);

  @override 
  List<Object> get props=>[uId];
}


class AddUserProfileEvent extends UserProfileBlocEvent{
  final String uId;
  final String phone;
  final String username;
  final String firstName;
  final String lastName;
  final String photoUrl;
  final String description;

  AddUserProfileEvent({
    required this.uId,
    required this.phone,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.photoUrl,
    required this.description,
  });

  @override
  List<Object> get props => [uId,phone,username,firstName,lastName,photoUrl,description];
}
class UpdateSingleUserProfileEvent extends UserProfileBlocEvent{
  final String uId;
  final String fieldName;
  final String value;
  UpdateSingleUserProfileEvent({
    required this.uId,
    required this.fieldName,
    required this.value,
  });
  @override
  List<Object> get props => [uId,fieldName,value];
}
class UpdateUserProfileEvent extends UserProfileBlocEvent{
  final String uId;
  final String phone;
  final String username;
  final String firstName;
  final String lastName;
  final String description;

  UpdateUserProfileEvent({
    required this.uId,
    required this.phone,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.description,
  });

  @override
  List<Object> get props => [uId,phone,username,firstName,lastName,description];
}
class DeleteUserProfileEvent extends UserProfileBlocEvent{
  final String uId;
  DeleteUserProfileEvent(this.uId);

  @override 
  List<Object> get props=>[uId];
}
class GetUserStatusEvent extends UserProfileBlocEvent{
  final String uId;
  GetUserStatusEvent(this.uId);

  @override 
  List<Object> get props=>[uId];
}
