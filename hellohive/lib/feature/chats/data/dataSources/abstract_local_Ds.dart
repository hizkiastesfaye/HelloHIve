import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/data/models/chats_model.dart';
import 'package:hellohive/feature/chats/data/models/message_model.dart';

abstract class ChatLocalDatasource {

    Future<ActionStatus> createPendingChat(
    UsersChatParams params,
  );
  
  Stream<List<ChatModel>> watchChats(String userId,);

  Future<ActionStatus> cacheChat(ChatModel chat);

  Future<ActionStatus> cacheChats(List<ChatModel> chats);

  Future<ChatModel> getChat(UsersChatParams params);
  Future<List<ChatModel>> getChats(String userId);

  Future<ChatModel?> getChatById(String chatId);

  Future<ActionStatus> updateChat(ChatModel chat);

  Future<ActionStatus> deleteChat(ChatIdUserIdParams params);

  Future<ActionStatus> muteChat(MuteChatParams params);

  // Future<ActionStatus> clearChats(
  //   String userId,
  // );
}



abstract class MessageLocalDatasource {

  Future<ActionStatus> sendMessage(SendMessageParams params,);

  Future<ActionStatus> cacheMessage(
    ChatMessageModel message,
  );


  Future<ActionStatus> cacheMessages(
    List<ChatMessageModel> messages,
  );

  Future<List<ChatMessageModel>> getMessages(
    String chatId,
  );

  Future<ChatMessageModel?> getLastMessage(
    String chatId,
  );

  Future<ActionStatus> updateMessage(
    ChatMessageModel message,
  );

  Future<ActionStatus> deleteMessage({
    required String messageId,
  });

  Future<ActionStatus> markMessageAsRead({
    required String messageId,
  });

  Future<ActionStatus> clearChatMessages(
    String chatId,
  );
}