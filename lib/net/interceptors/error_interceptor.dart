import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kefan_flutter/utils/logger.dart';
import 'package:kefan_flutter/utils/toast_util.dart';

import '../index.dart';

/// 统一接口返回格式错误检测
class ErrorInterceptor extends InterceptorsWrapper {

  @override
  onRequest(RequestOptions options) async {
    return options;
  }

  @override
  onError(DioError error) async {
    String errorMsg = DioManager.handleError(error);
    T.show(msg: errorMsg);
    OLogger.wtf('onError');
    OLogger.wtf(error);
    return error;
  }

  @override
  onResponse(Response response) async {
    var data = response.data;
    OLogger.wtf(data);
    if (data is String) {
      data = json.decode(data);
    }
    if (data is Map) {
      int errorCode = data['errorCode'] ?? 0; // 表示如果data['errorCode']为空的话把 0赋值给errorCode
      String errorMsg = data['errorMsg'] ?? '请求失败[$errorCode]';
      if (errorCode == 0) { // 正常
        return response;
      } else if (errorCode == -1001 /*未登录错误码*/) {
        return dio.reject(errorMsg); // 完成和终止请求/响应
      } else {
        return dio.reject(errorMsg); // 完成和终止请求/响应
      }
    }

    return response;
  }

}
