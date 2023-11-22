import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../constant/config.dart';
import '../util/exceptions.dart';
import 'custom_interceptor.dart';

enum Method {
  get,
  post,
  put,
  patch,
  delete,
}

class ApiService {
  const ApiService._();

  static final Dio _dio = Dio()
    ..options = BaseOptions(
      baseUrl: Config.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    )
    ..interceptors.add(const CustomInterceptor());

  static Future<bool> _hasConnection() async {
    final result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) return true;
    return false;
  }

  static Future<String> request(
    String path, {
    Method method = Method.get,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
    Object? body,
    FormData? formData,
  }) async {
    if (!(await _hasConnection())) {
      throw Error.throwWithStackTrace(const ConnectionExcaption(), StackTrace.current);
    }

    final newHeaders = {
      HttpHeaders.authorizationHeader: Config.clientID,
      HttpHeaders.contentTypeHeader: formData != null ? Headers.multipartFormDataContentType : Headers.jsonContentType,
      ...?headers,
    };

    Response<Object?> response = await _dio.request<Object?>(
      path,
      data: body ?? formData,
      queryParameters: queryParameters,
      options: Options(
        method: method.name,
        headers: newHeaders,
      ),
    );

    return jsonEncode(response.data);
  }
}
