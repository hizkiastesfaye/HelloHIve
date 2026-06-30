part of 'chats_bloc.dart';

@immutable
sealed class ChatsEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class CreateChatEvent extends ChatsEvent{
  final String currentUserId;
  final String userBId;

  CreateChatEvent({
    required this.currentUserId,
    required this.userBId,
  });

  @override
  List<Object> get props => [currentUserId,userBId];
}

class GetChatEvent extends ChatsEvent{
  final String currentUserId;
  final String userBId;

  GetChatEvent({
    required this.currentUserId,
    required this.userBId,
  });

  @override
  List<Object> get props => [currentUserId,userBId];
}

class WatchChatsEvent extends ChatsEvent{
  final String userId;

  WatchChatsEvent({
    required this.userId,
  });

  @override
  List<Object> get props => [userId];
}

class GetChatByIdEvent extends ChatsEvent{
  final String chatId;

  GetChatByIdEvent({
    required this.chatId,
  });

  @override
  List<Object> get props => [chatId];
}

class GetChatsEvent extends ChatsEvent{
  final String userId;
  GetChatsEvent({
    required this.userId,
  });
  @override
  List<Object> get props => [userId];
}

class UpdateChatEvent extends ChatsEvent{
  final String id;
  final String userAId;
  final String userBId;
  final Map<String, int> unreadCount;
  final Map<String, bool> mutedBy;
  final Map<String, bool> deletedBy;
  final String? lastMessageId;
  final String? lastMessageText;
  final DateTime? lastMessageTime;

  UpdateChatEvent({
    required this.id,
    required this.userAId,
    required this.userBId,
    required this.unreadCount,
    required this.mutedBy,
    required this.deletedBy,
    this.lastMessageId,
    this.lastMessageText,
    this.lastMessageTime,

  });

  @override
  List<Object> get props => [id,userAId,userBId,unreadCount,mutedBy,deletedBy,lastMessageId ?? '',lastMessageText ?? '',lastMessageTime ?? ''];
}

class DeleteChatEvent extends ChatsEvent{
  final String chatId;
  final String userId;

  DeleteChatEvent({
    required this.chatId,
    required this.userId,
  });

  @override
  List<Object> get props => [chatId,userId];
}

class MuteChatEvent extends ChatsEvent{
  final String currentUserId;
  final String chatId;
  final bool isMuted;

  MuteChatEvent({
    required this.currentUserId,
    required this.chatId,
    required this.isMuted,
  });

  @override
  List<Object> get props => [currentUserId,chatId,isMuted];
}

class UpdateLastMessageEvent extends ChatsEvent{
  final String chatId;
  final String lastMessageId;
  final String lastMessageText;
  final String lastMessageTime;

  UpdateLastMessageEvent({
    required this.chatId,
    required this.lastMessageId,
    required this.lastMessageText,
    required this.lastMessageTime,
  });

  @override
  List<Object> get props => [chatId,lastMessageId,lastMessageText,lastMessageTime];
}

class ChatSyncEvent extends ChatsEvent{
  final String userId;
  ChatSyncEvent(this.userId);

  @override
  List<Object> get props => [userId];
}