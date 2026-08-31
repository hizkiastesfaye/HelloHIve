import 'package:equatable/equatable.dart';
import 'package:hellohive/feature/chats/chats_core/chats_message_core.dart';
import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

// ------------------------------------------------------------
// LOAD / LISTEN
// ------------------------------------------------------------

class ListenMessagesEvent extends MessageEvent {
  final String chatId;

  const ListenMessagesEvent({
    required this.chatId,
  });

  @override
  List<Object?> get props => [chatId];
}

// ------------------------------------------------------------
// SEND
// ------------------------------------------------------------

class SendMessageEvent extends MessageEvent {
  final SendMessageParams params;

  const SendMessageEvent({
    required this.params,
  });

  @override
  List<Object?> get props => [params];
}

// ------------------------------------------------------------
// EDIT
// ------------------------------------------------------------

class EditMessageEvent extends MessageEvent {
  final EditMessageParams params;

  const EditMessageEvent({
    required this.params,
  });

  @override
  List<Object?> get props => [params];
}

// ------------------------------------------------------------
// DELETE
// ------------------------------------------------------------

class DeleteMessageEvent extends MessageEvent {
  final DeleteMessageParams params;

  const DeleteMessageEvent({
    required this.params,
  });

  @override
  List<Object?> get props => [params];
}

// ------------------------------------------------------------
// MARK AS READ
// ------------------------------------------------------------

class MarkMessageAsReadEvent extends MessageEvent {
  final MarkMessageAsReadParams params;

  const MarkMessageAsReadEvent({
    required this.params,
  });

  @override
  List<Object?> get props => [params];
}

// ------------------------------------------------------------
// RETRY
// ------------------------------------------------------------

class RetryFailedMessageEvent extends MessageEvent {
  final MessageIdParams params;

  const RetryFailedMessageEvent({
    required this.params,
  });

  @override
  List<Object?> get props => [params];
}

// ------------------------------------------------------------
// STOP LISTENING
// ------------------------------------------------------------

class StopListeningMessagesEvent extends MessageEvent {
  const StopListeningMessagesEvent();
}

class MessageLoadedEvent extends MessageEvent {
  final List<ChatMessageEntities> messages;

  const MessageLoadedEvent(this.messages);

  @override
  List<Object?> get props => [messages];
}

class MessageListenFailureEvent extends MessageEvent {
  final String message;

  const MessageListenFailureEvent(this.message);

  @override
  List<Object?> get props => [message];
}