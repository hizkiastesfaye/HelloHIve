import 'package:flutter/material.dart';

class ChatMessagePage extends StatefulWidget {
  

  const ChatMessagePage({
    super.key,
  });

  @override
  State<ChatMessagePage> createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String userName = 'Bharath'; // Replace with the actual user name
  bool _isMuted = false;

  // Temporary UI data only.
  // We will replace this with BLoC state later.
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: 'Phone Mac address: 00:c8:f8:50:2f:d1',
      time: '20:05',
      isMine: false,
    ),
    _ChatMessage(
      text: 'Phone Mac address: 00:c8:f8:50:2f:d1',
      time: '20:05',
      isMine: false,
    ),
    _ChatMessage(
      text: 'PC Mac needs to connect to corp',
      time: '20:05',
      isMine: false,
    ),
    _ChatMessage(
      text: 'I have provisioned the phone mac address',
      time: '20:09',
      isMine: false,
    ),
    _ChatMessage(
      text: "Bharath's pc is his own personal PC. Phone is not working",
      time: '21:08',
      isMine: false,
    ),
    _ChatMessage(
      text: 'Your phone is not working',
      time: '21:18',
      isMine: false,
    ),
    _ChatMessage(
      text:
          'Please share a snap of your mac address ensuring randomised mac is turned off',
      time: '21:18',
      isMine: false,
    ),
    _ChatMessage(
      text: 'His credentials should also work on Corp wifi',
      time: '21:22',
      isMine: false,
    ),
    _ChatMessage(
      text: 'You need to turn off randomised mac',
      time: '21:41',
      isMine: false,
    ),
    _ChatMessage(
      text: "Bharath's pc is his own personal PC. Phone is not working",
      time: '21:09',
      isMine: false,
    ),
    _ChatMessage(
      text: 'Test now',
      time: '22:07',
      isMine: false,
    ),
    _ChatMessage(
      text: "Now it's working\nThanks",
      time: '21:09',
      isMine: true,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    // UI only for now.
    setState(() {
      _messages.add(
        _ChatMessage(
          text: text,
          time: _formatTime(DateTime.now()),
          isMine: true,
        ),
      );

      _messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFE7DE),
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF075E54),
      foregroundColor: Colors.white,
      automaticallyImplyLeading: true,
      titleSpacing: 0,
      title: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Color(0xFF9E9E9E),
              size: 25,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              userName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // UI only.
          },
          icon: const Icon(Icons.videocam_outlined),
        ),
        IconButton(
          onPressed: () {
            // UI only.
          },
          icon: const Icon(Icons.call_outlined),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'mute') {
              _toggleMute();
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 'mute',
                child: Row(
                  children: [
                    Icon(
                      _isMuted
                          ? Icons.notifications_active_outlined
                          : Icons.notifications_off_outlined,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isMuted ? 'Unmute notifications' : 'Mute notifications',
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'search',
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 12),
                    Text('Search'),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildMessageList() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFEFE7DE),
      ),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          top: 12,
          bottom: 8,
        ),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];

          return _MessageBubble(
            message: message,
          );
        },
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 5, 6, 5),
      color: const Color(0xFFF0F0F0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 46,
                maxHeight: 130,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      // UI only.
                    },
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: Color(0xFF6F6F6F),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(
                          color: Color(0xFF777777),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 2,
                          right: 4,
                          bottom: 12,
                          top: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // UI only.
                    },
                    icon: const Icon(
                      Icons.attach_file,
                      color: Color(0xFF6F6F6F),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // UI only.
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Color(0xFF6F6F6F),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF128C7E),
              ),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _messageController,
                builder: (context, value, child) {
                  return Icon(
                    value.text.trim().isEmpty
                        ? Icons.mic
                        : Icons.send,
                    color: Colors.white,
                    size: 23,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: EdgeInsets.only(
          left: message.isMine ? 45 : 0,
          right: message.isMine ? 0 : 45,
          bottom: 3,
        ),
        padding: const EdgeInsets.fromLTRB(
          9,
          6,
          7,
          5,
        ),
        decoration: BoxDecoration(
          color: message.isMine
              ? const Color(0xFFD9FDD3)
              : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(7),
            topRight: const Radius.circular(7),
            bottomLeft: Radius.circular(
              message.isMine ? 7 : 0,
            ),
            bottomRight: Radius.circular(
              message.isMine ? 0 : 7,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                message.text,
                style: const TextStyle(
                  color: Color(0xFF202020),
                  fontSize: 14.5,
                  height: 1.25,
                ),
              ),
            ),
            const SizedBox(width: 7),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: const TextStyle(
                    color: Color(0xFF777777),
                    fontSize: 10.5,
                  ),
                ),
                if (message.isMine) ...[
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.done_all,
                    size: 15,
                    color: Color(0xFF53BDEB),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final String time;
  final bool isMine;

  const _ChatMessage({
    required this.text,
    required this.time,
    required this.isMine,
  });
}
