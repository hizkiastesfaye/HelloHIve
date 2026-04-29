
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hellohive/feature/auth/data/models/auth_models.dart';
import 'package:hellohive/feature/auth/domain/entities/auth_entities.dart';

import '../../../../fixture/fixture.dart';

void main(){
    final tauthRes = json.decode(Fixture('auth.json'));
    final tAuthEntities = AuthEntities(
      id: tauthRes['id'], 
      email: tauthRes['email'], 
      isEmailVerified: tauthRes['isEmailVerified']
    );
    final tAuthModel = AuthModels(
      id: tauthRes['id'], 
      email: tauthRes['email'], 
      isEmailVerified: tauthRes['isEmailVerified']
    );
  test('AuthModel is subclass of AuthEntities', (){
    //assert
    expect(tAuthModel, isA<AuthEntities>());
  });

  test('In fromJson, should return a valid model when FirebaseAuth is provided',(){
    //act
    final result = AuthModels.fromJson(tauthRes);
    //assert
    expect(result, tAuthModel);
  });

  test('In toJson, should return a JSON map containing the proper data',(){
    //act
    final result = tAuthModel.toJson();
    //assert
    final Map<String, dynamic> expectedMap = tauthRes;
    expect(result, expectedMap);
  });

}