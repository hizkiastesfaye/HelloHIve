part of 'friends_bloc.dart';

@immutable
sealed class FriendsState extends Equatable{
  @override
  List<Object> get props => [];
}

final class FriendsInitial extends FriendsState {}
final class FriendsLoading extends FriendsState {}

final class FriendsLoaded extends FriendsState{
  final List<FriendsEntities> friends;
  FriendsLoaded(this.friends);
  @override
  List<Object> get props => [friends];
}

final class RandomFriendsLoaded extends FriendsState{
  final List<FriendsEntities> friends;
  RandomFriendsLoaded(this.friends);
  @override
  List<Object> get props => [friends];
}

final class FriendsStateError extends FriendsState{
  final message;
  FriendsStateError(this.message);
  @override
  List<Object> get props => [message];
}