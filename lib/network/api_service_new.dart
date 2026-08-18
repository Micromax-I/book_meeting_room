import 'dart:developer';

import 'package:dio/dio.dart';

class ApiServiceNew {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.111.225.52/meeting/api',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'servicename': 'bookingmeetingroom',
        'x-api-key': 'CZWxh+4mXI4RCNIVStNZx/un+ykwnJqDph5EBCECnww=',
      },
    ),
  );

  // Generic GET method
  static Future<T?> get<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(endpoint);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = response.data;
        return fromJson(jsonData);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // log('GET Error: ${e.message}');
      throw Exception(e.message ?? 'Unknown error');
    } catch (e) {
      // log('Generic GET Error: $e');
      throw Exception(e.toString());
    }
    return null;
  }

  // Generic POST method
  static Future<T?> post<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = response.data;
        log('POST : ${jsonData}');
        return fromJson(jsonData);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // log('POST Error: ${e.message}');
      throw Exception('${e.message} ?? Unknown error');
    } catch (e) {
      // log('Generic POST Error: $e');
      throw Exception(e.toString());
    }
  }
}
