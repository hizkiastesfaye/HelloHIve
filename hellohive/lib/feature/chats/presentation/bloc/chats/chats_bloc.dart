import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hellohive/core/core_params.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/core/get_current_user_id.dart';
import 'package:hellohive/core/relate_features/chats_friends.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/chats_core/conversion.dart';
import 'package:hellohive/feature/chats/domain/entities/chats_entities.dart';
import 'package:hellohive/feature/chats/domain/usecases/chats_usecases.dart';
import 'package:hellohive/feature/friends/domain/usecases/friends_usecases.dart';
import 'package:hellohive/feature/friends/friends_core/friends_usecases_core.dart';
import 'package:meta/meta.dart';

part 'chats_event.dart';
part 'chats_state.dart';


const String SUCCESS_MESSAGE = 'successful';
const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String UNKNOWN_FAILURE_MESSAGE = 'Unknown Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - Please check the entered data.';
const String USER_NOT_FOUND_FAILURE_MESSAGE = 'User not found. Please check the user ID.';


class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final CreateChatUseCase createChatUseCase;
  final GetChatUseCase getChatUseCase;
  final GetChatsUseCase getChatsUseCase;
  final GetChatByIdUseCase getChatByIdUseCase;
  final WatchChatsUseCase watchChatsUseCase;
  final UpdateChatUseCase updateChatUseCase;
  final DeleteChatUseCase deleteChatUseCase;
  final MuteChatUseCase muteChatUseCase;
  final UpdateLastMessageUseCase updateLastMessageUseCase;
  final ChatSyncUsecase chatSyncUsecase;

  final GetFriendUseCases getFriendUseCases;
  final GetFriendsByListIdUsecases getFriendsByListIdUsecases;
  ChatsBloc({
    required this.createChatUseCase,
    required this.getChatUseCase,
    required this.getChatsUseCase,
    required this.getChatByIdUseCase,
    required this.watchChatsUseCase,
    required this.updateChatUseCase,
    required this.deleteChatUseCase,
    required this.muteChatUseCase,
    required this.updateLastMessageUseCase,
    required this.chatSyncUsecase,

    required this.getFriendUseCases,
    required this.getFriendsByListIdUsecases,
  }) : super(ChatsInitial()) {
    on<CreateChatEvent>((event, emit) async {
      emit(ChatsLoading());
      final params = UsersChatParams(
        currentUserId: event.currentUserId,
        userBId: event.userBId,
      );
      final result = await createChatUseCase(params);
      result.fold(
          (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
          (actionStatus) => emit(ChatCreated('${actionStatus.name}')),
        
      );
    });
    final currentUserId = getCurrentUserId();

    on<GetChatEvent>((event, emit) async{
      print('ggggggggggggeeeeeeettttttteeeeeee');
      emit(ChatsLoading());
      final params = UsersChatParams(
        currentUserId: event.currentUserId,
        userBId: event.userBId,
      );
      print('2gggggggggggggggggggeeeeeeeeeeeeeeeetttttttttttteeeeee');
      final result = await getChatUseCase(params);
      print('3gggggggggggggggggggeeeeeeeeeeeeeeeetttttttttttteeeeee');

      if(result.isLeft()){
        final failure = result.fold(
          (failure) => failure,
          (_) => null,
        );
        emit(ChatsError(_mapFailureToMessage(failure!)));
        return;
      }
      final chat = result.fold(
        (_) {
          emit(ChatsError('user not found'));
          throw Exception('Unexpected error');},
        (chat) => chat,
      );
      final friendId = chat.participants.firstWhere(
        (id) => id != event.currentUserId,
      );
      final friendResult = await getFriendUseCases(
        FriendParams( friendId: friendId),
          
      );
      friendResult.fold(
        (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
        (friend) {
          final chatWithFriend = ALLChatsFriendsParams(
            chatId: chat.id,
            currentUserId: event.currentUserId,
            unreadCount: chat.unreadCount[event.currentUserId] ?? 0,
            mutedBy: chat.mutedBy[event.currentUserId] ?? false,
            deletedBy: chat.deletedBy,
            createdAt: chat.createdAt,
            updatedAt: chat.updatedAt,
            lastMessageId: chat.lastMessageId,
            lastMessageText: chat.lastMessageText,
            friendId: friend.uId,
            firstName: friend.firstName,
            lastName: friend.lastName,
            username: friend.username,
            photoUrl: friend.photoUrl,
            description: friend.description,
          );
          emit(ChatLoaded(chatWithFriend));
        },
      );
      // result.fold(
      //     (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
      //     (chat) => emit(ChatLoaded(chat)),
      //  );
    });


    on<GetChatsEvent>((event, emit) async {
      emit(ChatsLoading());

      final params = UserIdParams(
        userId: event.userId,
      );

      final result = await getChatsUseCase(params);

      if (result.isLeft()) {
        final failure = result.fold(
          (failure) => failure,
          (_) => null,
        );

        emit(
          ChatsError(_mapFailureToMessage(failure!)),
        );

        return;
      }

      final chats = result.fold(
        (_) => <ChatsEntities>[],
        (chats) => chats,
      );

      if (chats.isEmpty) {
        emit(ChatsLoaded([]));
        return;
      }

      final friendsIds = getOtherUserIds(chats);
      print('friendsId');
      print('friendsId');
      print('friendsId');
      print(friendsIds);
      print('friendsId');
      print('friendsId');
      print('friendsId');

      final friendsResult = await getFriendsByListIdUsecases(
        FriendsIdsParams(
          friendsIds: friendsIds,
        ),
      );

      friendsResult.fold(
        (failure) {
          emit(
            ChatsError(_mapFailureToMessage(failure)),
          );
        },
        (friends) {
          print('freinds');
          print('freinds');
          print('freinds');
          print('freinds');
          print(friends.length);
          print('freinds');
          print('freinds');
          print('freinds');
          final finalResult = getChatsWithFriends(
            chats,
            friends,
          );

          emit(
            ChatsLoaded(finalResult),
          );
        },
      );
    });

    on<GetChatByIdEvent>((event, emit) async {
      emit(ChatsLoading());
      final result = await getChatByIdUseCase(event.chatId);
      if(result.isLeft()){
        final failure = result.fold(
          (failure)=> failure,
        (_)=>null,
        );
        emit(ChatsError(_mapFailureToMessage(failure!)));
        return;
      }
      final chat = result.fold(
        (_){
          emit(ChatsError('user not found'));
          throw Exception('unexpected error');
        },
      (chat)=>chat,
      );
      final friendId = chat.participants.firstWhere(
        (id)=>id !=currentUserId,
      );
      final friendResult = await getFriendUseCases(
        FriendParams(friendId: friendId)
      );
      friendResult.fold(
        (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
        (friend) {
          final String cu = chat.participants.firstWhere((id)=> id != friend.uId);
          final chatWithFriend = ALLChatsFriendsParams(
            chatId: chat.id,
            currentUserId: currentUserId,
            unreadCount: chat.unreadCount[cu] ?? 0,
            mutedBy: chat.mutedBy[cu] ?? false,
            deletedBy: chat.deletedBy,
            createdAt: chat.createdAt,
            updatedAt: chat.updatedAt,
            lastMessageId: chat.lastMessageId,
            lastMessageText: chat.lastMessageText,
            friendId: friend.uId,
            firstName: friend.firstName,
            lastName: friend.lastName,
            username: friend.username,
            photoUrl: friend.photoUrl,
            description: friend.description,
          );
          emit(ChatLoaded(chatWithFriend));
        },
      );
      // result.fold(
      //     (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
      //     (chat) {
      //       if (chat != null) {
      //         emit(ChatLoadedById(chat));
      //       } else {
      //         emit(ChatsError('Chat not found'));
      //       }
      //     },
      //   );
    });

    on<WatchChatsEvent>((event, emit) async{
      final params = UserIdParams(userId: event.userId);
      final result = await watchChatsUseCase(params);
      await emit.forEach(
          result,
          onData: (statusResult)=> statusResult.fold(
            (failure) => ChatsError(_mapFailureToMessage(failure)),
            (status) => WatchChats(status)
          )
        );
    });

    on<UpdateChatEvent>((event, emit) async{
      emit(ChatsLoading());
      final params = MostChatParams(
        id: event.id,
        userAId: event.userAId,
        userBId: event.userBId,
        mutedBy: event.mutedBy,
        deletedBy: event.deletedBy,
        lastMessageId: event.lastMessageId,
        lastMessageText: event.lastMessageText,
        lastMessageTime: event.lastMessageTime,
      );
      final result = await updateChatUseCase(params);
      result.fold(
          (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
          (actionStatus) {
            print('===================================');
            print('===================================');
            print('===================================');
            print(actionStatus.name);
            print('===================================');
            print('===================================');
            print('===================================');
            print('===================================');
            print('===================================');
            emit(ChatUpdated('${actionStatus.name}'));},
      );
    });

    on<DeleteChatEvent>((event, emit) async{
      emit(ChatsLoading());
      final params = ChatIdUserIdParams(
        chatId: event.chatId,
        userId: event.userId,
      );
      final result = await deleteChatUseCase(params);
      result.fold(
          (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
          (actionStatus) => emit(ChatDeleted('${actionStatus.name}')),
        );
    });

    on<MuteChatEvent>((event, emit) async{
      emit(ChatsLoading());
      final params = MuteChatParams(
        currentUserId: event.currentUserId,
        chatId: event.chatId,
        isMuted: event.isMuted,
      );
      
      final result = await muteChatUseCase(params);
      result.fold(
          (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
          (actionStatus) => emit(ChatMuted('${actionStatus.name}')),
        );
    });

    on<UpdateLastMessageEvent>((event, emit) async{
      emit(ChatsLoading());
      final lastMessageTime = DateTimeConverter.stringToDateTime(event.lastMessageTime);
      final params = UpdateLastMessageParams(
        chatId: event.chatId,
        lastMessageId: event.lastMessageId,
        lastMessageText: event.lastMessageText,
        lastMessageTime: lastMessageTime,
      );
      final result = await updateLastMessageUseCase(params);
      result.fold(
          (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
          (actionStatus) => emit(ChatLastMessageUpdated('${actionStatus.name}')),
        );
    });

    on<ChatSyncEvent>((event,emit) async{
      emit(ChatsLoading());
      print('\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\');
      print('\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\');
      print('\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\');
      print('\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\');
      print('\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\');
      final params = UserIdParams(userId: event.userId);
      final result = await chatSyncUsecase(params);
      result.fold(
        (failure)=> emit(ChatsError(_mapFailureToMessage(failure))),
        (unit)=>emit(ChatSynced('success'))
      );
    });
  }


  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}