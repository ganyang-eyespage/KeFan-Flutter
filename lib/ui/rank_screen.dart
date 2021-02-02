import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kefan_flutter/common/common.dart';
import 'package:kefan_flutter/data/api/apis_service.dart';
import 'package:kefan_flutter/data/model/rank_model.dart';
import 'package:kefan_flutter/ui/base_widget.dart';
import 'package:kefan_flutter/ui/qr_scan_screen.dart';
import 'package:kefan_flutter/utils/page_jump_util.dart';
import 'package:kefan_flutter/utils/toast_util.dart';
import 'package:kefan_flutter/widgets/refresh_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 积分排行榜页面
class RankScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new RankScreenState();
  }
}

class RankScreenState extends BaseWidgetState<RankScreen> {
  /// listview 控制器
  ScrollController _scrollController = new ScrollController();

  /// 页码，从1开始
  int _page = 1;

  List<RankBean> _rankList = new List();

  RefreshController _refreshController =
  new RefreshController(initialRefresh: false);

  /// 获取积分排行榜列表
  Future getRankList() async {
    _page = 1;
    apiService.getRankList((RankModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          showContent();
          _refreshController.refreshCompleted(resetFooterState: true);
          setState(() {
            _rankList.clear();
            _rankList.addAll(model.data.datas);
          });
        } else {
          showEmpty();
        }
      } else {
        showError();
        T.show(msg: model.errorMsg);
      }
    }, (DioError error) {
      showError();
    }, _page);
  }

  /// 获取更多积分排行榜列表
  Future getMoreRankList() async {
    _page++;
    apiService.getRankList((RankModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          _refreshController.loadComplete();
          setState(() {
            _rankList.addAll(model.data.datas);
          });
        } else {
          _refreshController.loadNoData();
        }
      } else {
        _refreshController.loadFailed();
        T.show(msg: model.errorMsg);
      }
    }, (DioError error) {
      _refreshController.loadFailed();
    }, _page);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    showLoading().then((value) {
      getRankList();
    });
  }

  @override
  AppBar attachAppBar() {
    return AppBar(
      title: Text("积分排行榜"),
      elevation: 0,
    );
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: RefreshFooter(),
        controller: _refreshController,
        onRefresh: getRankList,
        onLoading: getMoreRankList,
        child: ListView.builder(
          itemBuilder: itemView,
          physics: new AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _rankList.length,
        ),
      ),
    );
  }

  Widget itemView(BuildContext context, int index) {
    RankBean item = _rankList[index];
    return Column(
      children: <Widget>[

        InkWell(child: Container(
          padding: EdgeInsets.fromLTRB(0, 16, 16, 16),
          child: Row(
            children: <Widget>[
              Container(
                width: 60,
                alignment: Alignment.center,
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                ),
              ),
              Expanded(
                child: Text(item.username, style: TextStyle(fontSize: 16.0)),
              ),
              Text(
                item.coinCount.toString(),
                style: TextStyle(fontSize: 14.0, color: Colors.cyan),
              )
            ],
          ),
        ),
        onTap: (){
          // T.show(msg: "${index}");
          // PageJumpUtil.jumpPushNamed(context, ORouter.webview_page, {
          //   Constants.WEBVIEW_URL: Apis.TEST_URL,
          //   Constants.WEBVIEW_TITLE: "Terms and Conditions"
          // });
          _goToScanQr();
        }
        ),
        Divider(height: 1.0)
      ],
    );
  }

  ///扫描二维码页 TODO: TUCAI
  void _goToScanQr() async {
    Future.delayed(Duration(milliseconds: 100)).then((e) async {
      if (await Permission.camera.request().isGranted) {
        String qrResult =
        await PageJumpUtil.jumpPushReturn(context, QRScanPage()) as String;
        setState(() {
          if (qrResult != null && qrResult.length > 0) {
            T.show(msg: qrResult);
          }
        });
      }
    });
  }


  @override
  void onClickErrorWidget() {
    showLoading().then((value) {
      getRankList();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
