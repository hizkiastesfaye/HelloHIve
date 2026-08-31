
import 'package:equatable/equatable.dart';

enum ActionStatus{
  pending,
  success,
  failed,
}

String generateChatId(String userAId, String userBId) {
  final users = [userAId, userBId]..sort();
  return '${users[0]}_${users[1]}';
}

class UsersChatParams extends Equatable{
  final String currentUserId;
  final String userBId;

  UsersChatParams({
    required this.currentUserId,
    required this.userBId
  });
  @override
  List<Object> get props => [currentUserId,userBId];
}


class UserIdParams extends Equatable{
  final String userId;

  UserIdParams({

    required this.userId
  });
  @override
  List<Object> get props => [userId];
}

class ChatIdParams extends Equatable{
  final String chatId;
  ChatIdParams({
    required this.chatId
  });
  @override
  List<Object> get props => [chatId];
}

class ChatIdUserIdParams extends Equatable{
  final String chatId;
  final String userId;

  ChatIdUserIdParams({
    required this.chatId,
    required this.userId,
  });

  @override
  List<Object> get props => [chatId,userId];
}

class MuteChatParams extends Equatable{
  final String currentUserId;
  final String chatId;
  final bool isMuted;

  MuteChatParams({
    required this.currentUserId,
    required this.chatId,
    required this.isMuted,
  });
  @override
  List<Object> get props => [currentUserId,chatId,isMuted];
}

class MostChatParams extends Equatable{
  final String id;
  final String userAId;
  final String userBId;
  final Map<String, bool> mutedBy;
  final Map<String, bool> deletedBy;
  final String? lastMessageId;
  final String? lastMessageText;
  final DateTime? lastMessageTime;

  MostChatParams({
    required this.id,
    required this.userAId,
    required this.userBId,
    required this.mutedBy,
    required this.deletedBy,
    this.lastMessageId,
    this.lastMessageText,
    this.lastMessageTime,
  });

  @override
  List<Object> get props => [
    id, 
    userAId, 
    userBId, 
    mutedBy, 
    deletedBy, 
    lastMessageId ?? '', 
    lastMessageText ?? '', 
    lastMessageTime ?? ''];
}


class UpdateLastMessageParams extends Equatable{
  final String chatId;
  final String lastMessageId;
  final String lastMessageText;
  final DateTime lastMessageTime;

  UpdateLastMessageParams({
    required this.chatId,
    required this.lastMessageId,
    required this.lastMessageText,
    required this.lastMessageTime,
  });

  @override
  List<Object> get props => [chatId, lastMessageId, lastMessageText, lastMessageTime];
}


