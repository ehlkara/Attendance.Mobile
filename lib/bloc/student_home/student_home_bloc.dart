
import 'package:education_systems_mobile/bloc/student_home/student_repository.dart';
import 'package:education_systems_mobile/core/bloc/result_state.dart';
import 'package:education_systems_mobile/core/http/api_result.dart';
import 'package:education_systems_mobile/core/http/network_exceptions.dart';
import 'package:education_systems_mobile/data/lesson/lesson_list_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomeBloc extends Cubit<ResultState<LessonListResponse>> {
  StudentHomeBloc({this.repository})
      : assert(repository != null),
        super(Idle());
  final StudentRepository repository;

  getStudentList(int userId)async{
    emit(ResultState.loading());
    ApiResult<LessonListResponse> apiResult = await repository.getStudentLessons(userId);
    apiResult.when(
      success: (LessonListResponse data) => emit(ResultState.data(data: data)),
      failure: (NetworkExceptions error) => emit(ResultState.error(error: error)),
    );
  }

}