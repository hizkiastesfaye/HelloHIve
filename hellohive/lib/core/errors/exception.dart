
class ServerException implements Exception {
  final String message;
  ServerException([this.message = "Server Exception"]);

}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = "Cache Exception"]);
}

class AuthException implements Exception {
  final String message;
  AuthException([this.message = "Auth Exception"]);
}
class VerifyException implements Exception {
  final String message;
  VerifyException([this.message = "Verify Exception"]);
}
class EmailAlreadyInUseException implements Exception {
  final String message;
  EmailAlreadyInUseException([this.message = 'Email is already in use']);
}
 
class UserNotFoundException implements Exception {
  final String message;
  UserNotFoundException([this.message = 'Email is already in use']);
}
class WrongPasswordException implements Exception {
  final String message;
  WrongPasswordException([this.message = 'Email is already in use']);
}
class UnknownException implements Exception {
  final String message;
  UnknownException([this.message = "Internal Exception"]);

  @override
  String toString() {
    return message;
  }
}