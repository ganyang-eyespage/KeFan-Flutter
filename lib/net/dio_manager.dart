import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:kefan_flutter/data/api/apis.dart';

import 'interceptors/log_interceptor.dart';
import 'interceptors/error_interceptor.dart';

Dio _dio = Dio(); /// 使用默认配置

Dio get dio => _dio;

/// dio 配置
class DioManager {
  static Future init() async {
    dio.options.baseUrl = Apis.BASE_HOST;
    Map<String, dynamic> headers = {
      "Connection": 'keep-alive',
      "Accept": 'application/json, text/plain,',
    };
    dio.options.connectTimeout = 30 * 1000;
    dio.options.sendTimeout = 30 * 1000;
    dio.options.receiveTimeout = 30 * 1000;
    dio.options.headers = headers;
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };

    // TODO 网络环境监听
    dio.interceptors.add(LogInterceptors());
    dio.interceptors.add(ErrorInterceptor());
  }

  /// 执行 get 请求
  // static doGet(
  //     String url, {
  //       queryParameters,
  //       options,
  //       Function success,
  //       Function fail,
  //     }) async {
  //   print('http request url: $url');
  //   try {
  //     Response response = dio.get(
  //       url,
  //       queryParameters: queryParameters,
  //       options: _options,
  //     );
  //     success(response);
  //     print('http response: $response');
  //   } catch (exception) {
  //     fail(exception);
  //     print('http request fail: $url --- $exception');
  //   }
  // }


  static String handleError(error, {String defaultErrorStr = '未知错误~'}) { // 定义一个命名参数的方法
    String errStr;
    // if (error is DioError) {
    //   if (error.type == DioErrorType.CONNECT_TIMEOUT) {
    //     errStr = '连接超时~';
    //   } else if (error.type == DioErrorType.SEND_TIMEOUT) {
    //     errStr = '请求超时~';
    //   } else if (error.type == DioErrorType.RECEIVE_TIMEOUT) {
    //     errStr = '响应超时~';
    //   } else if (error.type == DioErrorType.CANCEL) {
    //     errStr = '请求取消~';
    //   } else if (error.type == DioErrorType.RESPONSE) {
    //     int statusCode = error.response.statusCode;
    //     String msg = error.response.statusMessage;
    //
    //     /// TODO 异常状态码的处理
    //     switch (statusCode) {
    //       case 500:
    //         errStr = '服务器异常~';
    //         break;
    //       case 404:
    //         errStr = '未找到资源~';
    //         break;
    //       default:
    //         errStr = '$msg[$statusCode]';
    //         break;
    //     }
    //   } else if (error.type == DioErrorType.DEFAULT) {
    //     errStr = '${error.message}';
    //     if (error.error is SocketException) {
    //       errStr = '网络连接超时~';
    //     }
    //   } else {
    //     errStr = '未知错误~';
    //   }
    // }
    return errStr ?? defaultErrorStr;
  }
}
