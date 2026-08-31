
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/chats_core/chats_message_core.dart';
import 'package:hellohive/feature/chats/data/models/chat_message_hive_model.dart';
import 'package:hellohive/feature/chats/data/models/message_model.dart';

abstract class MessageLocalDS {
  // Read
  Stream<List<ChatMessageModel>> listenMessages(
    ChatIdParams params,
  );

  Future<List<ChatMessageModel>> getMessages(
    ChatIdParams params,
  );

  Future<ChatMessageModel?> getMessageById(
    String messageId,
  );

  Future<ChatMessageModel> getLastMessage(
    ChatIdParams params,
  );

  // Local mutations
  Future<ChatMessageModel> createPendingMessage(
    SendMessageParams params,
  );

  Future<ActionStatus> editMessage(
    EditMessageParams params,
  );

  Future<ActionStatus> deleteMessage(
    DeleteMessageParams params,
  );

  Future<ActionStatus> markMessageAsRead(
    MarkMessageAsReadParams params,
  );

  // Remote → local
  Future<ActionStatus> cacheMessage(
    ChatMessageModel message,
  );

  Future<ActionStatus> cacheMessages(
    List<ChatMessageModel> messages,
  );

  // Sync queue
  Future<List<MessageSyncOperation>> getPendingOperations();

  Future<void> removePendingOperation(
    String operationId,
  );

  Future<void> markMessageAsSent(
    String messageId,
  );
}