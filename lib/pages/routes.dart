import 'package:education_systems_mobile/pages/professor/professor_home_page.dart';
import 'package:education_systems_mobile/pages/professor/professor_login_page.dart';
import 'package:education_systems_mobile/pages/root_page.dart';
import 'package:education_systems_mobile/pages/student/student_home_page.dart';
import 'package:education_systems_mobile/pages/student/student_lesson_sections_page.dart';
import 'package:education_systems_mobile/pages/student/student_login_page.dart';
import 'package:education_systems_mobile/pages/welcome_page.dart';
import 'package:flutter/material.dart';


class Routes {
  static String rootPage = RootPage().routeName;
  static String studentHomePage = StudentHomePage().routeName;
  static String professorHomePage = ProfessorHomePage().routeName;
  static String professorLoginPage = ProfessorLoginPage().routeName;
  static String studentLoginPage = StudentLoginPage().routeName;
  static String studentLessonSectionsPage = StudentLessonSectionsPage().routeName;

  static Map<String, WidgetBuilder> get() {
    Map<String, WidgetBuilder> routes = {
      studentHomePage: (context) => StudentHomePage(),
      professorHomePage: (context) => ProfessorHomePage(),
      professorLoginPage: (context) => ProfessorLoginPage(),
      studentLoginPage: (context) => StudentLoginPage()
    };
    return routes;
  }
}
