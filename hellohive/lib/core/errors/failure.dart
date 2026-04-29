import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final String message;
  Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure{
  ServerFailure([String message = "Server Failure"]): super(message);
}
class CacheFailure extends Failure{
  CacheFailure([String message = "Cache Failure"]): super(message);
}
class InvalidInputFailure extends Failure{
  InvalidInputFailure([String message = "Invalid Input Failure"]): super(message);
}
class AuthFailure extends Failure{
  AuthFailure([String message = "Auth Failure"]): super(message);
}
class VerifyFailure extends Failure{
  VerifyFailure([String message = "Verify Failure"]): super(message);
}
class NetworkFailure extends Failure{
  NetworkFailure([String message = "Network Failure"]): super(message);
}
class UnknownFailure extends Failure{
  UnknownFailure([String message = "Internal Failure"]): super(message);
}
