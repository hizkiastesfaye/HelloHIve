import 'package:equatable/equatable.dart';
import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';
import 'package:hellohive/feature/chats/chats_core/chats_core.dart';

enum MessageStatusState {
  initial,
  loading,
  loaded,
  failure,
}

class MessageState extends Equatable {
  final MessageStatusState status;
  final List<ChatMessageEntities> messages;
  final String? errorMessage;

  // ------------------------------------------------------------
  // ACTION STATES
  // ------------------------------------------------------------

  final bool sending;
  final bool editing;
  final bool deleting;
  final bool markingAsRead;

  /// Result of the most recent message action.
  ///
  /// Examples:
  /// - sendMessage
  /// - editMessage
  /// - deleteMessage
  /// - markMessageAsRead
  ///
  /// Null means no action has completed yet.
  final ActionStatus? lastActionStatus;

  const MessageState({
    this.status = MessageStatusState.initial,
    this.messages = const [],
    this.errorMessage,

    this.sending = false,
    this.editing = false,
    this.deleting = false,
    this.markingAsRead = false,

    this.lastActionStatus,
  });

  MessageState copyWith({
    MessageStatusState? status,
    List<ChatMessageEntities>? messages,

    String? errorMessage,
    bool clearError = false,

    bool? sending,
    bool? editing,
    bool? deleting,
    bool? markingAsRead,

    ActionStatus? lastActionStatus,
    bool clearLastActionStatus = false,
  }) {
    return MessageState(
      status: status ?? this.status,
      messages: messages ?? this.messages,

      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,

      sending: sending ?? this.sending,
      editing: editing ?? this.editing,
      deleting: deleting ?? this.deleting,
      markingAsRead:
          markingAsRead ?? this.markingAsRead,

      lastActionStatus:
          clearLastActionStatus
              ? null
              : lastActionStatus ?? this.lastActionStatus,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        errorMessage,
        sending,
        editing,
        deleting,
        markingAsRead,
        lastActionStatus,
      ];
}