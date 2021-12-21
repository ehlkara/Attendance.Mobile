import 'package:education_systems_mobile/core/security/auth_provider.dart';
import 'package:education_systems_mobile/core/security/base_auth.dart';
import 'package:education_systems_mobile/core/security/role_manager.dart';
import 'package:education_systems_mobile/data/auth/enum/user_type.dart';
import 'package:education_systems_mobile/data/auth/user.dart';
import 'package:education_systems_mobile/pages/professor/professor_login_page.dart';
import 'package:education_systems_mobile/pages/student/student_login_page.dart';
import 'package:education_systems_mobile/pages/welcome_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'base_page.dart';

enum AuthStatus { notSignedIn, signedIn }

class RootPage extends StatefulWidget implements BasePage {
  RootPage({Key key}) : super(key: key);
  final String routeName = "/";

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  BaseAuth auth;
  User currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = AuthProvider.of(context).auth;
    auth.currentUser().then((BaseUser user) {
      setState(() {
        authStatus =
        user == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;

      });
    });
  }


  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    return Container();
  }
}
