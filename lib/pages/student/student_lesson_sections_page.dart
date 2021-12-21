import 'package:education_systems_mobile/bloc/student_sections/student_sections_bloc.dart';
import 'package:education_systems_mobile/core/bloc/result_state.dart';
import 'package:education_systems_mobile/core/http/network_exceptions.dart';
import 'package:education_systems_mobile/core/http/response.dart';
import 'package:education_systems_mobile/core/security/auth_provider.dart';
import 'package:education_systems_mobile/core/security/base_auth.dart';
import 'package:education_systems_mobile/data/lesson/enum/status_type_enum.dart';
import 'package:education_systems_mobile/data/lesson/lesson_sections_response.dart';
import 'package:education_systems_mobile/data/lesson/section_request.dart';
import 'package:education_systems_mobile/data/lesson/user_lesson_map_request.dart';
import 'package:education_systems_mobile/pages/constants.dart';
import 'package:education_systems_mobile/pages/student/bluetooth/bluetooth_main_page.dart';
import 'package:education_systems_mobile/pages/widget/home_bottom_navigation_bar.dart';
import 'package:education_systems_mobile/data/lesson/lesson_list_response.dart' as lesson_res;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

class StudentLessonSectionsPage extends StatefulWidget {
  StudentLessonSectionsPage({Key key, this.sectionRequest}) : super(key: key);
  final String routeName = "/student_lesson_sections";
  final SectionRequest sectionRequest;

  @override
  _StudentLessonSectionsPageState createState() => _StudentLessonSectionsPageState();
}

class _StudentLessonSectionsPageState extends State<StudentLessonSectionsPage> {
  BaseUser _user;
  SectionRequest _sectionRequest = new SectionRequest();
  lesson_res.Lesson currentLesson;
  FToast fToast;

  Map<String, double> dataMap = {
    "Present": 0,
    "Absent": 0,
    "Attendance": 5
  };

  final colorList = <Color>[
    Colors.green,
    Colors.red,
    Colors.grey,
  ];

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void didChangeDependencies() {
    _sectionRequest = widget.sectionRequest;

    context.read<StudentSectionsBloc>().getSections(_sectionRequest);
    AuthProvider.of(context).auth.currentUser().then((user) {
      setState(() {
        _user = user;
      });
    });
    super.didChangeDependencies();
  }

  void _loadLessonListById(BuildContext buildContext, int userId) async {
    context.read<StudentSectionsBloc>().getSections(_sectionRequest);
  }

  Future<void> _updateAttendance(BuildContext buildContext, Lesson lesson) async{
    buildContext.read<StudentSectionsBloc>().repository.updateStudentAttendance(new UserLessonMapRequest(
      statusType: 2,
      userLessonMapId: lesson.userLessonMapId
    )).then((value) => _loadLessonListById(buildContext, lesson.userId));
  }

