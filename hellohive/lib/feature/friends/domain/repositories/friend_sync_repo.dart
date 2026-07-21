abstract class FriendSyncRepository {
  Future<void> initialize();

  Future<void> syncFriends(List<String> friendIds);

  Future<void> addFriend(String friendId);

  Future<void> removeFriend(String friendId);

  Future<void> dispose();
}