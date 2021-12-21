import 'package:education_systems_mobile/core/http/response.dart';
import 'package:education_systems_mobile/data/auth/enum/user_type.dart';

abstract class BaseAuth {
  Future<BaseUser> currentUser();
  Future<Response> signIn(String number, String password);
  Future<Response> getUser(int id);
  Future<void> signOut();
}

abstract class BaseUser {
  int id;
  String number;
  String name;
  UserTypeEnum userType;
}
