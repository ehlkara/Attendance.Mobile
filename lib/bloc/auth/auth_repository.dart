
import 'package:education_systems_mobile/core/bloc/base_repository.dart';
import 'package:education_systems_mobile/core/http/api_provider.dart';
import 'package:education_systems_mobile/core/http/api_result.dart';
import 'package:education_systems_mobile/core/http/network_exceptions.dart';
import 'package:education_systems_mobile/data/auth/local_address_request.dart';
import 'package:education_systems_mobile/data/auth/login_request.dart';
import 'package:education_systems_mobile/data/auth/login_response.dart';
import 'package:education_systems_mobile/data/auth/user.dart';
import 'package:flutter/cupertino.dart';

class AuthRepository implements BaseRepository {
  AuthRepository({@required this.apiProvider});

  final ApiProvider apiProvider;

  Future<ApiResult<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await apiProvider.post("Users/login", data: request.toJson());
      LoginResponse apiResponse = LoginResponse.fromJson(response);
      if (apiResponse.accessToken != null)
        return ApiResult.success(data: apiResponse);
      else
        return ApiResult.failure(error: NetworkExceptions.badRequest());
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<User>> getUserById(int id) async {
    try {
      final response = await apiProvider.post("Users/get_user_by_id", data: id);
      User apiResponse = User.fromJson(response);
      if (apiResponse.username != null)
        return ApiResult.success(data: apiResponse);
      else
        return ApiResult.failure(error: NetworkExceptions.badRequest());
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

}