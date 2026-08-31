import 'package:equatable/equatable.dart';

class ChatMessageEntities extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;

  final bool isEdited;

  final MessageType type;
  final MessageStatus status;

  final Map<String, bool> deletedBy;

  final DateTime createdAt;
  final DateTime updatedAt;

  final String? text;
  final String? mediaUrl;
  final String? repliedMessageId;
  final DateTime? editedAt;

  const ChatMessageEntities({
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

  @override
  List<Object?> get props => [
        id,
        chatId,
        senderId,
        receiverId,
        isEdited,
        type,
        status,
        deletedBy,
        createdAt,
        updatedAt,
        text,
        mediaUrl,
        repliedMessageId,
        editedAt,
      ];
}

enum MessageStatus {
  pending,
  sent,
  read,
  failed,
}

enum MessageType {
  text,
  video,
  image,
  audio,
  file,
}