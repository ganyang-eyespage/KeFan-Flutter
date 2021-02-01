import 'package:flutter/services.dart';

/*
* 与Native 交互的管理类
* **/
class MethodChannelManager {

  static final String APP_INFO = "com.tc.kefan/appInfo";

  static var appInfoChannel = MethodChannel(APP_INFO);

  static void registerMethodChannel() {
    appInfoChannel.setMethodCallHandler((call) async {});
  }

  /*
  * Java 层获取 APP相关信息
  * **/
  static Future<dynamic> getAppInfo() async {
    var responseBody;
    try {
      responseBody = appInfoChannel.invokeMethod("getAppInfo");
      return responseBody;
    } on PlatformException catch (e) {}
  }

  /*
  * Java 层获取 getAdvertisingId
  * **/
  static Future<String> getAdvertisingId() async {
    final String id = await appInfoChannel.invokeMethod('getAdvertisingId');
    return id;
  }
}
