import 'package:education_systems_mobile/bloc/professor_sections/professor_sections_bloc.dart';
import 'package:education_systems_mobile/bloc/student_attendance/student_attendance_list_bloc.dart';
import 'package:education_systems_mobile/core/bloc/result_state.dart';
import 'package:education_systems_mobile/core/http/network_exceptions.dart';
import 'package:education_systems_mobile/core/security/auth_provider.dart';
import 'package:education_systems_mobile/core/security/base_auth.dart';
import 'package:education_systems_mobile/data/lesson/enum/status_type_enum.dart';
import 'package:education_systems_mobile/data/lesson/lesson_list_response.dart';
import 'package:education_systems_mobile/data/lesson/section_request.dart';
import 'package:education_systems_mobile/data/lesson/student_attendance_list_response.dart';
import 'package:education_systems_mobile/pages/constants.dart';
import 'package:education_systems_mobile/pages/professor/bluetooth/professor_bluetooth_main_page.dart';
import 'package:education_systems_mobile/pages/professor/start_lesson_page.dart';
import 'package:education_systems_mobile/pages/widget/general_button.dart';
import 'package:education_systems_mobile/pages/widget/home_bottom_navigation_bar.dart';
import 'package:education_systems_mobile/pages/widget/small_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ProfessorLessonAttendanceListPage extends StatefulWidget {
  ProfessorLessonAttendanceListPage({Key key, this.lessonId, this.lessonName,this.lessonIsActive})
      : super(key: key);
  final String routeName = "/professor_lesson_attendance_list";
  final int lessonId;
  final String lessonName;
  final bool lessonIsActive;

  @override
  _ProfessorLessonAttendanceListPageState createState() =>
      _ProfessorLessonAttendanceListPageState();
}

class _ProfessorLessonAttendanceListPageState
    extends State<ProfessorLessonAttendanceListPage> {
  BaseUser _user;
  int _lessonId;
  String _lessonName;
  bool _lessonIsActive;
  int _filterValue = StatusTypeEnum.Attendance.value;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _lessonIsActive= widget.lessonIsActive;
    _lessonId = widget.lessonId;
    _lessonName = widget.lessonName;
    context.read<StudentAttendanceListBloc>().getAttendance(_lessonId);
    AuthProvider.of(context).auth.currentUser().then((user) {
      setState(() {
        _user = user;
      });
    });
    super.didChangeDependencies();
  }

  void _loadLessonListById(BuildContext buildContext, int userId) async {
    context.read<StudentAttendanceListBloc>().getAttendance(_lessonId);
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
      body: BlocBuilder<StudentAttendanceListBloc,
          ResultState<StudentAttendanceListResponse>>(
        builder: (BuildContext context,
            ResultState<StudentAttendanceListResponse> state) {
          return state.when(
              idle: () => Container(),
              loading: () => Center(child: CircularProgressIndicator()),
              data: (data) => _dataWidget(context, data),
              error: (error) => Center(
                  child: Text(NetworkExceptions.getErrorMessage(error))));
        },
      ),
      bottomNavigationBar: HomeBottomNavigationBar(),
    );
  }

  _dataWidget(BuildContext buildContext, StudentAttendanceListResponse data) {
    Size size = MediaQuery.of(context).size;
    StudentAttendanceListResponse innerData = data;
    if (_filterValue == StatusTypeEnum.Attendance.value) {
      innerData = data;
    } else {
      var values = data.studentAttendances
          .where((e) => e.statusType == _filterValue)
          .toList();
      innerData = new StudentAttendanceListResponse(studentAttendances: values);
    }
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20.0),
              child: Column(
                children: [
                  Text(
                    _lessonName,
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
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SmallButton(
                          text: "P",
                          color: kPrimaryColor,
                          press: () {
                            setState(() {
                              _filterValue = StatusTypeEnum.Present.value;
                            });
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SmallButton(
                          text: "A",
                          color: kPrimaryColor,
                          press: () {
                            setState(() {
                              _filterValue = StatusTypeEnum.Absent.value;
                            });
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SmallButton(
                          text: "All",
                          color: kPrimaryColor,
                          press: () {
                            setState(() {
                              _filterValue = StatusTypeEnum.Attendance.value;
                            });
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        _widgetBluetoothButton(buildContext),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.28,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Student ID",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name-Surname",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * 0.28,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Attendance",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: innerData.studentAttendances.length,
              itemBuilder: (BuildContext itemBuilderContext, int index) {
                return Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  child: Column(
                    children: [
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
                      Container(
                        height: size.height * 0.06,
                        child: _getLessonListItemView(buildContext,
                            innerData.studentAttendances[index], index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _widgetBluetoothButton(BuildContext buildContext){
    return IconButton(
      onPressed: (){
        if(!_lessonIsActive){
          Navigator.push(context, MaterialPageRoute(builder: (context) => StartLessonPage(
            lessonId: _lessonId,
            lessonName: _lessonName,
            isActive: _lessonIsActive,
          )));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessorBluetoothMainPage(
            lessonName: _lessonName,
            lessonId: _lessonId,
            isActive: _lessonIsActive,
          )));
        }
      },
      icon: FaIcon(
        FontAwesomeIcons.bluetooth,
        color: Colors.green,
        size: 30,
      ),
    );
  }

  _getLessonListItemView(BuildContext buildContext,
      StudentAttendance studentAttendance, int itemIndex) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(studentAttendance.number),
                ],
              ),
            ),
            Container(
              width: size.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(studentAttendance.fullName),
                ],
              ),
            ),
            Container(
              width: size.width * 0.28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(studentAttendance.statusType ==
                          StatusTypeEnum.Attendance.value
                      ? "Attendance"
                      : studentAttendance.statusType ==
                              StatusTypeEnum.Present.value
                          ? "Present "
                          : "Absent"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
