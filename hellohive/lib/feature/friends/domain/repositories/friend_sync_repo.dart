import 'package:dartz/dartz.dart';
import 'package:hellohive/core/errors/failure.dart';

abstract class FriendsSyncRepository {
  Future<Either<Failure, Unit>> syncFriends();

  Future<Either<Failure, Unit>> dispose();
}