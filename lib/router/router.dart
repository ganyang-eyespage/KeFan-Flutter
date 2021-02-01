import 'package:flutter/material.dart';
import 'package:kefan_flutter/ui/login_screen.dart';
import 'package:kefan_flutter/ui/rank_screen.dart';
import 'package:kefan_flutter/utils/router_utils.dart';


class ORouter {
  // ignore: non_constant_identifier_names
  static const String login_page = "LoginPage"; // 登录页
  static const String home_page = "HomePage"; //首页
  static const String rank_page = "RankPage"; //rank页
  static const String webview_page = "WebviewPage"; // WebviewPage

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case choose_currency_page:
      //   var args = settings.arguments;
      //   return Right2LeftRouter(child: ChoseCurrencyPage(args));

      // case send_coin_page:
        // var args = settings.arguments;
        // CoinInfoEntity coin;
        // String address;
        // if (args is Map<String, dynamic>) {
        //   coin = args[send_coin];
        //   address = args[send_address];
        // } else if (args is CoinInfoEntity) {
        //   coin = args;
        // } else {
        //   assert(false, "args error");
        // }
        // return Right2LeftRouter(
        //     child: SendCoinPage(coinInfoEntity: coin, destAddress: address));

      case home_page:
        return Right2LeftRouter(child: LoginScreen());

      case login_page:
        return Bottom2TopRouter(child: LoginScreen());

      case rank_page:
        return Right2LeftRouter(child: RankScreen());

      // case webview_page:
      //   var args = settings.arguments;
      //   String url;
      //   String title;
      //   if (args is Map<String, dynamic>) {
      //     url = args[webview_url];
      //     title = args[webview_title];
      //   } else {
      //     assert(false, "args error");
      //   }
      //   return FadeRouter(child: WebViewPage(url, title));

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
