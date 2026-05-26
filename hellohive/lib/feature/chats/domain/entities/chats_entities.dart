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

