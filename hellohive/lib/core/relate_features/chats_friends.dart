import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hellohive/core/core_params.dart';
import 'package:hellohive/core/errors/failure.dart';
import 'package:hellohive/feature/chats/domain/entities/chats_entities.dart';
import 'package:hellohive/feature/friends/domain/entities/friends_entities.dart';
import 'package:hellohive/feature/friends/domain/usecases/friends_usecases.dart';
import 'package:hellohive/feature/friends/friends_core/friends_usecases_core.dart';


List<String> getOtherUserIds(
    List<ChatsEntities> chats
){
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
        throw 'user error';
    }
    final currentUserId = user.uid;
    final participants = chats
        .map((chat) => chat.participants)
        .toList();
    return participants
      .expand((chat) => chat)
      .where((id) => id != currentUserId)
      .toList();
}
List<ALLChatsFriendsParams> getChatsWithFriends(
  List<ChatsEntities> chats,
  List<FriendsEntities> friends,
) {
  final friendsById = {
    for (final friend in friends)
      friend.uId: friend,
  };
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final result = <ALLChatsFriendsParams>[];

  for (final chat in chats) {
    final friendId = chat.participants.firstWhere(
      (id) => id != FirebaseAuth.instance.currentUser!.uid,
    );

    final friend = friendsById[friendId];

    if (friend == null) {
      continue;
    }

    result.add(
      ALLChatsFriendsParams(
        chatId: chat.id,
        unreadCount: chat.unreadCount[currentUserId] ?? 0,
        mutedBy: chat.mutedBy[currentUserId] ?? false,
        deletedBy: chat.deletedBy,
        createdAt: chat.createdAt,
        updatedAt: chat.updatedAt,
        lastMessageId: chat.lastMessageId,
        lastMessageText: chat.lastMessageText,
        lastMessageTime: chat.lastMessageTime,

        friendId: friend.uId,
        firstName: friend.firstName,
        lastName: friend.lastName,
        username: friend.username,
        photoUrl: friend.photoUrl,
      ),
    );
  }

  return result;
}


