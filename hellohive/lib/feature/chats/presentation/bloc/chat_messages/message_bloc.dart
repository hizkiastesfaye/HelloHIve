import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';
import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';
import 'package:hellohive/feature/chats/domain/usecases/message_usecases.dart';

import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ListenMessagesUseCase listenMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final EditMessageUseCase editMessageUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;
  final MarkMessageAsReadUseCase markMessageAsReadUseCase;

  StreamSubscription<
      Either<Failure, List<ChatMessageEntities>>>?
      _messagesSubscription;

  MessageBloc({
    required this.listenMessagesUseCase,
    required this.sendMessageUseCase,
    required this.editMessageUseCase,
    required this.deleteMessageUseCase,
    required this.markMessageAsReadUseCase,
  }) : super(const MessageState()) {
    on<ListenMessagesEvent>(_onListenMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<EditMessageEvent>(_onEditMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
    on<MarkMessageAsReadEvent>(_onMarkMessageAsRead);
    on<StopListeningMessagesEvent>(_onStopListeningMessages);

    on<MessageLoadedEvent>(_onMessageLoaded);
    on<MessageListenFailureEvent>(_onMessageListenFailure);
  }

  // ============================================================
  // LISTEN MESSAGES
  // ============================================================

  Future<void> _onListenMessages(
    ListenMessagesEvent event,
    Emitter<MessageState> emit,
  ) async {
    await _messagesSubscription?.cancel();

    emit(
      state.copyWith(
        status: MessageStatusState.loading,
        errorMessage: null,
      ),
    );

    _messagesSubscription = listenMessagesUseCase(
      ChatIdParams(
        chatId: event.chatId,
      ),
    ).listen(
      (result) {
        result.fold(
          (failure) {
            add(
              MessageListenFailureEvent(
                failure.message,
              ),
            );
          },
          (messages) {
            add(
              MessageLoadedEvent(
                messages,
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<MessageState> emit,
  ) async {

    emit(
      state.copyWith(
        sending: true,
        errorMessage: null,
      ),
    );

    final result = await sendMessageUseCase(
      event.params,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            sending: false,
            errorMessage: failure.message,
          ),
        );
      },
      (actionStatus) {
        emit(
          state.copyWith(
            sending: false,
            lastActionStatus: actionStatus,
          ),
        );
      },
    );
  }

  // ============================================================
  // EDIT MESSAGE
  // ============================================================

  Future<void> _onEditMessage(
    EditMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(
      state.copyWith(
        editing: true,
        errorMessage: null,
      ),
    );

    final result = await editMessageUseCase(
      event.params,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            editing: false,
            errorMessage: failure.message,
          ),
        );
      },
      (actionStatus) {
        emit(
          state.copyWith(
            editing: false,
            lastActionStatus: actionStatus,
          ),
        );
      },
    );
  }

  // ============================================================
  // DELETE MESSAGE
  // ============================================================

  Future<void> _onDeleteMessage(
    DeleteMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    print('bloc Deleting message with ID: ${event.params.messageId} for user: ${event.params.userId}');
    emit(
      state.copyWith(
        deleting: true,
        errorMessage: null,
      ),
    );

    final result = await deleteMessageUseCase(
      event.params,
    );
    print('1bloc Delete message result');

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            deleting: false,
            errorMessage: failure.message,
          ),
        );
      },
      (actionStatus) {
        emit(
          state.copyWith(
            deleting: false,
            lastActionStatus: actionStatus,
          ),
        );
      },
    );
  }

  // ============================================================
  // MARK MESSAGE AS READ
  // ============================================================

  Future<void> _onMarkMessageAsRead(
    MarkMessageAsReadEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(
      state.copyWith(
        markingAsRead: true,
        errorMessage: null,
      ),
    );

    final result = await markMessageAsReadUseCase(
      event.params,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            markingAsRead: false,
            errorMessage: failure.message,
          ),
        );
      },
      (actionStatus) {
        emit(
          state.copyWith(
            markingAsRead: false,
            lastActionStatus: actionStatus,
          ),
        );
      },
    );
  }

  void _onMessageLoaded(
    MessageLoadedEvent event,
    Emitter<MessageState> emit,
  ) {
    emit(
      state.copyWith(
        status: MessageStatusState.loaded,
        messages: event.messages,
        errorMessage: null,
      ),
    );
  }

  void _onMessageListenFailure(
    MessageListenFailureEvent event,
    Emitter<MessageState> emit,
  ) {
    emit(
      state.copyWith(
        status: MessageStatusState.failure,
        errorMessage: event.message,
      ),
    );
  }

  // ============================================================
  // STOP LISTENING
  // ============================================================

  Future<void> _onStopListeningMessages(
    StopListeningMessagesEvent event,
    Emitter<MessageState> emit,
  ) async {
    await _messagesSubscription?.cancel();

    _messagesSubscription = null;
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  Future<void> close() async {
    await _messagesSubscription?.cancel();

    return super.close();
  }
}