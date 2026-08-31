import 'package:flutter/material.dart';

class MessageSelectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int selectedCount;
  final VoidCallback onClose;
  final VoidCallback onDelete;

  const MessageSelectionAppBar({
    super.key,
    required this.selectedCount,
    required this.onClose,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: onClose,
        icon: const Icon(Icons.close),
      ),
      title: Text(
        '$selectedCount',
      ),
      actions: [
        if (selectedCount == 1)
          IconButton(
            onPressed: () {
              // Reply
            },
            icon: const Icon(Icons.reply),
          ),

        if (selectedCount == 1)
          IconButton(
            onPressed: () {
              // Edit
            },
            icon: const Icon(Icons.edit),
          ),

        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
        ),

        IconButton(
          onPressed: () {
            // More actions
          },
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}