
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_local_Ds.dart';
import 'package:hellohive/feature/chats/data/models/chats_model.dart';
import 'package:hellohive/feature/chats/data/models/hive_model.dart';
import 'package:hive/hive.dart';

class ChatLocalDatasourceImpl extends ChatLocalDatasource{
  final Box<ChatHiveModel> chatBox;

  ChatLocalDatasourceImpl({required this.chatBox});

  @override
  
  @override
  Future<ActionStatus> createPendingChat(
    UsersChatParams params,
  ) async {
    final chat = ChatModel(
      id: '${params.currentUserId}_${params.userBId}', // Generate a unique ID based on user IDs
      userAId: params.currentUserId,
      userBId: params.userBId,
      unreadCount: {},
      mutedBy: {},
      deletedBy: {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await chatBox.put(
      chat.id,
      chat.toHive(),
    );

    return ActionStatus.pending;
  }
    
  @override
  Stream<List<ChatModel>> watchChats(
    UserIdParams params,
  ) async* {
    yield await getChats(params);

    yield* chatBox.watch().map((_) {
      return chatBox.values
          .where(
            (chat) =>
                chat.userAId == params.userId ||
                chat.userBId == params.userId,
          )
          .map((e) => e.toDomain())
          .toList()
        ..sort(
          (a, b) => b.updatedAt.compareTo(a.updatedAt),
        );
    });
  }
  @override
  Future<ActionStatus> cacheChat(
    ChatModel chat,
  ) async {
    await chatBox.put(
      chat.id,
      chat.toHive(),
    );

    return ActionStatus.success;
  }
  @override
  Future<ActionStatus> cacheChats(
    List<ChatModel> chats,
  ) async {
    final map = {
      for (final chat in chats)
        chat.id: chat.toHive(),
    };

    await chatBox.putAll(map);

    return ActionStatus.success;
  }
  @override
  Future<ChatModel> getChat(
    UsersChatParams params,
  ) async {
    final chat = chatBox.values.firstWhere(
      (chat) =>
          (chat.userAId == params.userAId &&
              chat.userBId == params.userBId) ||
          (chat.userAId == params.userBId &&
              chat.userBId == params.userAId),
    );

    return chat.toDomain();
  }
  @override
  Future<List<ChatModel>> getChats(
    UserIdParams params,
  ) async {
    return chatBox.values
        .where(
          (chat) =>
              chat.userAId == params.userId ||
              chat.userBId == params.userId,
        )
        .map((e) => e.toDomain())
        .toList()
      ..sort(
        (a, b) => b.updatedAt.compareTo(a.updatedAt),
      );
  }
  @override
  Future<ChatModel?> getChatById(
    String chatId,
  ) async {
    return chatBox.get(chatId)?.toDomain();
  }
  @override
  Future<ActionStatus> updateChat(
    ChatModel chat,
  ) async {
    await chatBox.put(
      chat.id,
      chat.toHive(),
    );

    return ActionStatus.success;
  }

  @override
  Future<ActionStatus> deleteChat(
    ChatIdUserIdParams params,
  ) async {
    final chat = chatBox.get(params.chatId);

    if (chat == null) {
      throw Exception('Chat not found');
    }

    final deletedBy =
        Map<String, bool>.from(chat.deletedBy);

    deletedBy[params.userId] = true;

    await chatBox.put(
      chat.id,
      ChatHiveModel(
        id: chat.id,
        userAId: chat.userAId,
        userBId: chat.userBId,
        unreadCount: chat.unreadCount,
        mutedBy: chat.mutedBy,
        deletedBy: deletedBy,
        createdAt: chat.createdAt,
        updatedAt: DateTime.now(),
        lastMessageId: chat.lastMessageId,
        lastMessageText: chat.lastMessageText,
        lastMessageTime: chat.lastMessageTime,
      ),
    );

    return ActionStatus.pending;
  }
  @override
  Future<ActionStatus> muteChat(
    MuteChatParams params,
  ) async {
    final chat = chatBox.get(params.chatId);

    if (chat == null) {
      throw Exception('Chat not found');
    }

    final mutedBy =
        Map<String, bool>.from(chat.mutedBy);

    mutedBy[params.userId] = params.isMuted;

    await chatBox.put(
      chat.id,
      ChatHiveModel(
        id: chat.id,
        userAId: chat.userAId,
        userBId: chat.userBId,
        unreadCount: chat.unreadCount,
        mutedBy: mutedBy,
        deletedBy: chat.deletedBy,
        createdAt: chat.createdAt,
        updatedAt: DateTime.now(),
        lastMessageId: chat.lastMessageId,
        lastMessageText: chat.lastMessageText,
        lastMessageTime: chat.lastMessageTime,
      ),
    );

    return ActionStatus.pending;
  }
}