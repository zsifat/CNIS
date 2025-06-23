import 'package:chapainawabganjcity/core/shared_prefs_service/shared_pref_keys.dart';
import 'package:chapainawabganjcity/feature/login/presentation/presentation/view/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class ApiClient {
  static final ApiClient instance = ApiClient._internal();
  late Dio _dio;

  factory ApiClient() {
    return instance;
  }

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
        followRedirects: true, // Enable following redirects
        maxRedirects: 5, // Maximum number of redirects to follow
        validateStatus: (status) {
          return status! < 500; // Accept all status codes below 500
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(SharedPrefKeys.authToken);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
    // Add Pretty Dio Logger
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future<Response> post(String endpoint,
      {Map<String, dynamic>? queryParameters, Object? data}) async {
    try {
      return await _dio.post(endpoint, queryParameters: queryParameters, data: data);
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}
