import 'package:hellohive/feature/chats/data/dataSources/abstract_message_local_DS.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_message_remote_DS.dart';
import 'package:hellohive/feature/chats/data/models/chat_message_hive_model.dart';
import 'package:hellohive/feature/chats/chats_core/chats_message_core.dart';
import 'package:hellohive/feature/chats/data/models/message_model.dart';

abstract class MessageSyncServiceFromLocalToRemote {
  /// Syncs all pending local operations to Firebase.
  Future<void> sync();

  /// Stops the sync service.
  Future<void> dispose();
}

class MessageSyncServiceFromLocalToRemoteImpl
    implements MessageSyncServiceFromLocalToRemote {
  final MessageLocalDS localDatasource;
  final MessageRemoteDS remoteDatasource;

  MessageSyncServiceFromLocalToRemoteImpl({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  bool _isSyncing = false;

  @override
  Future<void> sync() async {
    // Prevent multiple sync processes from running simultaneously.
    if (_isSyncing) {
      return;
    }

    _isSyncing = true;

    try {
      final operations =
          await localDatasource.getPendingOperations();

      for (final operation in operations) {
        try {
          await _processOperation(operation);

          // IMPORTANT:
          // Remove using operation.id, NOT messageId.
          await localDatasource.removePendingOperation(
            operation.id,
          );
        } catch (_) {
          // Stop here.

          // The operation remains in Hive and will
          // be retried on the next sync.
          break;
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processOperation(
    MessageSyncOperation operation,
  ) async {
    switch (operation.operation) {
      case MessageSyncOperationType.createMessage:
        await _syncCreateMessage(operation);
        break;

      case MessageSyncOperationType.editMessage:
        await _syncEditMessage(operation);
        break;

      case MessageSyncOperationType.deleteMessage:
        await _syncDeleteMessage(operation);
        break;

      case MessageSyncOperationType.markMessageAsRead:
        await _syncMarkMessageAsRead(operation);
        break;
    }
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------

  Future<void> _syncCreateMessage(
    MessageSyncOperation operation,
  ) async {
    final message = ChatMessageModel.fromJson(
      Map<String, dynamic>.from(operation.payload),
    );

    await remoteDatasource.syncCreateMessage(
      message,
    );

    await localDatasource.markMessageAsSent(
      message.id,
    );
  }

  // ------------------------------------------------------------
  // EDIT
  // ------------------------------------------------------------

  Future<void> _syncEditMessage(
    MessageSyncOperation operation,
  ) async {
    final payload =
        Map<String, dynamic>.from(operation.payload);

    final params = EditMessageParams(
      messageId: operation.messageId,
      chatId: operation.chatId,
      newText: payload['text'] as String,
    );

    await remoteDatasource.editMessage(
      params,
    );
  }

  // ------------------------------------------------------------
  // DELETE
  // ------------------------------------------------------------

  Future<void> _syncDeleteMessage(
    MessageSyncOperation operation,
  ) async {
    final payload =
        Map<String, dynamic>.from(operation.payload);

    final params = DeleteMessageParams(
      messageId: operation.messageId,
      userId: payload['userId'] as String,
    );

    await remoteDatasource.deleteMessage(
      params,
    );
  }

  // ------------------------------------------------------------
  // MARK AS READ
  // ------------------------------------------------------------

  Future<void> _syncMarkMessageAsRead(
    MessageSyncOperation operation,
  ) async {
    final payload =
        Map<String, dynamic>.from(operation.payload);

    final params = MarkMessageAsReadParams(
      messageId: operation.messageId,
      userId: payload['userId'] as String,
    );

    await remoteDatasource.markMessageAsRead(
      params,
    );
  }

  @override
  Future<void> dispose() async {
    // Nothing currently needs to be cancelled because
    // sync() itself is request-based rather than stream-based.
    _isSyncing = false;
  }
}