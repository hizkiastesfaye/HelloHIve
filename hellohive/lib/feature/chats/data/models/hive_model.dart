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
  String id;
  String userAId;
  String userBId;
  Map<String, int> unreadCount;
  Map<String, bool> mutedBy;
  Map<String, bool> deletedBy;
  DateTime createdAt;
  DateTime updatedAt;
  String? lastMessageId;
  String? lastMessageText;
  DateTime? lastMessageTime;
  }) {
    return ChatHiveModel(
      id: id,
      userAId: userAId,
      userBId: userBId,
      unreadCount: unreadCount ?? this.unreadCount,
      mutedBy: mutedBy ?? this.mutedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessageId: lastMessageId,
      lastMessageText: lastMessageText,
      lastMessageTime: lastMessageTime,
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