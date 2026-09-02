
import 'package:hellohive/feature/chats/data/models/message_model.dart';
import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';
import 'package:hive/hive.dart';

part 'chat_message_hive_model.g.dart';

// @HiveType(typeId: 25)
// enum MessageType {
//   @HiveField(0)
//   text,

//   @HiveField(1)
//   video,

//   @HiveField(2)
//   image,

//   @HiveField(3)
//   audio,

//   @HiveField(4)
//   file,
// }

// @HiveType(typeId: 26)
// enum MessageStatus {
//   @HiveField(0)
//   pending,
//   @HiveField(1)
//   sent,

//   @HiveField(2)
//   read,

//   @HiveField(3)
//   failed,
// }


@HiveType(typeId: 30)
class ChatMessageHiveModel extends HiveObject {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String chatId;

  @HiveField(2)
  @override
  final String senderId;

  @HiveField(3)
  @override
  final String receiverId;

  @HiveField(4)
  @override
  final bool isEdited;

  @HiveField(5)
  @override
  final String type;

  @HiveField(6)
  @override
  final String status;

  @HiveField(7)
  @override
  final Map<String, bool> deletedBy;

  @HiveField(8)
  @override
  final DateTime createdAt;

  @HiveField(9)
  @override
  final DateTime updatedAt;

  @HiveField(10)
  @override
  final String? text;

  @HiveField(11)
  @override
  final String? mediaUrl;

  @HiveField(12)
  @override
  final String? repliedMessageId;

  @HiveField(13)
  @override
  final DateTime? editedAt;

  ChatMessageHiveModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.isEdited,
    required this.type,
    required this.status,
    required this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    this.text,
    this.mediaUrl,
    this.repliedMessageId,
    this.editedAt,
  });
  // : super(
  //         id: id,
  //         chatId: chatId,
  //         senderId: senderId,
  //         receiverId: receiverId,
  //         isEdited: isEdited,
  //         type: type,
  //         status: status,
  //         deletedBy: deletedBy,
  //         createdAt: createdAt,
  //         updatedAt: updatedAt,
  //         text: text,
  //         mediaUrl: mediaUrl,
  //         repliedMessageId: repliedMessageId,
  //         editedAt: editedAt,
  //       );
}


extension ChatMessageHiveModelMapper on ChatMessageHiveModel {
  ChatMessageModel toModel() {
    // print('hive model to model');
    // print('hive model to model');
    // print('hive model to model');
    // print('hive model to model');
    // print('hive model to model');
    // print('${id}, ${chatId}, ${senderId}, ${receiverId}, ${isEdited}, ${type}, ${status}, ${deletedBy}, ${createdAt}, ${updatedAt}, ${text}, ${mediaUrl}, ${repliedMessageId}, ${editedAt}');
    return ChatMessageModel(
      id: id,
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      isEdited: isEdited,
      type: MessageType.values.byName(type),
      status: MessageStatus.values.byName(status),
      deletedBy: Map<String, bool>.from(deletedBy),
      createdAt: createdAt,
      updatedAt: updatedAt,
      text: text,
      mediaUrl: mediaUrl,
      repliedMessageId: repliedMessageId,
      editedAt: editedAt,
    );
  }
}

extension ChatMessageModelMapper on ChatMessageModel {
  ChatMessageHiveModel toHive() {
    return ChatMessageHiveModel(
      id: id,
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      isEdited: isEdited,
      type: type.name,
      status: status.name,
      deletedBy: Map<String, bool>.from(deletedBy),
      createdAt: createdAt,
      updatedAt: updatedAt,
      text: text,
      mediaUrl: mediaUrl,
      repliedMessageId: repliedMessageId,
      editedAt: editedAt,
    );
  }
}


@HiveType(typeId: 33)
enum MessageSyncOperationType {
  @HiveField(0)
  createMessage,

  @HiveField(1)
  editMessage,

  @HiveField(2)
  deleteMessage,

  @HiveField(3)
  markMessageAsRead,
}


@HiveType(typeId: 34)
class MessageSyncOperation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final MessageSyncOperationType operation;

  @HiveField(2)
  final String messageId;

  @HiveField(3)
  final String chatId;

  @HiveField(4)
  final Map<String, dynamic> payload;

  @HiveField(5)
  final DateTime createdAt;

  MessageSyncOperation({
    required this.id,
    required this.operation,
    required this.messageId,
    required this.chatId,
    required this.payload,
    required this.createdAt,
  });
}