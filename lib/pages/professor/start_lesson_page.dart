
import 'package:education_systems_mobile/bloc/professor_sections/professor_sections_bloc.dart';
import 'package:education_systems_mobile/core/security/auth_provider.dart';
import 'package:education_systems_mobile/core/security/base_auth.dart';
import 'package:education_systems_mobile/pages/constants.dart';
import 'package:education_systems_mobile/pages/professor/bluetooth/professor_bluetooth_main_page.dart';
import 'package:education_systems_mobile/pages/widget/home_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartLessonPage extends StatefulWidget {
  StartLessonPage({Key key, this.lessonId, this.lessonName, this.isActive})
      : super(key: key);
  final String routeName = "/professor_lesson_attendance_list";
  final int lessonId;
  final String lessonName;
  final bool isActive;

  @override
  _StartLessonPageState createState() =>
      _StartLessonPageState();
}

class _StartLessonPageState
    extends State<StartLessonPage> {
  BaseUser _user;
  int _lessonId;
  String _lessonName;
  bool _isActive;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _lessonId = widget.lessonId;
    _lessonName = widget.lessonName;
    _isActive = widget.isActive;
    AuthProvider.of(context).auth.currentUser().then((user) {
      setState(() {
        _user = user;
      });
    });
    super.didChangeDependencies();
  }

  Future<void> _startLesson(BuildContext buildContext,int lessonId) async{
    buildContext.read<ProfessorSectionsBloc>().repository.startLesson(lessonId)
        .then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessorBluetoothMainPage(
        lessonId: _lessonId,
        isActive: _isActive,
        lessonName: _lessonName,
      )));
    }
   );
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Professor System',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    _user == null ? '' : _user.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FaIcon(
                    FontAwesomeIcons.userCircle,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
      body: _dataWidget(context),
      bottomNavigationBar: HomeBottomNavigationBar(),
    );
  }

  _dataWidget(BuildContext buildContext) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(right: 20, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              _lessonName ,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 20),
            ),
            SizedBox(
              height: 5,
            ),
            new SizedBox(
              height: 5.0,
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(
                      start: 1.0, end: 1.0),
                  height: 2.0,
                  color: kPrimaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Dersi başlattıktan sonra yoklama almaya başlayabilirsiniz.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16),
            ),
            SizedBox(
              height: 60,
            ),
            ListTile(
              title: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                  child: const Text('Start Lesson', style: TextStyle(fontSize: 16),),
                  onPressed: () async {
                    _startLesson(buildContext,_lessonId);
                  }),
            ),
          ],
        ),
      ),
    );
  }

}
