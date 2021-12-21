import 'package:education_systems_mobile/bloc/student_home/student_repository.dart';
import 'package:education_systems_mobile/core/bloc/result_state.dart';
import 'package:education_systems_mobile/core/http/api_result.dart';
import 'package:education_systems_mobile/core/http/network_exceptions.dart';
import 'package:education_systems_mobile/data/lesson/lesson_sections_response.dart';
import 'package:education_systems_mobile/data/lesson/section_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSectionsBloc extends Cubit<ResultState<LessonSectionsListResponse>> {
  StudentSectionsBloc({this.repository})
      : assert(repository != null),
        super(Idle());
  final StudentRepository repository;

  getSections(SectionRequest sectionRequest)async{
    emit(ResultState.loading());
    ApiResult<LessonSectionsListResponse> apiResult = await repository.getLessonsSections(sectionRequest);
    apiResult.when(
      success: (LessonSectionsListResponse data) => emit(ResultState.data(data: data)),
      failure: (NetworkExceptions error) => emit(ResultState.error(error: error)),
    );
  }

}