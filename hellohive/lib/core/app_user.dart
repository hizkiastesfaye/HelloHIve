import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;

  /// Friends of the current user.
  final List<String> friendIds;

  const AppUser({
    required this.id,
    required this.friendIds,
  });

  AppUser copyWith({
    String? id,
    List<String>? friendIds,
  }) {
    return AppUser(
      id: id ?? this.id,
      friendIds: friendIds ?? this.friendIds,
    );
  }

  @override
  List<Object> get props => [
        id,
        friendIds,
      ];
}