import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:interceptor_test/applicaton/constants/http_backpoints.dart';
import 'package:interceptor_test/applicaton/repository/api_repository.dart';
import 'package:interceptor_test/model/user.dart';

class UserService {
  ApiRepository _api;

  UserService({required ApiRepository apiRepository}) : _api = apiRepository;

  Future<User?> getUserData() async {
    Response response;
    try {
      response = await _api.dio.get(HttpBackpoints.userUrl);
      return User.fromJson(json.decode(response.data));
    } catch (e) {
      return null;
    }
  }

  Future<bool> logout() async {
    return true;
  }
}
