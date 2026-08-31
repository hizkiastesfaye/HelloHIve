
import 'package:equatable/equatable.dart';
import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';

class SendMessageParams extends Equatable {
  final String chatId;
  final String senderId;
  final String receiverId;

  final MessageType type;

  final String? text;
  final String? mediaUrl;
  final String? repliedMessageId;

  SendMessageParams({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.type,
    this.text,
    this.mediaUrl,
    this.repliedMessageId,
  });

  @override
  List<Object?> get props => [
        chatId,
        senderId,
        receiverId,
        type,
        text,
        mediaUrl,
        repliedMessageId,
      ];
}

// enum MessageType{
//   text,
//   video,
//   image,
//   audio,
//   file,
// }

class MessageIdParams extends Equatable{
  final String messageId;

  MessageIdParams({
    required this.messageId,
  });

  @override 
  List<Object> get props => [messageId];
}

class EditMessageParams extends Equatable {
  final String messageId;
  final String chatId;
  final String newText;

  EditMessageParams({
    required this.messageId,
    required this.chatId,
    required this.newText,
  });

  @override
  List<Object> get props => [
        messageId,
        chatId,
        newText,
      ];
}

class DeleteMessageParams extends Equatable {
  final String messageId;
  final String userId;

  DeleteMessageParams({
    required this.messageId,
    required this.userId,
  });

  @override
  List<Object> get props => [
        messageId,
        userId,
      ];
}

class MarkMessageAsReadParams extends Equatable {
  final String messageId;
  final String userId;

  MarkMessageAsReadParams({
    required this.messageId,
    required this.userId,
  });

  @override
  List<Object> get props => [
        messageId,
        userId,
      ];
}


