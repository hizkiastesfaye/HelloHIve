
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
  final Map<String, int> unreadCount;
  final Map<String, bool> mutedBy;
  final Map<String, bool> deletedBy;
  final String? lastMessageId;
  final String? lastMessageText;
  final DateTime? lastMessageTime;

  MostChatParams({
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
  List<Object> get props => [
    id, 
    userAId, 
    userBId, 
    unreadCount, 
    mutedBy, 
    deletedBy, 
    lastMessageId ?? '', 
    lastMessageText ?? '', 
    lastMessageTime ?? DateTime(0)];
}


class SendMessageParams extends Equatable{
  final String senderId;
  final String receiverId;
  final MessageType type;
  final String? text;
  final String? mediaUrl;
  final String? repliedMessageId;

  @override
  SendMessageParams({
    required this.senderId,
    required this.receiverId,
    required this.type,
    this.text,
    this.mediaUrl,
    this.repliedMessageId,
    
    

  });

  @override
  List<Object?> get props => [
    senderId,
    receiverId,
    type,
    text,
    mediaUrl,
    repliedMessageId,
  ];
}

enum MessageType{
  text,
  video,
  image,
  audio,
  file,
}

class MessageIdParams extends Equatable{
  final String messageId;

  MessageIdParams({
    required this.messageId,
  });

  @override 
  List<Object> get props => [messageId];
}

class EditMessageParams extends Equatable{
  final String messageId;
  final String text;

  EditMessageParams({
    required this.messageId,
    required this.text
  });

  @override 
  List<Object> get props => [messageId,text];
}

