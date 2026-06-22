import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/chats_core/conversion.dart';
import 'package:hellohive/feature/chats/domain/entities/chats_entities.dart';
import 'package:hellohive/feature/chats/domain/usecases/chats_usecases.dart';
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

    on<GetChatEvent>((event, emit) async{
      emit(ChatsLoading());
      final params = UsersChatParams(
        currentUserId: event.currentUserId,
        userBId: event.userBId,
      );
      final result = await getChatUseCase(params);
      result.fold(
          (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
          (chat) => emit(ChatLoaded(chat)),
       );
    });

    on<GetChatsEvent>((event, emit) async {
      emit(ChatsLoading());
      final params = UserIdParams(userId: event.userId);
      final result = await getChatsUseCase(params);
      result.fold(
          (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
          (chats){ 
            print('++++++++++++++++++++++++++++++++++');
            print('++++++++++++++++++++++++++++++++++');
            for (final ch in chats){
              print(ch);
            }
            print('++++++++++++++++++++++++++++++++++');
            print('++++++++++++++++++++++++++++++++++');

            emit(ChatsLoaded(chats));}
        );
    });

    on<GetChatByIdEvent>((event, emit) async {
      emit(ChatsLoading());
      final result = await getChatByIdUseCase(event.chatId);
      result.fold(
          (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
          (chat) {
            if (chat != null) {
              emit(ChatLoadedById(chat));
            } else {
              emit(ChatsError('Chat not found'));
            }
          },
        );
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

    on<UpdateChatEvent>((event, emit) {
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
      final result = updateChatUseCase(params);
      result.then((either) {
        either.fold(
          (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
          (actionStatus) => emit(ChatUpdated('${actionStatus.name}')),
        );
      });
    });

    on<DeleteChatEvent>((event, emit) {
      emit(ChatsLoading());
      final params = ChatIdUserIdParams(
        chatId: event.chatId,
        userId: event.userId,
      );
      final result = deleteChatUseCase(params);
      result.then((either) {
        either.fold(
          (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
          (actionStatus) => emit(ChatDeleted('${actionStatus.name}')),
        );
      });
    });

    on<MuteChatEvent>((event, emit) {
      emit(ChatsLoading());
      final params = MuteChatParams(
        currentUserId: event.currentUserId,
        chatId: event.chatId,
        isMuted: event.isMuted,
      );
      final result = muteChatUseCase(params);
      result.then((either) {
        either.fold(
          (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
          (actionStatus) => emit(ChatMuted('${actionStatus.name}')),
        );
      });
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