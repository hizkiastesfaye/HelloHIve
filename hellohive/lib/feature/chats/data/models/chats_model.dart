
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hellohive/feature/chats/domain/entities/chats_entities.dart';

class ChatModel extends ChatsEntities {
  ChatModel({
    required String id,
    required List<String> participants,
    required Map<String, int> unreadCount,
    required Map<String, bool> mutedBy,
    required Map<String, bool> deletedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? lastMessageId,
    String? lastMessageText,
    DateTime? lastMessageTime,
  }) : super(
    id: id,
    participants:participants,
    unreadCount: unreadCount,
    mutedBy: mutedBy,
    deletedBy: deletedBy,
    createdAt: createdAt,
    updatedAt: updatedAt,
    lastMessageId: lastMessageId,
    lastMessageText: lastMessageText,
    lastMessageTime: lastMessageTime,
  );

  factory ChatModel.fromJson(Map<String, dynamic> json) {
  return ChatModel(
    id: json['id'],
    participants: List<String>.from(json['participants']),
    unreadCount: Map<String, int>.from(json['unreadCount']),
    mutedBy: Map<String, bool>.from(json['mutedBy']),
    deletedBy: Map<String, bool>.from(json['deletedBy']),

    createdAt: (json['createdAt'] as Timestamp).toDate(),
    updatedAt: (json['updatedAt'] as Timestamp).toDate(),

    lastMessageId: json['lastMessageId'],
    lastMessageText: json['lastMessageText'],

    lastMessageTime: json['lastMessageTime'] != null
        ? (json['lastMessageTime'] as Timestamp).toDate()
        : null,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants':participants,
      'unreadCount': unreadCount,
      'mutedBy': mutedBy,
      'deletedBy': deletedBy,
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt.toIso8601String(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastMessageId': lastMessageId,
      'lastMessageText': lastMessageText,
      'lastMessageTime': lastMessageTime != null
        ? Timestamp.fromDate(lastMessageTime!)
        : null,
      // 'lastMessageTime': lastMessageTime?.toIso8601String(),
    };
  }

}