import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:kefan_flutter/common/js_channel_manager.dart';
import 'package:kefan_flutter/res/colors.dart';
import 'package:kefan_flutter/res/text_style.dart';
import 'package:kefan_flutter/utils/logger.dart';
import 'package:kefan_flutter/utils/string_util.dart';

class WebViewPage extends StatefulWidget {
  String url, title;

  WebViewPage(this.url, this.title);

  @override
  State<StatefulWidget> createState() {
    return _MyWebViewUI(url, title);
  }
}

class _MyWebViewUI extends State<WebViewPage> {
  String url, title;
  double _progress = 0;
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  StreamSubscription<double> _onProgressChanged;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  JsChannelManager jsManager = JsChannelManager();
  _MyWebViewUI(this.url, this.title);
  Map<String, bool> hasAddedHeaders = Map();

  void _handleJsCallback(String callback, {String data}) {
    if (!StringUtil.isEmpty(callback)) {
      if (!StringUtil.isEmpty(data)) {
        flutterWebViewPlugin.evalJavascript("$callback('$data')");
      }else {
        flutterWebViewPlugin.evalJavascript("$callback()");
      }

    }
  }

  @override
  void initState() {
    super.initState();
    jsManager.eventHandler = (String event, {dynamic data, String callback}) {
      OLogger.d("js call flutter method: $event, data: $data, callback: $callback");
      switch (event) {
        case JsChannelEventName.buySuccess:
          break;
        case JsChannelEventName.registerSuccess:
          break;
        case JsChannelEventName.loginSuccess:
          break;
        case JsChannelEventName.getClientID:
          // var id = GlobalConstant.appInfoMap[HEADER_CLIENT_ID] as String;
          // _handleJsCallback(callback,data: id);
          break;
        case JsChannelEventName.getClientHeaders:
          // var headers = NetworkUtil.deviceHeaders();
          // var data = json.encode(headers);
          // _handleJsCallback(callback,data: data);
          break;
        case "test":
          _handleJsCallback(callback,data: data);
          break;
        default:
          break;
      }
    };

    //progress
    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          _progress = progress;
        });
      }
    });

    _onStateChanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged event) {
      OLogger.d("webview state changed: state: ${event.type}, url: ${event.url}");
      switch (event.type) {
        case WebViewState.shouldStart:
          break;
        case WebViewState.startLoad:
          // if (!hasAddedHeaders.containsKey(event.url)) {
          //   OLogger.d("has not add headers");
          //   flutterWebViewPlugin.stopLoading();
          //   hasAddedHeaders[event.url] = true;
          //   flutterWebViewPlugin.reloadUrl(event.url, headers: NetworkUtil.deviceHeaders());
          //   return;
          // }
          // OLogger.d("has add headers： ${NetworkUtil.deviceHeaders()}");
          break;
        case WebViewState.finishLoad:
          // var map = {"method": "test", "data": "123", "callback": "alert"};
          // var str = json.encode(map);
          // Future.delayed(Duration(seconds: 2),() {
          //   flutterWebViewPlugin.evalJavascript("OconnectionChannel.postMessage('$str');");
          // });
          break;
        default:
          break;
      }
    });

    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      OLogger.d("webview url changed: $url");
    });
  }

  @override
  void dispose() {
    _onProgressChanged.cancel();
    _onStateChanged.cancel();
    _onUrlChanged.cancel();
    flutterWebViewPlugin.dispose();

    super.dispose();
  }
  String clientId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(title, style: TS.ts_black_18),
          backgroundColor: Colours.transparent_80,
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                  child: _progress < 1.0
                      ? LinearProgressIndicator(
                          backgroundColor: Colors.white, value: _progress)
                      : Container()),
              Expanded(
                child: WebviewScaffold(
                  url: url,
                  withJavascript: true,
                  // userAgent: GlobalConstant.getOUserAgent(context),
                  // headers: NetworkUtil.deviceHeaders(),
                  withLocalStorage: true,
                  withZoom: true,
                  hidden: true,
                  javascriptChannels: {jsManager.channel},
                ),
              )
            ],
          ),
        ));
  }
}
