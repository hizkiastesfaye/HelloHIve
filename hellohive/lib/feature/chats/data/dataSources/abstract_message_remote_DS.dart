
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/chats_core/chats_message_core.dart';
import 'package:hellohive/feature/chats/data/models/message_model.dart';

abstract class MessageRemoteDS {
  /// Create message directly in Firebase.
  Future<ActionStatus> sendMessage(
    SendMessageParams params,
  );

  /// Listen to messages from Firebase.
  ///
  /// This will later be used by
  /// MessageSyncServiceFromRemoteToLocal.
  Stream<List<ChatMessageModel>> listenMessages(
    ChatIdParams params,
  );

  /// Get the last message from Firebase.
  Future<ChatMessageModel> getLastMessage(
    ChatIdParams params,
  );

  /// Edit message directly in Firebase.
  Future<ActionStatus> editMessage(
    EditMessageParams params,
  );

  /// Delete message directly in Firebase.
  Future<ActionStatus> deleteMessage(
    DeleteMessageParams params,
  );

  /// Mark message as read directly in Firebase.
  Future<ActionStatus> markMessageAsRead(
    MarkMessageAsReadParams params,
  );

  /// Get a specific message from Firebase.
  Future<ChatMessageModel?> getMessageById(
    String messageId,
  );

  /// Get messages from Firebase.
  Future<List<ChatMessageModel>> getMessages(
    ChatIdParams params,
  );

  Future<ActionStatus> syncCreateMessage(
  ChatMessageModel message,
);
}