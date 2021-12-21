
import 'package:education_systems_mobile/core/bloc/base_repository.dart';
import 'package:education_systems_mobile/core/http/api_provider.dart';
import 'package:education_systems_mobile/core/http/api_response.dart';
import 'package:education_systems_mobile/core/http/api_result.dart';
import 'package:education_systems_mobile/core/http/network_exceptions.dart';
import 'package:education_systems_mobile/data/auth/local_address_request.dart';
import 'package:education_systems_mobile/data/lesson/lesson_list_response.dart';
import 'package:education_systems_mobile/data/lesson/section_request.dart';
import 'package:education_systems_mobile/data/lesson/student_attendance_list_response.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class ProfessorRepository implements BaseRepository {
  ProfessorRepository({@required this.apiProvider});

  final ApiProvider apiProvider;
  final DateFormat formatter = DateFormat("yyyy-MM-dd", "tr");

  Future<ApiResult<LessonListResponse>> getProfessorLessons(int userId) async {
    try {
      final response = await apiProvider.post(
          "Lessons/get_proffesor_lessons", data: userId);
      LessonListResponse apiResponse = LessonListResponse.fromJson(response);
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

  Future<ApiResult<LessonListResponse>> getProffesorLessonsSections(SectionRequest request) async {
    try {
      final response = await apiProvider.post(
          "Lessons/get_proffesor_lesson_sections", data: request.toJson());
      LessonListResponse apiResponse = LessonListResponse.fromJson(response);
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

  Future<ApiResult<StudentAttendanceListResponse>> getLessonsAttendance(int lessonId) async {
    try {
      final response = await apiProvider.post(
          "Lessons/get_lessons_attendance", data: lessonId);
      StudentAttendanceListResponse apiResponse = StudentAttendanceListResponse.fromJson(response);
      if (apiResponse.studentAttendances != null) {
        return ApiResult.success(data: apiResponse);
      }
      else
        return ApiResult.failure(error: NetworkExceptions.defaultError(
            "An unexpected error has occurred."));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<bool>> startLesson(int lessonId) async {
    try {
      final response = await apiProvider.post(
          "Lessons/start_lesson", data: lessonId);
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

  Future<ApiResult<bool>> finishLesson(int lessonId) async {
    try {
      final response = await apiProvider.post(
          "Lessons/finish_lesson", data: lessonId);
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

  Future<ApiResult<bool>> updateLocalAddress(LocalAddressRequest request) async {
    try {
      final response = await apiProvider.post("Users/update_local_address", data: request.toJson());
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
}