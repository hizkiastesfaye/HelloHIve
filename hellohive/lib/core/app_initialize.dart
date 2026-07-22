import 'package:hellohive/core/usecases/usecase.dart';
import 'package:hellohive/feature/friends/domain/usecases/friends_sync_usecase.dart';
import 'package:hellohive/feature/friends/friends_core/friends_usecases_core.dart';

class AppInitializer {
  final SyncFriendsUseCase syncFriendsUseCase;
  final DisposeFriendSyncUseCase disposeFriendSyncUseCase;

  AppInitializer({
    required this.syncFriendsUseCase,
    required this.disposeFriendSyncUseCase,
  });

  Future<void> start({
    required List<String> friendIds,
  }) async {
    await syncFriendsUseCase(
      FriendsIdsParams(
        friendsIds: friendIds,
      ),
    );
  }

  Future<void> stop() async {
    await disposeFriendSyncUseCase(NoParams());
  }
}