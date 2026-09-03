import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/exception.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/chats_core/chats_message_core.dart';
import 'package:hellohive/feature/chats/data/models/chat_message_hive_model.dart';
import 'package:hellohive/feature/chats/data/models/message_model.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/message_entities.dart';
import 'abstract_message_local_DS.dart';

class MessageLocalDSImpl implements MessageLocalDS {
  final Box<ChatMessageHiveModel> messagesBox;
  final Box<MessageSyncOperation> messageOperationsBox;

  MessageLocalDSImpl({
    required this.messagesBox,
    required this.messageOperationsBox,
  });

  // ============================================================
  // LISTEN MESSAGES
  // ============================================================

  @override
  Stream<List<ChatMessageModel>> listenMessages(
    ChatIdParams params,
  ) async* {
    try {
      // Emit immediately from Hive.
      yield _getMessagesFromBox(params.chatId);

      // Then emit whenever Hive changes.
      yield* messagesBox.watch().map((_) {
        return _getMessagesFromBox(params.chatId);
      });
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  // ============================================================
  // GET MESSAGES
  // ============================================================

  @override
  Future<List<ChatMessageModel>> getMessages(
    ChatIdParams params,
  ) async {
    try {
      return _getMessagesFromBox(params.chatId);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  // ============================================================
  // GET MESSAGE BY ID
  // ============================================================

  @override
  Future<ChatMessageModel?> getMessageById(
    String messageId,
  ) async {
    try {
      final message = messagesBox.get(messageId);

      return message?.toModel();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  // ============================================================
  // GET LAST MESSAGE
  // ============================================================

  @override
  Future<ChatMessageModel> getLastMessage(
    ChatIdParams params,
  ) async {
    try {
      final messages = _getMessagesFromBox(params.chatId);

      if (messages.isEmpty) {
        throw CacheException('No messages found');
      }

      return messages.first;
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }

      throw CacheException(e.toString());
    }
  }

  // ============================================================
  // CREATE PENDING MESSAGE
  // ============================================================

  @override
  Future<ChatMessageModel> createPendingMessage(
    SendMessageParams params,
  ) async {
    try {
      // print('1sending message to pending');
      final now = DateTime.now();

      final message = ChatMessageModel(
        id: _generateMessageId(
          params.senderId,
          now,
        ),
        chatId: params.chatId,
        senderId: params.senderId,
        receiverId: params.receiverId,
        isEdited: false,
        type: params.type,
        status: MessageStatus.pending,
        deletedBy: {},
        createdAt: now,
        updatedAt: now,
        text: params.text,
        mediaUrl: params.mediaUrl,
        repliedMessageId: params.repliedMessageId,
      );
      
      await messagesBox.put(
        message.id,
        message.toHive(),
      );
      // print('2sending message to pending');

      final operation = MessageSyncOperation(
        id: _generateOperationId(),
        operation: MessageSyncOperationType.createMessage,
        messageId: message.id,
        chatId: message.chatId,
        payload: message.toJson(),
        createdAt: now,
      );

      await messageOperationsBox.put(
        operation.id,
        operation,
      );
      // print('2.1 sending message to pending');


      return message;
    } catch (e) {
      // print('3sending message to pending');
      // print('3sending message to pending');
      // print(e.toString());
      // print('3sending message to pending');
      // print('3sending message to pending');
      throw CacheException(e.toString());
    }
  }

  // ============================================================
  // EDIT MESSAGE
  // ============================================================

  @override
  Future<ActionStatus> editMessage(
    EditMessageParams params,
  ) async {
    try {
      final existing = messagesBox.get(params.messageId);

      if (existing == null) {
        throw CacheException('Message not found');
      }

      final now = DateTime.now();

      final updatedMessage = ChatMessageModel(
        id: existing.id,
        chatId: existing.chatId,
        senderId: existing.senderId,
        receiverId: existing.receiverId,
        isEdited: true,
        type: MessageType.values.byName(existing.type),
        status: MessageStatus.values.byName(existing.status),
        deletedBy: Map<String, bool>.from(existing.deletedBy),
        createdAt: existing.createdAt,
        updatedAt: now,
        text: params.newText,
        mediaUrl: existing.mediaUrl,
        repliedMessageId: existing.repliedMessageId,
        editedAt: now,
      );

      await messagesBox.put(
        updatedMessage.id,
        updatedMessage.toHive(),
      );

      final operation = MessageSyncOperation(
        id: _generateOperationId(),
        operation: MessageSyncOperationType.editMessage,
        messageId: updatedMessage.id,
        chatId: updatedMessage.chatId,
        payload: {
          'text': updatedMessage.text,
          'isEdited': updatedMessage.isEdited,
          'editedAt': updatedMessage.editedAt?.toIso8601String(),
          'updatedAt': updatedMessage.updatedAt.toIso8601String(),
        },
        createdAt: now,
      );

      await messageOperationsBox.put(
        operation.id,
        operation,
      );

      return ActionStatus.pending;
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }

      throw CacheException(e.toString());
    }
  }

  // ============================================================
  // DELETE MESSAGE
  // ============================================================

  @override
  Future<ActionStatus> deleteMessage(
    DeleteMessageParams params,
  ) async {
    try {
      final existing = messagesBox.get(params.messageId);

      if (existing == null) {
        throw CacheException('Message not found');
      }

      final now = DateTime.now();

      final deletedBy = Map<String, bool>.from(
        existing.deletedBy,
      );

      deletedBy[params.userId] = true;

      final updatedMessage = ChatMessageModel(
        id: existing.id,
        chatId: existing.chatId,
        senderId: existing.senderId,
        receiverId: existing.receiverId,
        isEdited: existing.isEdited,
        type: MessageType.values.byName(existing.type),
        status: MessageStatus.values.byName(existing.status),
        deletedBy: deletedBy,
        createdAt: existing.createdAt,
        updatedAt: now,
        text: existing.text,
        mediaUrl: existing.mediaUrl,
        repliedMessageId: existing.repliedMessageId,
        editedAt: existing.editedAt,
      );

      await messagesBox.put(
        updatedMessage.id,
        updatedMessage.toHive(),
      );

      final operation = MessageSyncOperation(
        id: _generateOperationId(),
        operation: MessageSyncOperationType.deleteMessage,
        messageId: updatedMessage.id,
        chatId: updatedMessage.chatId,
        payload: {
          'userId': params.userId,
          'updatedAt': now.toIso8601String(),
        },
        createdAt: now,
      );

      await messageOperationsBox.put(
        operation.id,
        operation,
      );

      return ActionStatus.pending;
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }

      throw CacheException(e.toString());
    }
  }

  // ============================================================
  // MARK MESSAGE AS READ
  // ============================================================

  @override
  Future<ActionStatus> markMessageAsRead(
    MarkMessageAsReadParams params,
  ) async {
    try {
      final existing = messagesBox.get(params.messageId);

      if (existing == null) {
        throw CacheException('Message not found');
      }

      final now = DateTime.now();

      final updatedMessage = ChatMessageModel(
        id: existing.id,
        chatId: existing.chatId,
        senderId: existing.senderId,
        receiverId: existing.receiverId,
        isEdited: existing.isEdited,
        type: MessageType.values.byName(existing.type),
        status: MessageStatus.values.byName(existing.status),
        deletedBy: Map<String, bool>.from(existing.deletedBy),
        createdAt: existing.createdAt,
        updatedAt: now,
        text: existing.text,
        mediaUrl: existing.mediaUrl,
        repliedMessageId: existing.repliedMessageId,
        editedAt: existing.editedAt,
      );

      await messagesBox.put(
        updatedMessage.id,
        updatedMessage.toHive(),
      );

      final operation = MessageSyncOperation(
        id: _generateOperationId(),
        operation: MessageSyncOperationType.markMessageAsRead,
        messageId: updatedMessage.id,
        chatId: updatedMessage.chatId,
        payload: {
          'userId': params.userId,
          'updatedAt': now.toIso8601String(),
        },
        createdAt: now,
      );

      await messageOperationsBox.put(
        operation.id,
        operation,
      );

      return ActionStatus.pending;
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }

      throw CacheException(e.toString());
    }
  }

  // ============================================================
  // CACHE ONE MESSAGE
  // ============================================================

  @override
  Future<ActionStatus> cacheMessage(
    ChatMessageModel message,
  ) async {
    try {
      await messagesBox.put(
        message.id,
        message.toHive(),
      );

      return ActionStatus.success;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  // ============================================================
  // CACHE MANY MESSAGES
  // ============================================================

  @override
  Future<ActionStatus> cacheMessages(
    List<ChatMessageModel> messages,
  ) async {
    try {
      if (messages.isEmpty) {
        return ActionStatus.success;
      }

      await messagesBox.putAll({
        for (final message in messages)
          message.id: message.toHive(),
      });

      return ActionStatus.success;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  // ============================================================
  // GET PENDING OPERATIONS
  // ============================================================

  @override
  Future<List<MessageSyncOperation>> getPendingOperations() async {
    try {
      final operations =
          messageOperationsBox.values.toList();

      operations.sort(
        (a, b) => a.createdAt.compareTo(b.createdAt),
      );

      return operations;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  // ============================================================
  // REMOVE PENDING OPERATION
  // ============================================================

  @override
  Future<void> removePendingOperation(
    String operationId,
  ) async {
    try {
      await messageOperationsBox.delete(operationId);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  // ============================================================
  // MARK MESSAGE AS SENT
  // ============================================================

  @override
  Future<void> markMessageAsSent(
    String messageId,
  ) async {
    try {
      final existing = messagesBox.get(messageId);

      if (existing == null) {
        throw CacheException('Message not found');
      }

      final updated = ChatMessageHiveModel(
        id: existing.id,
        chatId: existing.chatId,
        senderId: existing.senderId,
        receiverId: existing.receiverId,
        isEdited: existing.isEdited,
        type: existing.type,
        status: MessageStatus.sent.name,
        deletedBy: Map<String, bool>.from(
          existing.deletedBy,
        ),
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
        text: existing.text,
        mediaUrl: existing.mediaUrl,
        repliedMessageId: existing.repliedMessageId,
        editedAt: existing.editedAt,
      );

      await messagesBox.put(
        messageId,
        updated,
      );
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }

      throw CacheException(e.toString());
    }
  }

  // ============================================================
  // HELPERS
  // ============================================================

  List<ChatMessageModel> _getMessagesFromBox(
    String chatId,
  ) {
    return messagesBox.values
        .where(
          (message) => message.chatId == chatId,
        )
        .map((message) => message.toModel())
        .toList()
      ..sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );
  }

  String _generateMessageId(
    String senderId,
    DateTime timestamp,
  ) {
    return '${senderId}_${timestamp.microsecondsSinceEpoch}';
  }

  String _generateOperationId() {
    return DateTime.now()
        .microsecondsSinceEpoch
        .toString();
  }
}