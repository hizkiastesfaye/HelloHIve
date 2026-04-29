part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable{
  @override
  List<Object?> get props =>[];
}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
class EmailVerifiedState extends AuthState {}
final class AuthVerifyEmailState extends AuthState{}
final class ResetPasswordState extends AuthState{}
final class AuthSignedInState extends AuthState{
  final AuthEntities authEntities;
  AuthSignedInState({required this.authEntities});

  @override
  List<Object> get props => [authEntities];
}

final class AuthSignedUpState extends AuthState{
  final AuthEntities authEntities;
  AuthSignedUpState({required this.authEntities});

  @override
  List<Object> get props => [authEntities];
}

final class AuthSignedOutState extends AuthState {}
final class AuthError extends AuthState{
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}