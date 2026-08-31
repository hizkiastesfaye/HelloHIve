import 'dart:async';

import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_local_Ds.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_message_local_DS.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_message_remote_DS.dart';
import 'package:hellohive/feature/chats/data/models/message_model.dart';

abstract class MessageSyncServiceFromRemoteToLocal {
  /// Starts/reconciles listeners for all locally known chats.
  Future<void> syncMessages();

  /// Stops all active listeners.
  Future<void> dispose();
}

class MessageSyncServiceFromRemoteToLocalImpl
    implements MessageSyncServiceFromRemoteToLocal {

  final MessageRemoteDS remoteDatasource;
  final MessageLocalDS messageLocalDatasource;
  final ChatLocalDatasource chatLocalDatasource;

  MessageSyncServiceFromRemoteToLocalImpl({
    required this.remoteDatasource,
    required this.messageLocalDatasource,
    required this.chatLocalDatasource,
  });

  final Map<String, StreamSubscription<List<ChatMessageModel>>>
      _subscriptions = {};

  bool _isSyncing = false;

  // ------------------------------------------------------------
  // SYNC MESSAGES
  // ------------------------------------------------------------

  @override
  Future<void> syncMessages() async {
    if (_isSyncing) {
      return;
    }

    _isSyncing = true;

    try {
      final localChatIds =
          (await chatLocalDatasource.getChatIdsLocal()).toSet();

      final listeningChatIds =
          _subscriptions.keys.toSet();

      // --------------------------------------------------------
      // STOP LISTENING TO REMOVED CHATS
      // --------------------------------------------------------

      for (final chatId
          in listeningChatIds.difference(localChatIds)) {
        await _stopListening(chatId);
      }

      // --------------------------------------------------------
      // START LISTENING TO NEW CHATS
      // --------------------------------------------------------

      for (final chatId
          in localChatIds.difference(listeningChatIds)) {
        await _startListening(chatId);
      }
    } finally {
      _isSyncing = false;
    }
  }

  // ------------------------------------------------------------
  // START LISTENING
  // ------------------------------------------------------------

  Future<void> _startListening(
    String chatId,
  ) async {
    if (_subscriptions.containsKey(chatId)) {
      return;
    }

    final subscription = remoteDatasource
        .listenMessages(
          ChatIdParams(
            chatId: chatId,
          ),
        )
        .listen(
      (messages) async {
        try {
          await messageLocalDatasource.cacheMessages(
            messages,
          );
        } catch (_) {
          // Keep listener alive.
          //
          // A local cache failure should not
          // automatically terminate the Firebase
          // listener.
        }
      },
      onError: (_) async {
        await _stopListening(chatId);
      },
    );

    _subscriptions[chatId] = subscription;
  }

  // ------------------------------------------------------------
  // STOP LISTENING
  // ------------------------------------------------------------

  Future<void> _stopListening(
    String chatId,
  ) async {
    final subscription =
        _subscriptions.remove(chatId);

    await subscription?.cancel();
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  Future<void> dispose() async {
    final subscriptions =
        List<StreamSubscription<List<ChatMessageModel>>>.from(
      _subscriptions.values,
    );

    _subscriptions.clear();

    for (final subscription in subscriptions) {
      await subscription.cancel();
    }
  }
}