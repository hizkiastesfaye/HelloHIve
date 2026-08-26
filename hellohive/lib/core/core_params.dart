
import 'package:equatable/equatable.dart';

class ALLChatsFriendsParams extends Equatable{
  final String chatId;
  final Map<String, int> unreadCount;
  final Map<String, bool> mutedBy;
  final Map<String, bool> deletedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastMessageId;
  final String? lastMessageText;
  final DateTime? lastMessageTime;
  final String friendId;
  final String firstName;
  final String lastName;
  final String username;
  final String photoUrl;

  ALLChatsFriendsParams({
    required this.chatId,
    required this.unreadCount,
    required this.mutedBy,
    required this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessageId,
    this.lastMessageText,
    this.lastMessageTime,
    required this.friendId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.photoUrl,
  });

    @override
  List<Object?> get props => [
    chatId,unreadCount,mutedBy,deletedBy,
    createdAt,updatedAt,friendId, firstName,
    lastName, username, photoUrl,
    lastMessageId,lastMessageText,lastMessageTime,
    
  ];
  

}