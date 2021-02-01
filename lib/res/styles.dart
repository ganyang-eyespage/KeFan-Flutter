import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kefan_flutter/res/colors.dart';

import 'dimens.dart';

class Decorations {

  static Decoration bottom = new BoxDecoration(
    border: new Border(
      bottom: BorderSide(
        width: 0.5,
        color: Colours.app_main,
      ),
    ),
  );

  static Decoration white10BoxDecoration = new BoxDecoration(
      borderRadius: BorderRadius.circular(10), color: Colors.white);

  static Decoration color0x35a5bcCircular10 = new BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.green,
  );

  //默认输入框
  static OutlineInputBorder color59739fInputBorder8 = new OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green),
      borderRadius: BorderRadius.circular(8));

}

/// 间隔
class Gaps {
  /// 水平间隔
  static Widget hGap5 = new SizedBox(width: Dimens.gap_dp5);
  static Widget hGap10 = new SizedBox(width: Dimens.gap_dp10);
  static Widget hGap15 = new SizedBox(width: Dimens.gap_dp15);

  /// 垂直间隔
  static Widget vGap5 = new SizedBox(height: Dimens.gap_dp5);
  static Widget vGap10 = new SizedBox(height: Dimens.gap_dp10);
  static Widget vGap15 = new SizedBox(height: Dimens.gap_dp15);
}
