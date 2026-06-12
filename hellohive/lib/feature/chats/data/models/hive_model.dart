import 'package:hellohive/feature/chats/data/models/chats_model.dart';
import 'package:hive/hive.dart';

part 'hive_model.g.dart';

@HiveType(typeId: 0)
class ChatHiveModel extends ChatModel {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String userAId;

  @HiveField(2)
  @override
  final String userBId;

  @HiveField(3)
  @override
  final Map<String, int> unreadCount;

  @HiveField(4)
  @override
  final Map<String, bool> mutedBy;

  @HiveField(5)
  @override
  final Map<String, bool> deletedBy;

  @HiveField(6)
  @override
  final DateTime createdAt;

  @HiveField(7)
  @override
  final DateTime updatedAt;

  @HiveField(8)
  @override
  final String? lastMessageId;

  @HiveField(9)
  @override
  final String? lastMessageText;

  @HiveField(10)
  @override
  final DateTime? lastMessageTime;

  ChatHiveModel({
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
  }) : super(
          id: id,
          userAId: userAId,
          userBId: userBId,
          unreadCount: unreadCount,
          mutedBy: mutedBy,
          deletedBy: deletedBy,
          createdAt: createdAt,
          updatedAt: updatedAt,
          lastMessageId: lastMessageId,
          lastMessageText: lastMessageText,
          lastMessageTime: lastMessageTime,
        );

  ChatHiveModel copyWith({
  String? id,
  String? userAId,
  String? userBId,
  Map<String, int>? unreadCount,
  Map<String, bool>? mutedBy,
  Map<String, bool>? deletedBy,
  DateTime? createdAt,
  DateTime? updatedAt,
  String? lastMessageId,
  String? lastMessageText,
  DateTime? lastMessageTime,
  }) {
    return ChatHiveModel(
      id: id ?? this.id,
      userAId: userAId ?? this.userAId,
      userBId: userBId ?? this.userBId,
      unreadCount: unreadCount ?? this.unreadCount,
      mutedBy: mutedBy ?? this.mutedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageText: lastMessageText ?? this.lastMessageText,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }
}

extension ChatHiveModelMapper on ChatHiveModel {
  ChatModel toDomain() {
    return ChatModel(
      id: id,
      userAId: userAId,
      userBId: userBId,
      unreadCount: unreadCount,
      mutedBy: mutedBy,
      deletedBy: deletedBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastMessageId: lastMessageId,
      lastMessageText: lastMessageText,
      lastMessageTime: lastMessageTime,
    );
  }
}

extension ChatModelMapper on ChatModel {
  ChatHiveModel toHive({String? hiveId, bool isPendingSync = false}) {
    return ChatHiveModel( // Use domain ID as Hive ID if not provided
      id: id,
      userAId: userAId,
      userBId: userBId,
      unreadCount: unreadCount,
      mutedBy: mutedBy,
      deletedBy: deletedBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastMessageId: lastMessageId,
      lastMessageText: lastMessageText,
      lastMessageTime: lastMessageTime,
    );
  }
}





@HiveType(typeId: 10)
class ChatSyncOperation extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final SyncOperationType operation;

  @HiveField(2)
  final String chatId;

  @HiveField(3)
  final Map<String,dynamic> payload;

  @HiveField(4)
  final DateTime createdAt;

  ChatSyncOperation({
    required this.id,
    required this.operation,
    required this.chatId,
    required this.payload,
    required this.createdAt,
  });
}

enum SyncOperationType {
  createChat,
  updateChat,
  deleteChat,
  muteChat,
}