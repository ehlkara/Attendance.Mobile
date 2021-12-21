
import 'package:education_systems_mobile/bloc/professor_home/professor_repository.dart';
import 'package:education_systems_mobile/core/bloc/result_state.dart';
import 'package:education_systems_mobile/core/http/api_result.dart';
import 'package:education_systems_mobile/core/http/network_exceptions.dart';
import 'package:education_systems_mobile/data/lesson/lesson_list_response.dart';
import 'package:education_systems_mobile/data/lesson/section_request.dart';
import 'package:education_systems_mobile/data/lesson/student_attendance_list_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentAttendanceListBloc extends Cubit<ResultState<StudentAttendanceListResponse>> {
  StudentAttendanceListBloc({this.repository})
      : assert(repository != null),
        super(Idle());
  final ProfessorRepository repository;

  getAttendance(int lessonId)async{
    emit(ResultState.loading());
    ApiResult<StudentAttendanceListResponse> apiResult = await repository.getLessonsAttendance(lessonId);
    apiResult.when(
      success: (StudentAttendanceListResponse data) => emit(ResultState.data(data: data)),
      failure: (NetworkExceptions error) => emit(ResultState.error(error: error)),
    );
  }

}