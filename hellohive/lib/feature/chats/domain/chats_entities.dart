import 'package:equatable/equatable.dart';

class ChatsEntities extends Equatable{
  final String id;
  final String userAId;
  final String userBId;
  final String? lastMessageId;
  final String? lastMessageText;
  final DateTime? lastMessageTime;

  final Map<String, int> unreadCount;
  final Map<String, bool> mutedBy;
  final Map<String, bool> deletedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatsEntities({
    required this.id,
    required this.userAId,
    required this.userBId,
    this.lastMessageId,
    this.lastMessageText,
    this.lastMessageTime,
    required this.unreadCount,
    required this.mutedBy,
    required this.deletedBy,
    required this.createdAt,
    required this.updatedAt
  });
  @override
  List<Object?> get props => [
    id,
    userAId,
    userBId,
    lastMessageId,
    lastMessageText,
    lastMessageTime,
    unreadCount,
    mutedBy,
    deletedBy,
    createdAt,
    updatedAt
  ];
}

class ChatMessageEntities extends Equatable{
  final String id;
  final String chatId;

  final String senderId;
  final String receiverId;

  final String type;

  final String? text;
  final String? mediaUrl;

  final String? repliedMessageId;

  final DateTime createdAt;
  final DateTime? updatedAt;

  final MessageStatus status;

  final Map<String, bool> deletedBy;

  @override
  ChatMessageEntities({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.type,
    this.text,
    this.mediaUrl,
    this.repliedMessageId,
    required this.createdAt,
    this.updatedAt,
    required this.status,
    required this.deletedBy
  });

  @override
  List<Object?> get props => [
    id,
    chatId,
    senderId,
    receiverId,
    type,
    text,
    mediaUrl,
    repliedMessageId,
    createdAt,
    updatedAt,
    status,
    deletedBy
  ];
}

enum MessageStatus{
  sent,
  read,
  failed
}