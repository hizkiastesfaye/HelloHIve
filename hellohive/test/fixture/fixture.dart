import 'dart:io';

import 'package:equatable/equatable.dart';

String Fixture(String name){
  return File('test/fixture/$name').readAsStringSync();
}

class currentUsers extends Equatable{
  final String id;
  final String email;
  final bool isEmailVerified;

  const currentUsers({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  @override
  List<Object> get props => [id,email,isEmailVerified];
}

final fakeCurrentUser = currentUsers(
  id: "aBc123xyZ908",
  email: "test@example.com",
  isEmailVerified: true
);