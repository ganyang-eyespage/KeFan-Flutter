import 'dart:convert';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class JsChannelEventName {
  static const String registerSuccess = "registerSuccess";
  static const String loginSuccess = "loginSuccess";
  static const String buySuccess = "buySuccess";
  static const String getClientID = "getClientID";
  static const String getClientHeaders = "getClientHeaders";
}

typedef void JsEventHandler(String event, {dynamic data, String callback});

class JsChannelManager {

  static String channelName = "KefanChannel";

  JavascriptChannel channel;

  JsEventHandler eventHandler;

  JsChannelManager() {
    this.channel = JavascriptChannel(
        name: JsChannelManager.channelName, onMessageReceived: _handleJsMessage);
  }

  void _handleJsMessage(JavascriptMessage message) {
    try {
      var jsMessage = json.decode(message.message) as Map<String, dynamic>;
      var method = jsMessage["method"] as String;
      var arguments = jsMessage["data"];
      var callback = jsMessage["callback"] as String;
      _handleEvent(method,arguments: arguments, callback: callback);
    }on FormatException catch (e) {
      _handleEvent(message.message);
    }
  }

  void _handleEvent(String method, {dynamic arguments, String callback}) {
    eventHandler?.call(method, data: arguments, callback: callback);
  }

}