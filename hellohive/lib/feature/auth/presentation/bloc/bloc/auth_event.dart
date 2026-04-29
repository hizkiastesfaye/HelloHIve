part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class SignInEvent extends AuthEvent{
  final String email;
  final String password;

  SignInEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SignUpEvent extends AuthEvent{
  final String email;
  final String password;

  SignUpEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
class SignOutEvent extends AuthEvent{}
class VerifyEmailEvent extends AuthEvent{}
class EmailVerifiedEvent extends AuthEvent{}
class ForgotPasswordEvent extends AuthEvent{
  final String email;
  ForgotPasswordEvent({required this.email});

  @override
  List<Object> get props =>[email];
}