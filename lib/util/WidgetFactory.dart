import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:wanandroid_flutter/constant/AppColor.dart';

///创建一些公共widget的类
class WidgetFactory {
  WidgetFactory._();

  static void showSnackBar(BuildContext context, String msg, {int delaySecond: 10}) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      duration: Duration(seconds: delaySecond),
      content: Text(msg),
      action: SnackBarAction(
        label: "关闭",
        onPressed: () {},
      ),
    ));
  }

  static AppBar getAppBar({
    String title,
    Widget titleWidget,
    List<Widget> actions,
    PreferredSizeWidget bottom,
    bool showBackIcon = true,
  }) {
    if (title == null && titleWidget == null) {
      throw "title和titleWidget必须有一个不为空";
    }
    return AppBar(
      brightness: Brightness.light,
      leading: Offstage(
        offstage: !showBackIcon,
        child: BackButton(
          color: AppColor.APPBAR_ICON_TIP,
        ),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      title: titleWidget ?? Text(title, style: TextStyle(color: Colors.black)),
      actions: actions,
      bottom: bottom,
    );
  }

  static void showToast(BuildContext context, String msg) {
    Toast.show(msg ?? "未知错误", context);
  }

  static Widget getLoadingCircle() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Widget getListDivider() {
    return Divider(
      color: AppColor.SEPARATOR_LINE,
      height: 1,
    );
  }

  static Widget getRightArrowIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: AppColor.ARROW_RIGHT,
    );
  }
}
