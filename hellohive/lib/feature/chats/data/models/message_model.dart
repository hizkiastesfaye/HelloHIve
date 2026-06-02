

import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';

class ChatMessageModel extends ChatMessageEntities{

  ChatMessageModel({
  required String id,
  required String chatId,
  required String senderId,
  required String receiverId,
  required bool isEdited,
  required MessageType type,
  required MessageStatus status,
  required Map<String, bool> deletedBy,
  required DateTime createdAt,
  required DateTime updatedAt,
  String? text,
  String? mediaUrl,
  String? repliedMessageId,
  DateTime? editedAt,
  }) : super(
    id: id,
    chatId: chatId,
    senderId: senderId,
    receiverId: receiverId,
    isEdited: isEdited,
    type: type,
    status: status,
    deletedBy: deletedBy,
    createdAt: createdAt,
    updatedAt: updatedAt,
    text: text,
    mediaUrl: mediaUrl,
    repliedMessageId: repliedMessageId,
    editedAt: editedAt   
  );

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      isEdited: json['isEdited'],
      type: MessageType.values.firstWhere((e) => e.toString() == 'MessageType.${json['type']}'),
      status: MessageStatus.values.firstWhere((e) => e.toString() == 'MessageStatus.${json['status']}'),
      deletedBy: Map<String, bool>.from(json['deletedBy']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      text: json['text'],
      mediaUrl: json['mediaUrl'],
      repliedMessageId: json['repliedMessageId'],
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'isEdited': isEdited,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'deletedBy': deletedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'text': text,
      'mediaUrl': mediaUrl,
      'repliedMessageId': repliedMessageId,
      'editedAt': editedAt?.toIso8601String(),
    };
  }
}