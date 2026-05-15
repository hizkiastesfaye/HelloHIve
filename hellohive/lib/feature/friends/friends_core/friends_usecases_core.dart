
import 'package:equatable/equatable.dart';

class FriendsParams extends Equatable{
  final String value;
  final String fieldName;

  FriendsParams({
    required this.value,
    required this.fieldName
  });

  @override
  List<Object?> get props=>[value, fieldName];
}