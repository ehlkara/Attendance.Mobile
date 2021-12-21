import 'package:flutter/material.dart';
import 'package:education_systems_mobile/pages/constants.dart';
import 'package:flutter/services.dart';

class WelcomeBottomNavigationBar extends StatefulWidget {
  const WelcomeBottomNavigationBar({
    Key key,
  }) : super(key: key);

  @override
  _WelcomeBottomNavigationBarState createState() =>
      _WelcomeBottomNavigationBarState();
}

class _WelcomeBottomNavigationBarState
    extends State<WelcomeBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 60,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          SystemNavigator.pop();
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
          child: Column(
            children: <Widget>[
              Divider(
                color: kPrimaryColor,
                height: 10,
              ),
              Text(
                'Exit',
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
