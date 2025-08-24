import 'package:dio/dio.dart';

class DioService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://your-api-url.com/",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  Dio get dio => _dio;

  // Example GET request
  Future<Response> getRequest(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Example POST request
  Future<Response> postRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
