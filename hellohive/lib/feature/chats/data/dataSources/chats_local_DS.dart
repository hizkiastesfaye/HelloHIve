
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/data/dataSources/abstract_local_Ds.dart';
import 'package:hellohive/feature/chats/data/models/chats_model.dart';
import 'package:hellohive/feature/chats/data/models/hive_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class ChatLocalDatasourceImpl extends ChatLocalDatasource{
  final Box<ChatHiveModel> chatBox;
  final Box<ChatSyncOperation> operationsBox;

  ChatLocalDatasourceImpl({required this.chatBox, required this.operationsBox});

  @override
  
  @override
  Future<ActionStatus> createPendingChat(
    UsersChatParams params,
  ) async {
    
    final chat = ChatModel(
      id: generateChatId(params.currentUserId, params.userBId),
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
    final operation = ChatSyncOperation(
      id: const Uuid().v4(),
      operation: SyncOperationType.createChat,
      chatId: chat.id,
      payload: {
        'userAId': params.currentUserId,
        'userBId': params.userBId,
      },
      createdAt: DateTime.now(),
    );
    await operationsBox.put(
    operation.id,
    operation,
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
          (chat.userAId == params.currentUserId &&
              chat.userBId == params.userBId) ||
          (chat.userAId == params.userBId &&
              chat.userBId == params.currentUserId),
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
    MostChatParams params,
  ) async {
    final chat = chatBox.get(params.id);
    if (chat != null) {
      final updatedChat = chat.copyWith(
      unreadCount: params.unreadCount,
      mutedBy: params.mutedBy,
      deletedBy: params.deletedBy,
      updatedAt: DateTime.now(),
      );

      await chatBox.put(chat.id, updatedChat);
      final operation = ChatSyncOperation(
        id: const Uuid().v4(),
        operation: SyncOperationType.updateChat,
        chatId: chat.id,
        payload: {
          'unreadCount': params.unreadCount,
          'mutedBy': params.mutedBy,
          'deletedBy': params.deletedBy, // Assuming the current user is userAId, adjust as needed
        },
        createdAt: DateTime.now(),
      );
      await operationsBox.put(
        operation.id,
        operation,
      );
    }

      
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

    final operation = ChatSyncOperation(
      id: const Uuid().v4(),
      operation: SyncOperationType.deleteChat,
      chatId: chat.id,
      payload: {
        'userId': params.userId,
      },
      createdAt: DateTime.now(),
    );
    await operationsBox.put(
      operation.id,
      operation,
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

    mutedBy[params.currentUserId] = params.isMuted;

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
    final operation = ChatSyncOperation(
      id: const Uuid().v4(),
      operation: SyncOperationType.muteChat,
      chatId: chat.id,
      payload: {
        'userId': params.currentUserId,
        'isMuted': params.isMuted,
      },
      createdAt: DateTime.now(),
    );
    await operationsBox.put(
      operation.id,
      operation,
    );

    return ActionStatus.pending;
  }
}