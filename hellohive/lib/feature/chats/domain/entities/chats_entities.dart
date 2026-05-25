import 'package:equatable/equatable.dart';

class ChatsEntities extends Equatable{
  final String id;
  final String userAId;
  final String userBId;
  final Map<String, int> unreadCount;
  final Map<String, bool> mutedBy;
  final Map<String, bool> deletedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastMessageId;
  final String? lastMessageText;
  final DateTime? lastMessageTime;

  ChatsEntities({
    required this.id,
    required this.userAId,
    required this.userBId,
    required this.unreadCount,
    required this.mutedBy,
    required this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessageId,
    this.lastMessageText,
    this.lastMessageTime,
  });
  @override
  List<Object?> get props => [
    id,
    userAId,
    userBId,
    unreadCount,
    mutedBy,
    deletedBy,
    createdAt,
    updatedAt,
    lastMessageId,
    lastMessageText,
    lastMessageTime,
  ];
}

class ChatMessageEntities extends Equatable{
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final MessageType type;
  final MessageStatus status;
  final Map<String, bool> deletedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? text;
  final String? mediaUrl;
  final String? repliedMessageId;

  @override
  ChatMessageEntities({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.status,
    required this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    this.text,
    this.mediaUrl,
    this.repliedMessageId,
    

  });

  @override
  List<Object?> get props => [
    id,
    chatId,
    senderId,
    receiverId,
    type,
    status,
    deletedBy,
    createdAt,
    updatedAt,
    text,
    mediaUrl,
    repliedMessageId,

  ];
}

enum MessageStatus{
  pending,
  sent,
  read,
  failed
}

enum MessageType{
  text,
  video,
  image,
  audio,
  file,
}