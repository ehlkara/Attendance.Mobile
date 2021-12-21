
import 'package:education_systems_mobile/pages/professor/professor_login_page.dart';
import 'package:education_systems_mobile/pages/student/student_login_page.dart';
import 'package:education_systems_mobile/pages/widget/bottom_navigation_bar.dart';
import 'package:education_systems_mobile/pages/widget/general_button.dart';
import 'package:flutter/material.dart';
import 'package:education_systems_mobile/pages/constants.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({Key key,this.onSignIn, this.onSignOut}) : super(key: key);
  final VoidCallback onSignOut;
  final VoidCallback onSignIn;
  final String routeName = "/welcome";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: 80, right: 20, left: 20),
            child: Column(
              children: <Widget>[
                Text(
                  "Welcome to Education Systems",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03,),
                Text(
                  "You are a few steps away from tracking your progress in class!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                  ),
                ),
                Image.asset(
                  "assets/images/home_image.jpg",
                  width: size.width * 0.8,
                ),
                GeneralButton(
                  text: "Professor Login",
                  press: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessorLoginPage())),
                ),
                SizedBox(height: size.height * 0.02,),
                GeneralButton(
                  text: "Student Login",
                  press: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => StudentLoginPage())),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: WelcomeBottomNavigationBar(),
    );
  }
}
