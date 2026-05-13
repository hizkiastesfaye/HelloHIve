part of 'friends_bloc.dart';

@immutable
sealed class FriendsEvent extends Equatable{
  @override
  List<Object> get props=> [];
}

class GetFriendsEvent extends FriendsEvent{
  final String fieldName;
  final String value;
  GetFriendsEvent({
    required this.fieldName,
    required this.value,
  });
  @override
  List<Object> get props => [fieldName,value];
}

class GetRandomFriendsEvent extends FriendsEvent{}