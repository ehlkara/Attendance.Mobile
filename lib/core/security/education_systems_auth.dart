import 'package:education_systems_mobile/core/security/source_storage.dart';
import 'package:education_systems_mobile/data/auth/login_request.dart';
import 'package:education_systems_mobile/data/auth/login_response.dart';
import 'package:education_systems_mobile/data/auth/user.dart';
import 'package:flutter/material.dart';
import 'package:education_systems_mobile/bloc/auth/auth_repository.dart';
import 'package:education_systems_mobile/core/http/network_exceptions.dart';
import 'package:education_systems_mobile/core/http/response.dart';
import 'package:education_systems_mobile/core/security/base_auth.dart';
import 'package:education_systems_mobile/core/utilities/constants.dart' as Constants;
class EducationSystemsAuth extends BaseAuth {
  EducationSystemsAuth({@required this.authRepository});
  BaseUser currentUserValue;

  final AuthRepository authRepository;


  @override
  Future<Response> getUser(int id) async{
    Response response;
    var result = await authRepository.getUserById(id);
    result.when(success: (User authResult){
      //get user successfully
      response = new Response(success: true, result: authResult);
    }, failure: (NetworkExceptions exceptions){
      response =
      new Response(success: false, error: new ResponseError(code: 0, message: NetworkExceptions.getErrorMessage(exceptions)));
    });
    return response;
  }

  @override
  Future<BaseUser> currentUser() async {
    return currentUserValue;
  }

  @override
  Future<Response> signIn(String number, String password) async {
    Response response;
    var result =
    await authRepository.login(new LoginRequest(username: number, password: password));
    result.when(success: (LoginResponse authResult) {
      SecureStorage.instance.write(Constants.AUTH_TOKEN, authResult.accessToken);
      var constantsUser = (Constants.CURRENT_USER_ID).toString();
      currentUserValue = new User(
        id: authResult.id,
        type: authResult.userType,
        number: authResult.number,
        name: authResult.fullName,
      );
      response = new Response(success: true, result: currentUserValue);
    }, failure: (NetworkExceptions exceptions) {
      currentUserValue = null;
      response =
      new Response(success: false, error: new ResponseError(code: 0, message: NetworkExceptions.getErrorMessage(exceptions)));
    });
    return response;

  }

  @override
  Future<void> signOut() {
    SecureStorage.instance.delete(Constants.AUTH_TOKEN);
    SecureStorage.instance.delete(Constants.CURRENT_USER_ID);
    currentUserValue = null;
    return Future.value();
  }
}
