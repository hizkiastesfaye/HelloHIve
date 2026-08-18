import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_local_Ds.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_remote_DS.dart';
import 'package:hellohive/feature/chats/data/models/hive_model.dart';
import 'package:hellohive/feature/chats/data/models/chats_model.dart';


class ChatSyncServiceFromRemoteToLocal {
  final ChatLocalDatasource localDatasource;
  final ChatRemoteDatasource remoteDatasource;
  ChatSyncServiceFromRemoteToLocal({
    required this.localDatasource,
    required this.remoteDatasource,
  });
  final currentUser = FirebaseAuth.instance.currentUser;


  void startChatSync(UserIdParams params) {
    remoteDatasource
        .watchChats(params.userId)
        .listen((remoteChats) async {

      await localDatasource.cacheChats(remoteChats);
    });
  }

  Future<void> getChatsFromRemote(UserIdParams params) async{

    final chats = await remoteDatasource.getChats(params);
    
    localDatasource.cacheChats(chats);
      print('+++++++++++++++++++++++++++++++++++++++++++++++++++');
    print('+++++++++++++++++++++++++++++++++++++++++++++++++++');
    print('get chats sync');
    print(chats.isEmpty);
    // for(final i in chats){
    //       print(i.id);
    //     }
    print('+++++++++++++++++++++++++++++++++++++++++++++++++++');
    print('+++++++++++++++++++++++++++++++++++++++++++++++++++');
    print('+++++++++++++++++++++++++++++++++++++++++++++++++++');
  }

  Future<void> getChatFromRemote(UsersChatParams params) async{
    final chat = await remoteDatasource.getChat(params);
    localDatasource.cacheChat(chat);
  }
}


class ChatSyncServiceFromLocalToRemote {
  final ChatLocalDatasource localDatasource;
  final ChatRemoteDatasource remoteDatasource;

  ChatSyncServiceFromLocalToRemote({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  Future<void> syncChats() async {
    final operations = await localDatasource.getPendingOperations();

    for (final operation in operations) {
      try {
        switch (operation.operation) {
          case SyncOperationType.createChat:
            await remoteDatasource.createChat(
              UsersChatParams(
                currentUserId: operation.payload['userAId'],
                userBId: operation.payload['userBId'],
              ),
            );
            break;

          case SyncOperationType.updateChat:
            await remoteDatasource.updateChat(
              MostChatParams(
                id: operation.chatId,
                userAId: operation.payload['userAId'],
                userBId: operation.payload['userBId'],
                mutedBy: Map<String, bool>.from(
                  operation.payload['mutedBy'],
                ),
                deletedBy: Map<String, bool>.from(
                  operation.payload['deletedBy'],
                ),
              ),
            );
            break;

          case SyncOperationType.deleteChat:
            await remoteDatasource.deleteChat(
              ChatIdUserIdParams(
                chatId: operation.chatId,
                userId: operation.payload['userId'],
              ),
            );
            break;

          case SyncOperationType.muteChat:
            await remoteDatasource.muteChat(
              MuteChatParams(
                chatId: operation.chatId,
                currentUserId: operation.payload['currentUserId'],
                isMuted: operation.payload['isMuted'],
              ),
            );
            break;

          case SyncOperationType.updateLastMessage:
            await remoteDatasource.updateLastMessage(
              UpdateLastMessageParams(
                chatId: operation.chatId,
                lastMessageId: operation.payload['lastMessageId'],
                lastMessageText: operation.payload['lastMessageText'],
                lastMessageTime: operation.payload['lastMessageTime'],
              ),
            );
            break;
        }

        await localDatasource.removeOperation(
          operation.id,
        );
      } catch (_) {}
    }
  }
}





// abstract class ChatSyncService {
//   /// Starts syncing all chats currently stored locally.
//   Future<void> syncChats();

//   /// Stops all active chat listeners.
//   Future<void> dispose();
// }

// class ChatSyncServiceImpl implements ChatSyncService {
//   final ChatRemoteDatasource remoteDatasource;
//   final ChatLocalDatasource localDatasource;

//   ChatSyncServiceImpl({
//     required this.remoteDatasource,
//     required this.localDatasource,
//   });

//   final Map<String, StreamSubscription<ChatModel>> _subscriptions = {};

//   @override
//   Future<void> syncChats() async {
//     final localChatIds =
//         (await localDatasource.getChatIdsLocal()).toSet();

//     final listeningIds = _subscriptions.keys.toSet();

//     // Stop listening to chats that no longer exist locally.
//     for (final chatId in listeningIds.difference(localChatIds)) {
//       await _stopListening(chatId);
//     }

//     // Start listening to newly added chats.
//     for (final chatId in localChatIds.difference(listeningIds)) {
//       await _startListening(chatId);
//     }
//   }

//   Future<void> _startListening(String chatId) async {
//     if (_subscriptions.containsKey(chatId)) {
//       return;
//     }

//     final subscription = remoteDatasource
//         .watchChat(chatId)
//         .listen(
//       (chat) async {
//         await localDatasource.cacheChat(chat);
//       },
//       onError: (_) async {
//         await _stopListening(chatId);
//       },
//     );

//     _subscriptions[chatId] = subscription;
//   }

//   Future<void> _stopListening(String chatId) async {
//     final subscription = _subscriptions.remove(chatId);

//     await subscription?.cancel();
//   }

//   @override
//   Future<void> dispose() async {
//     for (final subscription in _subscriptions.values) {
//       await subscription.cancel();
//     }

//     _subscriptions.clear();
//   }
// }