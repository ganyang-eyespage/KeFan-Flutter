
import 'package:dio/dio.dart';
import 'package:kefan_flutter/common/common.dart';
import 'package:kefan_flutter/common/user.dart';
import 'package:kefan_flutter/data/api/apis_service.dart';
import 'package:flutter/material.dart';
import 'package:kefan_flutter/data/model/user_model.dart';
import 'package:kefan_flutter/router/router.dart';
import 'package:kefan_flutter/utils/page_jump_util.dart';
import 'package:kefan_flutter/utils/toast_util.dart';
import 'package:kefan_flutter/widgets/loading_dialog.dart';

/// 登录页面
class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _psdController = TextEditingController();

  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _psdFocusNode = FocusNode();

  Future _login(String username, String password) async {

    //TODO: TUCAI  临时不校验账户密码
    _showLoading(context);
    Future.delayed(Duration(seconds: 2), () {
      T.show(msg: "登录成功");
      PageJumpUtil.pushReplacementNamed(context, ORouter.rank_page);
    });


    return;

    if ((null != username && username.length > 0) &&
        (null != password && password.length > 0)) {
      _showLoading(context);
      apiService.login((UserModel model, Response response) {
        _dismissLoading(context);
        if (null != model) {
          if (model.errorCode == Constants.STATUS_SUCCESS) {
            User().saveUserInfo(model, response);
            T.show(msg: "登录成功");
            Navigator.of(context).pop();
          } else {
            T.show(msg: model.errorMsg);
          }
        }
      }, (DioError error) {
        _dismissLoading(context);
        print(error.response);
      }, username, password);
    } else {
      T.show(msg: "用户名或密码不能为空");
    }
  }

  @override
  void initState() {
    // Configure keyboard actions
    // FormKeyboardActions.setKeyboardActions(context, _buildConfig(context));
    super.initState();
  }

  /// 显示Loading
  _showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return new LoadingDialog(
            outsideDismiss: false,
            loadingText: "正在登陆...",
          );
        });
  }

  /// 隐藏Loading
  _dismissLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0.4,
            title: Text("登录"),
          ),
          body: Container(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "用户登录",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "请使用账号登录",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                      child: TextField(
                        focusNode: _userNameFocusNode,
                        autofocus: false,
                        controller: _userNameController,
                        decoration: InputDecoration(
                          labelText: "用户名",
                          hintText: "请输入用户名",
                          labelStyle: TextStyle(color: Colors.cyan),
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                      child: TextField(
                        focusNode: _psdFocusNode,
                        controller: _psdController,
                        decoration: InputDecoration(
                          labelText: "密码",
                          labelStyle: TextStyle(color: Colors.cyan),
                          hintText: "请输入密码",
                        ),
                        obscureText: true,
                        maxLines: 1,
                      ),
                    ),

                    // 登录按钮
                    Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              padding: EdgeInsets.all(16.0),
                              elevation: 0.5,
                              child: Text("登录"),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: () {
                                String username = _userNameController.text;
                                String password = _psdController.text;
                                _login(username, password);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
