import 'package:education_systems_mobile/bloc/professor_sections/professor_sections_bloc.dart';
import 'package:education_systems_mobile/core/bloc/result_state.dart';
import 'package:education_systems_mobile/core/http/network_exceptions.dart';
import 'package:education_systems_mobile/core/security/auth_provider.dart';
import 'package:education_systems_mobile/core/security/base_auth.dart';
import 'package:education_systems_mobile/data/lesson/lesson_list_response.dart';
import 'package:education_systems_mobile/data/lesson/section_request.dart';
import 'package:education_systems_mobile/pages/constants.dart';
import 'package:education_systems_mobile/pages/professor/professor_lesson_attendance_list_page.dart';
import 'package:education_systems_mobile/pages/widget/home_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ProfessorLessonSectionsPage extends StatefulWidget {
  ProfessorLessonSectionsPage({Key key, this.sectionRequest}) : super(key: key);
  final String routeName = "/professor_lesson_sections";
  final SectionRequest sectionRequest;

  @override
  _ProfessorLessonSectionsPageState createState() => _ProfessorLessonSectionsPageState();
}

class _ProfessorLessonSectionsPageState extends State<ProfessorLessonSectionsPage> {
  BaseUser _user;
  SectionRequest _sectionRequest = new SectionRequest();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _sectionRequest = widget.sectionRequest;

    context.read<ProfessorSectionsBloc>().getSections(_sectionRequest);
    AuthProvider.of(context).auth.currentUser().then((user) {
      setState(() {
        _user = user;
      });
    });
    super.didChangeDependencies();
  }

  void _loadLessonListById(BuildContext buildContext, int userId) async {
    context.read<ProfessorSectionsBloc>().getSections(_sectionRequest);
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
      body: BlocBuilder<ProfessorSectionsBloc, ResultState<LessonListResponse>>(
        builder: (BuildContext context, ResultState<LessonListResponse> state) {
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

  _dataWidget(BuildContext buildContext, LessonListResponse data) {
    Size size = MediaQuery.of(context).size;
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
                    "Lesson Sections",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                        height: 76,
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
                  Text(lesson.code + "-" + lesson.title),
                  SizedBox(
                    height: 4,
                  ),
                  Text(DateFormat('dd-MM-yyyy kk:mm').format(lesson.date)),
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessorLessonAttendanceListPage(
                        lessonId: lesson.id,
                        lessonName: lesson.code +" - " + lesson.title,
                        lessonIsActive: lesson.isActive
                      )));
                    },
                    child: Column(
                      children: [
                        Text(
                          "Attendance",
                          style: TextStyle(fontSize: 12),
                        ),
                        Center(
                          child: Text(
                            "View",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
