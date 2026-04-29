part of 'user_profile_bloc_bloc.dart';

@immutable
sealed class UserProfileBlocState extends Equatable{
  @override
  List<Object> get props => [];
}

final class UserProfileBlocInitial extends UserProfileBlocState {}
final class UserProfileLoading extends UserProfileBlocState {}
final class UserProfileLoaded extends UserProfileBlocState{
  final UserProfileEntities userProfiles;
  UserProfileLoaded(this.userProfiles);
  @override
  List<Object> get props => [userProfiles];
}

final class UserProfileAdded extends UserProfileBlocState{
  final String message;
  UserProfileAdded(this.message);

  @override
  List<Object> get props => [message];
}
final class SingleUserProfileUpdated extends UserProfileBlocState{
  final String message;
  SingleUserProfileUpdated(this.message);

  @override
  List<Object> get props => [message];
}

final class UserProfileUpdated extends UserProfileBlocState{
  final String message;
  UserProfileUpdated(this.message);

  @override
  List<Object> get props => [message];
}

final class UserProfileDeleted extends UserProfileBlocState{

  final String message;
  UserProfileDeleted(this.message);

  @override
  List<Object> get props => [message];
}

final class UserStatusLoaded extends UserProfileBlocState{
  final UserStatusEntities userStatus;
  UserStatusLoaded(this.userStatus);

  @override
  List<Object> get props => [userStatus];
}

final class UserProfileGetError extends UserProfileBlocState{
  final message;
  UserProfileGetError(this.message);
  @override
  List<Object> get props => [message];
}
final class UserProfileAddError extends UserProfileBlocState{
  final message;
  UserProfileAddError(this.message);
  @override
  List<Object> get props => [message];
}

final class UserProfileUpdateError extends UserProfileBlocState{
  final message;
  UserProfileUpdateError(this.message);
  @override
  List<Object> get props => [message];
}
final class UserProfileDeleteError extends UserProfileBlocState{
  final message;
  UserProfileDeleteError(this.message);
  @override
  List<Object> get props => [message];
}
final class UserProfileSingleUpdateError extends UserProfileBlocState{
  final String message;
  UserProfileSingleUpdateError(this.message);

  @override
  List<Object> get props => [message];
}
final class UserStatusError extends UserProfileBlocState{
  final message;
  UserStatusError(this.message);
  @override
  List<Object> get props => [message];
}
