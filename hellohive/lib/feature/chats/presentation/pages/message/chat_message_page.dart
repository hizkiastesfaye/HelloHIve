import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';
import 'package:hellohive/feature/chats/presentation/bloc/chat_messages/message_bloc.dart';
import 'package:hellohive/feature/chats/presentation/bloc/chat_messages/message_event.dart';
import 'package:hellohive/feature/chats/presentation/bloc/chat_messages/message_state.dart';

import '../../../chats_core/chats_message_core.dart';
import '../../widgets/messages/chat_message_bubble.dart';
import '../../widgets/messages/chat_message_input.dart';
import '../../widgets/messages/message_action_bar.dart';

class ChatMessagePage extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String receiverId;

  const ChatMessagePage({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.receiverId,
  });

  @override
  State<ChatMessagePage> createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {
  final Set<String> _selectedMessageIds = {};

  @override
  void initState() {
    super.initState();

    context.read<MessageBloc>().add(
          ListenMessagesEvent(
            chatId: widget.chatId,
          ),
        );
  }

  // ------------------------------------------------------------
  // SELECTION
  // ------------------------------------------------------------

  void _toggleMessageSelection(String messageId) {
    setState(() {
      if (_selectedMessageIds.contains(messageId)) {
        _selectedMessageIds.remove(messageId);
      } else {
        _selectedMessageIds.add(messageId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedMessageIds.clear();
    });
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final hasSelection = _selectedMessageIds.isNotEmpty;

    return Scaffold(
      appBar: hasSelection
          ? MessageSelectionAppBar(
              selectedCount: _selectedMessageIds.length,
              onClose: _clearSelection,
              onDelete: _deleteSelectedMessages,
            )
          : _buildNormalAppBar(),

      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state.status == MessageStatusState.loading &&
                    state.messages.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.status == MessageStatusState.failure &&
                    state.messages.isEmpty) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'Failed to load messages',
                    ),
                  );
                }

                if (state.messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet'),
                  );
                }

                return _buildMessages(state.messages);
              },
            ),
          ),

          if (!hasSelection)
            ChatMessageInput(
              chatId: widget.chatId,
              currentUserId: widget.currentUserId,
              receiverId: widget.receiverId,
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // NORMAL APP BAR
  // ------------------------------------------------------------

  PreferredSizeWidget _buildNormalAppBar() {
    return AppBar(
      titleSpacing: 0,
      title: const Row(
        children: [
          CircleAvatar(
            radius: 20,
            child: Icon(Icons.person),
          ),
          SizedBox(width: 10),
          Text('Friend'),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Search messages
          },
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {
            // More options
          },
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // MESSAGES
  // ------------------------------------------------------------

  Widget _buildMessages(
    List<ChatMessageEntities> messages,
  ) {
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];

        final isMe =
            message.senderId == widget.currentUserId;

        final isSelected =
            _selectedMessageIds.contains(message.id);

        return ChatMessageBubble(
          message: message,
          isMe: isMe,
          isSelected: isSelected,
          onLongPress: () {
            _toggleMessageSelection(message.id);
          },
          onTap: () {
            if (_selectedMessageIds.isNotEmpty) {
              _toggleMessageSelection(message.id);
            }
          },
        );
      },
    );
  }

  // ------------------------------------------------------------
  // DELETE SELECTED
  // ------------------------------------------------------------

  void _deleteSelectedMessages() {
    final ids = List<String>.from(
      _selectedMessageIds,
    );

    for (final messageId in ids) {
      context.read<MessageBloc>().add(
            DeleteMessageEvent(
              params: DeleteMessageParams(
              messageId: messageId,
              userId: widget.currentUserId,)
            ),
          );
    }

    _clearSelection();
  }
}