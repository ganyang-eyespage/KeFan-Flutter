
import 'package:dio/dio.dart';
import 'package:kefan_flutter/data/model/rank_model.dart';
import 'package:kefan_flutter/data/model/user_model.dart';
import 'package:kefan_flutter/net/index.dart';
import 'package:kefan_flutter/utils/logger.dart';
import 'apis.dart';

ApiService _apiService = new ApiService();

ApiService get apiService => _apiService;

class ApiService {

  /// 登录
  void login(Function callback, Function errorCallback, String _username,
      String _password) async {
    FormData formData =
    new FormData.fromMap({"username": _username, "password": _password});
    dio.post(Apis.USER_LOGIN, data: formData).then((response) {
      callback(UserModel.fromJson(response.data), response);
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取积分排行榜列表
  void getRankList(Function callback, Function errorCallback, int _page) async {
    dio.get(Apis.RANK_LIST + "/$_page/json").then((response) {
      callback(RankModel.fromJson(response.data));
    }).catchError((e) {
      OLogger.wtf('getRankList');
      OLogger.wtf(e);
      errorCallback(e);
    });
  }

}
