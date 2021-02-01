import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///页面跳转管理Utils
class PageJumpUtil {
  static void jumpPush(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) {
          return widget;
        },
      ),
    );
  }

  static Future jumpPushReturn(BuildContext context, Widget widget) async {
    var result = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) {
          return widget;
        },
      ),
    );
    return result;
  }

  static void jumpPushNamed(BuildContext context, String pagePath,
      [Object arguments]) {
    Navigator.pushNamed(context, pagePath, arguments: arguments);
  }

  static void pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  static void pushNamedAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
        context, routeName, (route) => route == null);
  }

  static void pushAndRemoveUntil(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(
        builder: (context) {
          return widget;
        },
      ),
      (route) => route == null,
    );
  }
}
