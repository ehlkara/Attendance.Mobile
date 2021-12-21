
import 'package:education_systems_mobile/data/auth/enum/user_type.dart';
import 'package:education_systems_mobile/data/auth/user.dart';
import 'package:education_systems_mobile/pages/professor/professor_home_page.dart';
import 'package:education_systems_mobile/pages/student/student_home_page.dart';
import 'package:education_systems_mobile/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'auth_provider.dart';

class RoleManager {
  RoleManager();

  static Widget getHomePage(
      BuildContext context, VoidCallback onSignOutCallback) {
    return FutureBuilder(
        future: AuthProvider.of(context).auth.currentUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            User currentUser = snapshot.data;
            if (currentUser.type == UserTypeEnum.Student.value) {
              return new StudentHomePage(onSignOut: () => onSignOutCallback);
            } else if (currentUser.type == UserTypeEnum.Professor.value){
              return new ProfessorHomePage(onSignOut: () => onSignOutCallback);
            }
            return new WelcomePage(onSignOut: () => onSignOutCallback);
          }
          return Container();
        });
  }

}
