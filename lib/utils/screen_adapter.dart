import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

/// 屏幕工具类
class ScreenAdapter {

  static height(double value) {
    return ScreenUtil().setHeight(value);
  }

  static width(double value) {
    return ScreenUtil().setWidth(value);
  }

  static size(double value) {
    if (Platform.isAndroid) {
      return value;
    }
    return ScreenUtil().setWidth(2 * value);
  }

  static getScreenHeight() {
    return ScreenUtil().screenHeight;
  }

  static getScreenWidth() {
    return ScreenUtil().screenWidth;
  }

  static fontSize(double fontSize) {
    if (Platform.isAndroid) {
      return fontSize;
    }
    return ScreenUtil().setSp(2 * fontSize);
  }
}
