import 'package:dio/dio.dart';
import 'package:interceptor_test/applicaton/constants/http_backpoints.dart';
import 'package:interceptor_test/applicaton/repository/middleware.dart';

class ApiRepository {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HttpBackpoints.baseUrl,
      contentType: "application/json",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    )
  );

  ApiRepository() {
    dio.interceptors.add(Middleware(dio: dio));
  }
}