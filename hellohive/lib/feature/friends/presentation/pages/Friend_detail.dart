import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hellohive/feature/friends/domain/entities/friends_entities.dart';
import 'package:hellohive/feature/friends/presentation/widgets/friend_photo_display_widget.dart';

import '../../../chats/presentation/bloc/chats/chats_bloc.dart';

class FriendDetailsPage extends StatefulWidget {
  final FriendsEntities friend;

  const FriendDetailsPage({super.key, required this.friend});

  @override
  State<FriendDetailsPage> createState() => _FriendDetailsPageState();
}

class _FriendDetailsPageState extends State<FriendDetailsPage> {
  bool _isMuted = false;

  FriendsEntities get friend => widget.friend;

  String get fullName {
    return '${friend.firstName} ${friend.lastName}'.trim();
  }

  String get initials {
    final first = friend.firstName.isNotEmpty
        ? friend.firstName[0].toUpperCase()
        : '';

    final last = friend.lastName.isNotEmpty
        ? friend.lastName[0].toUpperCase()
        : '';

    return '$first$last';
  }

  void _openChat() {
    context.read<ChatsBloc>().add(
      CreateChatEvent(
        currentUserId: '', // Replace with the actual current user ID
        userBId: friend.uId,
      ),
    );
    // Replace this with your chat page/navigation.
    //
    // Example:
    Navigator.pushNamed(context, '/chatMessage');
  }

  void _deleteFriend() {
    // If your ChatsBloc is already provided above this page:
    //
    // context.read<ChatsBloc>().add(
    //   DeleteChatEvent(
    //     chatId: chatId,
    //     userId: currentUserId,
    //   ),
    // );

    _showDeleteDialog();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });

    // When you have the chatId/currentUserId available:
    //
    // context.read<ChatsBloc>().add(
    //   MuteChatEvent(
    //     currentUserId: currentUserId,
    //     chatId: chatId,
    //     isMuted: _isMuted,
    //   ),
    // );
  }

  Future<void> _showDeleteDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete friend?'),
          content: Text('Are you sure you want to delete $fullName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      _deleteFriendConfirmed();
    }
  }

  void _deleteFriendConfirmed() {
    // Add your DeleteChatEvent here once this page has
    // access to the corresponding chatId and currentUserId.
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatsBloc, ChatsState>(
      listener: (context, state) {
        // TODO: implement listener
        if(state is ChatCreated){
          context.read<ChatsBloc>().add(
            GetChatEvent(
              currentUserId: '', // Replace with the actual current user ID
              userBId: friend.uId, // Replace with the actual current user ID
            ),
          );
          // Navigator.pushNamed(
          //   context,
          //   '/chatMessage',
          //   arguments: state.chatId, // Pass the chatId as an argument
          // );
        }
        if(state is ChatLoaded){
          Navigator.pushNamed(
            context,
            '/chatMessage',
            arguments: state.chat.id, // Pass the chatId as an argument
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 16),
              _buildActionButtons(),
              const SizedBox(height: 16),
              const Divider(height: 8, thickness: 8, color: Color(0xFFF2F2F2)),
              Expanded(child: _buildDetailsContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // _buildAvatar(),
        FriendPhotoDisplayWidget(photoUrl: friend.photoUrl, size: 100),
        const SizedBox(height: 12),

        Text(
          fullName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          '@${friend.username}',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 58,
      backgroundColor: const Color(0xFFFFF1D2),
      child: friend.photoUrl.isNotEmpty
          ? ClipOval(
              child: Image.network(
                friend.photoUrl,
                width: 116,
                height: 116,
                fit: BoxFit.cover,
              ),
            )
          : Text(
              initials.isEmpty ? '?' : initials,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9B7028),
              ),
            ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(label: 'Message', onPressed: _openChat),
          ),
          const SizedBox(width: 10),
          // Expanded(
          //   child: _ActionButton(
          //     label: 'Delete',
          //     onPressed: _showDeleteDialog,
          //   ),
          // ),
          // const SizedBox(width: 10),
          // Expanded(
          //   child: _ActionButton(
          //     label: _isMuted ? 'Unmute' : 'Mute',
          //     onPressed: _toggleMute,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildDetailsContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasicInformation(),
          const Divider(height: 8, thickness: 8, color: Color(0xFFF2F2F2)),
          // _buildDangerActions(),
          const Divider(height: 8, thickness: 8, color: Color(0xFFF2F2F2)),
          // _buildMediaSection(),
        ],
      ),
    );
  }

  Widget _buildBasicInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'username',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            friend.username,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),

          const SizedBox(height: 20),

          const Text(
            'About',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),

          Text(
            friend.description.isNotEmpty
                ? friend.description
                : "It's good to have HelloHive.",
            style: const TextStyle(fontSize: 17, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                // TODO: Block friend
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'Block $fullName',
                style: const TextStyle(fontSize: 17, color: Colors.redAccent),
              ),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                // TODO: Report friend
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'Report $fullName',
                style: const TextStyle(fontSize: 17, color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection() {
    return Column(
      children: [
        const SizedBox(height: 4),

        const Row(
          children: [
            Expanded(child: _MediaTab(label: 'Media', selected: true)),
            Expanded(child: _MediaTab(label: 'Document', selected: false)),
            Expanded(child: _MediaTab(label: 'Links', selected: false)),
          ],
        ),

        const SizedBox(height: 20),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'No media',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2864B5),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _MediaTab extends StatelessWidget {
  final String label;
  final bool selected;

  const _MediaTab({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 45,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 17,
                color: selected
                    ? const Color(0xFF2875D0)
                    : const Color(0xFF2875D0),
              ),
            ),
          ),
        ),
        if (selected)
          Container(width: 48, height: 2, color: const Color(0xFF2875D0)),
      ],
    );
  }
}
