
import 'package:education_systems_mobile/core/bloc/base_repository.dart';
import 'package:education_systems_mobile/core/http/api_provider.dart';
import 'package:education_systems_mobile/core/http/api_response.dart';
import 'package:education_systems_mobile/core/http/api_result.dart';
import 'package:education_systems_mobile/core/http/network_exceptions.dart';
import 'package:education_systems_mobile/data/lesson/lesson_list_response.dart' as lesson_res;
import 'package:education_systems_mobile/data/lesson/lesson_sections_response.dart';
import 'package:education_systems_mobile/data/lesson/section_request.dart';
import 'package:education_systems_mobile/data/lesson/user_lesson_map_request.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class StudentRepository implements BaseRepository {
  StudentRepository({@required this.apiProvider});

  final ApiProvider apiProvider;
  final DateFormat formatter = DateFormat("yyyy-MM-dd", "tr");

  Future<ApiResult<lesson_res.LessonListResponse>> getStudentLessons(int userId) async {

    try {
      final response = await apiProvider.post("Lessons/get_student_lessons",data: userId);
      lesson_res.LessonListResponse apiResponse = lesson_res.LessonListResponse.fromJson(response);
      if (apiResponse.lessons != null){
        return ApiResult.success(data: apiResponse);
      }
      else
        return ApiResult.failure(error: NetworkExceptions.defaultError("An unexpected error has occurred."));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
  Future<ApiResult<LessonSectionsListResponse>> getLessonsSections(SectionRequest request) async {
    try {
      final response = await apiProvider.post(
          "Lessons/get_lessons_sections", data: request.toJson());
      LessonSectionsListResponse apiResponse = LessonSectionsListResponse.fromJson(response);
      if (apiResponse.lessons != null) {
        return ApiResult.success(data: apiResponse);
      }
      else
        return ApiResult.failure(error: NetworkExceptions.defaultError(
            "An unexpected error has occurred."));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<bool>> updateStudentAttendance(UserLessonMapRequest request) async {
    try {
      final response = await apiProvider.post(
          "Lessons/update_attendance", data: request.toJson());
      if (response != false) {
        return ApiResult.success(data: true);
      }
      else
        return ApiResult.failure(error: NetworkExceptions.defaultError(
            "An unexpected error has occurred."));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<lesson_res.Lesson>> getLessonById(int lessonId) async {
    try {
      final response = await apiProvider.post(
          "Lessons/get_lesson_by_id", data: lessonId);
      lesson_res.Lesson apiResponse = lesson_res.Lesson.fromJson(response);
      if (apiResponse != null) {
        return ApiResult.success(data: apiResponse);
      }
      else
        return ApiResult.failure(error: NetworkExceptions.defaultError(
            "An unexpected error has occurred."));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}