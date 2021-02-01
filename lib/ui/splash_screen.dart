import 'package:flutter/material.dart';
import 'package:kefan_flutter/router/router.dart';
import 'package:kefan_flutter/utils/page_jump_util.dart';
import 'package:kefan_flutter/utils/utils.dart';


/**
 * 启动页面
 */
/// 启动页面
class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  /// 异步初始化
  void _initAsync() async {
    Future.delayed(Duration(seconds: 2), () {
      PageJumpUtil.pushReplacementNamed(context, ORouter.login_page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Stack(
        children: <Widget>[
          Container( // 欢迎页面
            color: Theme.of(context).primaryColor,
            // ThemeUtils.dark ? Color(0xFF212A2F) : Colors.grey[200],
            alignment: Alignment.center,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(48.0))),
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).primaryColor,
                    margin: EdgeInsets.all(2.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(46.0))),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage(Utils.getImgPath('logo')),
                      radius: 46.0,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
