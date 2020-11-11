import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  static const PRIMARY_COLOR = Colors.blue; //app主题颜色
  static const STEP_BORDER = Color(0xFFC6E9E1); //选中的步进边框颜色
  static const STEP_BORDER_UNSELECTED = Color(0xFFEDEDED); //未选中的步进边框颜色
  static const STEP_FILL = BUTTON_COLOR; //选中的步进颜色
  static const STEP_FILL_UNSELECTED = Color(0xFFCCCCCC); //未选中的步进颜色
  static const BUTTON_COLOR = Color(0xFF03B989); //按钮颜色
  static const BG = Color(0xFFF2F2F2); //页面背景
  static const ARROW_RIGHT = Color(0xFFC7C7CC); //右箭头颜色
  static const SEPARATOR_LINE = ARROW_RIGHT; //间隔线颜色
  static const BG_TIP = Color(0xFFEEEEEE); //描述文本的背景
  static const TEXT_TIP = Color(0xFF666666); //提示文字的颜色
  static const APPBAR_ICON_TIP = Color(0xFF444444); //appbar按钮颜色
  static const BG_TRANSPARENT_WHITE = Colors.white54; //半透明白色

  static const AREA_CAN_FLY = Color(0xFF61BA00);
  static const AREA_CUSTOM = Color(0xFF4A90E2);
  static const AREA_DANGER = Color(0xFFFF9B22);
  static const AREA_FLY = Color(0xFF55C590);
  static const AREA_LIMIT = Color(0xFFFEF145);
  static const AREA_STOP = Color(0xFFFF435A);
}
