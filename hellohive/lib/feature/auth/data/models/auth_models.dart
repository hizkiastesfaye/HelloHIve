import 'package:hellohive/feature/auth/domain/entities/auth_entities.dart';

class AuthModels extends AuthEntities{
  final String id;
  final String email;
  final bool isEmailVerified;

  const AuthModels({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  }) : super(
    id: id,
    email: email,
    isEmailVerified: isEmailVerified,
  );

  factory AuthModels.fromJson(Map<String, dynamic> json){
    return AuthModels(
      id: json['id'],
      email: json['email'],
      isEmailVerified: json['isEmailVerified'],
    );
  } 

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'email': email,
      'isEmailVerified': isEmailVerified,
    };
  }
}