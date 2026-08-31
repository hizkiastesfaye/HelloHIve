import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';

class ChatMessageModel extends ChatMessageEntities {
  const ChatMessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.receiverId,
    required super.isEdited,
    required super.type,
    required super.status,
    required super.deletedBy,
    required super.createdAt,
    required super.updatedAt,
    super.text,
    super.mediaUrl,
    super.repliedMessageId,
    super.editedAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      isEdited: json['isEdited'] as bool,
      type: MessageType.values.byName(
        json['type'] as String,
      ),
      status: MessageStatus.values.byName(
        json['status'] as String,
      ),
      deletedBy: Map<String, bool>.from(
        json['deletedBy'] ?? {},
      ),
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] as String,
      ),
      text: json['text'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      repliedMessageId: json['repliedMessageId'] as String?,
      editedAt: json['editedAt'] != null
          ? DateTime.parse(json['editedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'isEdited': isEdited,
      'type': type.name,
      'status': status.name,
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