  Future<void> _getLesson(BuildContext buildContext, Lesson lesson) async{
    var result = await context.read<StudentSectionsBloc>().repository.getLessonById(lesson.lessonId);
    result.when(success: (lesson_res.Lesson data){
      currentLesson = data;
    }, failure: (NetworkExceptions exceptions){
      var response =
      new Response(success: false, error: new ResponseError(code: 0, message: NetworkExceptions.getErrorMessage(exceptions)));
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Student System',
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
                    _user == null ? '' : _user.number,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 10,
                  ), FaIcon(
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
      body: BlocBuilder<StudentSectionsBloc, ResultState<LessonSectionsListResponse>>(
        builder: (BuildContext context, ResultState<LessonSectionsListResponse> state) {
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

  _dataWidget(BuildContext buildContext, LessonSectionsListResponse data) {
    Size size = MediaQuery.of(context).size;
     dataMap = {
      "Present": data.lessons.where((e) => e.statusType == StatusTypeEnum.Present.value).length.toDouble(),
      "Absent": data.lessons.where((e) => e.statusType == StatusTypeEnum.Absent.value).length.toDouble(),
      "Attendance": data.lessons.where((e) => e.statusType == StatusTypeEnum.Attendance.value).length.toDouble(),
    };
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(right: 10, left: 10.0),
              child: Column(
                children: [
                  Text(
                    data.lessons.first.lessonCode + " - "+ data.lessons.first.lessonTitle,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                  SizedBox(height: 5,),
                  new SizedBox(
                    height: 5.0,
                    child: new Center(
                      child: new Container(
                        margin: new EdgeInsetsDirectional.only(
                            start: 1.0, end: 1.0),
                        height: 3.0,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: size.width*0.45,
                          child: Column(
                            children: [
                              Text(
                                "ATTENDANCE",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 16),
                              ),
                              SizedBox(height: 20,),
                              PieChart(
                                dataMap: dataMap,
                                animationDuration: Duration(milliseconds: 800),
                                chartLegendSpacing: 32,
                                chartRadius: size.width / 5.2,
                                colorList: colorList,
                                initialAngleInDegree: 0,
                                chartType: ChartType.ring,
                                ringStrokeWidth: 20,
                                legendOptions: LegendOptions(
                                  showLegendsInRow: false,
                                  legendPosition: LegendPosition.right,
                                  showLegends: false,
                                  legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                chartValuesOptions: ChartValuesOptions(
                                  showChartValueBackground: true,
                                  showChartValues: true,
                                  showChartValuesInPercentage: true,
                                  showChartValuesOutside: false,
                                  decimalPlaces: 1,
                                ),
                                // gradientList: ---To add gradient colors---
                                // emptyColorGradient: ---Empty Color gradient---
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: size.width* 0.43,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.userCircle,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                  SizedBox(width: 5,),
                                  Column(
                                    children: [
                                      Text(
                                        _user == null ? '' : _user.name,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 14, ),
                                      ),
                                      Text(
                                        _user == null ? '' : _user.number,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 14,),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 15,),
                              Text(
                                "Attendance: ${data.lessons.where((e) => e.statusType == StatusTypeEnum.Present.value).length}/${data.lessons.length}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 20,),
                              Text(
                                "Note: The attendance rate for the course is 70%. If it drops below 70%, you lose your right to take the Final Exam",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                ],
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.lessons.length,
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
                            height: 3.0,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        child: _getLessonListItemView(
                            buildContext, data.lessons[index], index),
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

  _getLessonListItemView(
      BuildContext buildContext, Lesson lesson, int itemIndex) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        new Row(
          children: [
            Container(
              width: size.width * 0.58,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Text(lesson.lessonCode + "-" + lesson.lessonTitle),
                  SizedBox(
                    height: 4,
                  ),
                  Text(DateFormat('dd-MM-yyyy kk:mm').format(lesson.lessonDate)),
                ],
              ),
            ),
            Container(
              width: size.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  _buttonView(buildContext,lesson),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buttonView(BuildContext buildContext, Lesson lesson){
    Color buttonColor;
    String buttonText;
    if(lesson.statusType == StatusTypeEnum.Present.value){
      buttonColor = Colors.green;
      buttonText = "Present";
    }
    else if(lesson.statusType == StatusTypeEnum.Absent.value){
      buttonColor = Colors.red;
      buttonText = "Absent";
    }
    else if (lesson.statusType == StatusTypeEnum.Attendance.value){
      buttonColor = kPrimaryColor;
      buttonText = "Attendance";
    }
    return Container(
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
        ),
        onPressed: () {
          if(lesson.statusType == StatusTypeEnum.Attendance.value){
          //_updateAttendance(buildContext, lesson);
            _getLesson(buildContext, lesson).then((value) {
              if(currentLesson.isActive){
                Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothMainPage(
                  userLessonMapId: lesson.userLessonMapId,
                  professorId: lesson.professorId,
                  lessonCode: lesson.lessonCode,
                )));
              }
              else{
                //ders henüz başlamadı error
                fToast.showToast(
                  child: toast,
                  toastDuration: Duration(seconds: 3),
                  fadeDuration: 2000,
                );
              }
            });
          }
        },
        child: Column(
          children: [
            Text(
              buttonText,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

Widget toast = Container(
  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(25.0),
    color: Colors.red,
  ),
  child: Text("Ders henüz başlatılmadı!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
);