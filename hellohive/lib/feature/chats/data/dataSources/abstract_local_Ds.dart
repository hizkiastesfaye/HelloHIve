import 'package:hellohive/feature/chats/data/models/chats_model.dart';
import 'package:hellohive/feature/chats/data/models/message_model.dart';

abstract class ChatLocalDatasource {
  Future<void> cacheChat(ChatModel chat);

  Future<void> cacheChats(List<ChatModel> chats);

  Future<List<ChatModel>> getChats(String userId);

  Future<ChatModel?> getChatById(String chatId);

  Future<void> updateChat(ChatModel chat);

  Future<void> deleteChat(String chatId);

  Future<void> muteChat({
    required String chatId,
    required String userId,
    required bool isMuted,
  });

  // Future<void> clearChats(
  //   String userId,
  // );
}



abstract class MessageLocalDatasource {

  Future<void> cacheMessage(
    ChatMessageModel message,
  );

  Future<void> cacheMessages(
    List<ChatMessageModel> messages,
  );

  Future<List<ChatMessageModel>> getMessages(
    String chatId,
  );

  Future<ChatMessageModel?> getLastMessage(
    String chatId,
  );

  Future<void> updateMessage(
    ChatMessageModel message,
  );

  Future<void> deleteMessage({
    required String messageId,
  });

  Future<void> markMessageAsRead({
    required String messageId,
  });

  Future<void> clearChatMessages(
    String chatId,
  );
}