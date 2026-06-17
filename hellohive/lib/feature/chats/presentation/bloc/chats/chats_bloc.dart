import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
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
    on<CreateChatEvent>((event, emit) {
      emit(ChatsLoading());
      final params = UsersChatParams(
        currentUserId: event.currentUserId,
        userBId: event.userBId,
      );
      final result = createChatUseCase(params);
      result.then((either) {
        either.fold(
          (failure) => emit(ChatsError(_mapFailureToMessage(failure))),
          (actionStatus) => emit(ChatCreated('${actionStatus.name}')),
        );
      });
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