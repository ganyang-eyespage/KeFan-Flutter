
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kefan_flutter/common/method_channel_manager.dart';
import 'package:kefan_flutter/res/colors.dart';
import 'package:kefan_flutter/router/router.dart';
import 'package:kefan_flutter/ui/splash_screen.dart';
import 'package:kefan_flutter/utils/logger.dart';

import 'common/common.dart';
import 'net/dio_manager.dart';


void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，
    // 是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BuildContext context;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  void _initAsync() async {
    await DioManager.init();
    getAppInfo();
    getAppGaid();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new MaterialApp(
      title: AppConfig.appName,
      theme: ThemeData(
          primaryColor: Colours.app_main,
          backgroundColor: Colors.white,
          canvasColor: Colors.white),
      debugShowCheckedModeBanner: false,
      //去掉右上角的debug
      onGenerateRoute: ORouter.generateRoute,
      home: SplashScreen(),
    );
  }

  Future<void> getAppInfo() async {
    var info = await MethodChannelManager.getAppInfo();
    OLogger.i("------getAppInfo:" + info.toString());
  }

  Future<void> getAppGaid() async {
    var gaid = await MethodChannelManager.getAdvertisingId();
    OLogger.i("------getAppGaid:" +gaid);
  }
}
