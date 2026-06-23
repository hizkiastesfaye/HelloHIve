part of 'chats_bloc.dart';

@immutable
sealed class ChatsState  extends Equatable{
  @override
  List<Object> get props => [];
}

final class ChatsInitial extends ChatsState {}
final class ChatsLoading extends ChatsState {}

final class ChatCreated extends ChatsState{
  final String message;
  ChatCreated(this.message);
  @override
  List<Object> get props => [message];
}

final class WatchChats extends ChatsState{
  final List<ChatsEntities> chats;
  WatchChats(this.chats);
  @override
  List<Object> get props => [chats];
}

final class ChatLoadedById extends ChatsState{
  final ChatsEntities chat;
  ChatLoadedById(this.chat);
  @override
  List<Object> get props => [chat];
}

final class ChatsLoaded extends ChatsState{
  final List<ChatsEntities> chats;
  ChatsLoaded(this.chats);
  @override
  List<Object> get props => [chats];
}

final class ChatLoaded extends ChatsState{
  final ChatsEntities chat;
  ChatLoaded(this.chat);
  @override
  List<Object> get props => [chat];
}

final class ChatUpdated extends ChatsState{
  final String message;
  ChatUpdated(this.message);
  @override
  List<Object> get props => [message];
}

final class ChatDeleted extends ChatsState{
  final String message;
  ChatDeleted(this.message);
  @override
  List<Object> get props => [message];
}

final class ChatMuted extends ChatsState{
  final String message;
  ChatMuted(this.message);
  @override
  List<Object> get props => [message];
}

final class ChatLastMessageUpdated extends ChatsState{
  final String message;
  ChatLastMessageUpdated(this.message);
  @override
  List<Object> get props => [message];
}

final class ChatSynced extends ChatsState{
  final String message;
  ChatSynced(this.message);

  @override
  List<Object> get props => [message];
}

final class ChatsError extends ChatsState{
  final String message;
  ChatsError(this.message);
  @override
  List<Object> get props => [message];
}