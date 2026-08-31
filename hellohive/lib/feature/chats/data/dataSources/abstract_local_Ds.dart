import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/chats_core/chats_message_core.dart';
import 'package:hellohive/feature/chats/data/models/chats_model.dart';
import 'package:hellohive/feature/chats/data/models/hive_model.dart';
import 'package:hellohive/feature/chats/data/models/message_model.dart';

abstract class ChatLocalDatasource {

    Future<ActionStatus> createPendingChat(
    UsersChatParams params,
  );
  
  Stream<List<ChatModel>> watchChats(UserIdParams params);

  Future<ActionStatus> cacheChat(ChatModel chat);

  Future<ActionStatus> cacheChats(List<ChatModel> chats);

  Future<ChatModel> getChat(UsersChatParams params);
  Future<List<ChatModel>> getChats(UserIdParams params);

  Future<ChatModel> getChatById(String chatId);

  Future<ActionStatus> updateChat(MostChatParams params);

  Future<ActionStatus> deleteChat(ChatIdUserIdParams params);

  Future<ActionStatus> muteChat(MuteChatParams params);
  Future<List<ChatSyncOperation>> getPendingOperations();

  Future<void> removeOperation(String operationId);
  Future<ActionStatus> updateLastMessage(UpdateLastMessageParams params,);
  Future<List<String>> getChatIdsLocal();

  // your existing methods...

  // Future<ActionStatus> clearChats(
  //   String userId,
  // );
}
