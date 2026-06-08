
import 'package:equatable/equatable.dart';

enum ActionStatus{
  pending,
  success,
  failed,
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

