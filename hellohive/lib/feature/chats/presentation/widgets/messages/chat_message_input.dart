import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellohive/feature/chats/chats_core/chats_message_core.dart';
import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';
import 'package:hellohive/feature/chats/presentation/bloc/chat_messages/message_bloc.dart';
import 'package:hellohive/feature/chats/presentation/bloc/chat_messages/message_event.dart';

class ChatMessageInput extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String receiverId;

  const ChatMessageInput({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.receiverId,
  });

  @override
  State<ChatMessageInput> createState() =>
      _ChatMessageInputState();
}

class _ChatMessageInputState
    extends State<ChatMessageInput> {
  final TextEditingController _controller =
      TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    context.read<MessageBloc>().add(
          SendMessageEvent(
            params: SendMessageParams(
              chatId: widget.chatId,
              senderId: widget.currentUserId,
              receiverId: widget.receiverId,
              type: MessageType.text,
              text: text,
            ),
          ),
        );

    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          8,
          6,
          8,
          8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                // Open attachment picker
              },
              icon: const Icon(
                Icons.add,
              ),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  borderRadius:
                      BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        minLines: 1,
                        maxLines: 5,
                        textInputAction:
                            TextInputAction.newline,
                        decoration:
                            const InputDecoration(
                          hintText:
                              'Message...',
                          border:
                              InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 11,
                          ),
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        // Emoji picker
                      },
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 4),

            ValueListenableBuilder(
              valueListenable: _controller,
              builder: (
                context,
                value,
                child,
              ) {
                final hasText =
                    value.text.trim().isNotEmpty;

                return CircleAvatar(
                  radius: 23,
                  child: IconButton(
                    onPressed: hasText
                        ? _sendMessage
                        : () {
                            // Open voice recorder
                            print('0000000000');
                            print('0000000000');
                            print('0000000000');
                            print('no text');
                            print('0000000000');
                            print('0000000000');
                          },
                    icon: Icon(
                      hasText
                          ? Icons.send
                          : Icons.mic,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}