import 'package:flutter/material.dart';
import 'package:hellohive/feature/chats/domain/entities/message_entities.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageEntities message;
  final bool isMe;
  final bool isSelected;

  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: double.infinity,
        color: isSelected
            ? Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.10)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(
          vertical: 2,
        ),
        child: Align(
          alignment:
              isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: _buildBubble(context),
        ),
      ),
    );
  }

  Widget _buildBubble(BuildContext context) {
    if (message.type == MessageType.text) {
      return Container(
        constraints: const BoxConstraints(
          maxWidth: 300,
        ),
        margin: EdgeInsets.only(
          left: isMe ? 50 : 0,
          right: isMe ? 0 : 50,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(
              isMe ? 18 : 4,
            ),
            bottomRight: Radius.circular(
              isMe ? 4 : 18,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.text != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  message.text!,
                  style: TextStyle(
                    color: isMe
                        ? Colors.white
                        : Theme.of(context)
                            .colorScheme
                            .onSurface,
                    fontSize: 16,
                  ),
                ),
              ),
            const SizedBox(height: 4),
            _buildMessageInfo(context),
          ],
        ),
      );
    }

    return _buildMediaPlaceholder(context);
  }

  Widget _buildMessageInfo(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message.isEdited)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              'edited',
              style: TextStyle(
                fontSize: 10,
                color: isMe
                    ? Colors.white70
                    : Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
              ),
            ),
          ),
        Text(
          _formatTime(message.createdAt),
          style: TextStyle(
            fontSize: 10,
            color: isMe
                ? Colors.white70
                : Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
          ),
        ),
        if (isMe) ...[
          const SizedBox(width: 4),
          _buildStatusIcon(),
        ],
      ],
    );
  }

  Widget _buildStatusIcon() {
    switch (message.status) {
      case MessageStatus.pending:
        return const Icon(
          Icons.access_time,
          size: 14,
          color: Colors.white70,
        );

      case MessageStatus.sent:
        return const Icon(
          Icons.done,
          size: 14,
          color: Colors.white70,
        );

      case MessageStatus.read:
        return const Icon(
          Icons.done_all,
          size: 14,
          color: Colors.white,
        );

      case MessageStatus.failed:
        return const Icon(
          Icons.error_outline,
          size: 14,
          color: Colors.redAccent,
        );
    }
  }

  Widget _buildMediaPlaceholder(BuildContext context) {
    IconData icon;

    switch (message.type) {
      case MessageType.image:
        icon = Icons.image;
        break;
      case MessageType.video:
        icon = Icons.video_file;
        break;
      case MessageType.audio:
        icon = Icons.audio_file;
        break;
      case MessageType.file:
        icon = Icons.insert_drive_file;
        break;
      case MessageType.text:
        icon = Icons.message;
        break;
    }

    return Container(
      width: 220,
      height: 150,
      decoration: BoxDecoration(
        color: isMe
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        icon,
        size: 50,
        color: isMe
            ? Colors.white
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0
        ? 12
        : time.hour % 12;

    final minute =
        time.minute.toString().padLeft(2, '0');

    final period =
        time.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}