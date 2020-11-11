import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

typedef void RetryLoad(BuildContext context);

enum ListState {
  //第一次显示时的widget
  SHOW_INIT,
  //显示列表
  SHOW_LIST,
  //显示空数据
  SHOW_EMPTY,
  //显示错误信息
  SHOW_ERROR
}

/// 多状态列表，具有下拉刷新，上拉加载，无数据时显示无数据控件，发生错误时显示错误信息这4种功能
/// 临时封装了一个第三方具有下拉刷新，上拉加载功能的列表，后期替换为自定义的
class MultiStateList extends StatefulWidget {
  //第一次显示时的widget
  final Widget _init;

  //页面无数据时显示的widget
  final Widget _empty;

  //页面发生错误时显示的widget
  final Widget _error;

  //点击无数据或者错误信息的重试按钮时回调的事件
  final RetryLoad _retry;
  final OnRefreshCallback _onRefresh;
  final OnLoadCallback _loadMore;
  final BuildContext _context;

  //列表
  final SliverList _listView;

  //列表状态
  final ListState _listState;

  MultiStateList(
      {Key key,
      Widget init,
      Widget empty,
      Widget error,
      ListState listState,
      @required RetryLoad retry,
      OnRefreshCallback onRefresh,
      OnLoadCallback loadMore,
      @required BuildContext context,
      @required SliverList listView})
      : assert(retry != null),
        assert(listView != null),
        _init = init,
        _empty = empty,
        _error = error,
        _listState = listState ?? ListState.SHOW_INIT,
        _retry = retry,
        _onRefresh = onRefresh,
        _loadMore = loadMore,
        _context = context,
        _listView = listView,
        super(key: key);

  @override
  MultiStateListState createState() => MultiStateListState();
}

class MultiStateListState extends State<MultiStateList> {

  static const TEXT_TIP = Color(0xFF666666); //提示文字的颜色

  EasyRefreshController _controller;
  Widget defaultInit;
  Widget defaultEmpty;
  Widget defaultError;

  Widget getDefaultInitView() {
    if (defaultInit == null) {
      defaultInit = Center(
        child: Container(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      );
    }
    return defaultInit;
  }

  Widget getDefaultEmpty() {
    if (defaultEmpty == null) {
      defaultEmpty = Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              widget._retry(widget._context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/images/empty.png"),
                  width: 80,
                  height: 80,
                ),
                Text("暂无数据"),
                Text(
                  "点击重试",
                  style: TextStyle(
                    color: TEXT_TIP,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return defaultEmpty;
  }

  Widget getDefaultError() {
    if (defaultError == null) {
      defaultError = Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              widget._retry(widget._context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/images/error.png"),
                  width: 100,
                  height: 80,
                ),
                Text("加载失败"),
                Text(
                  "点击重试",
                  style: TextStyle(
                    color: TEXT_TIP,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return defaultError;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget._listState) {
      case ListState.SHOW_INIT:
        return getInit();
      case ListState.SHOW_EMPTY:
        return getEmpty();
      case ListState.SHOW_ERROR:
        return getError();
      case ListState.SHOW_LIST:
        return EasyRefresh.custom(
          controller: _controller,
          behavior: ScrollBehavior(),
          header: ClassicalHeader(),
          footer: ClassicalFooter(),
          slivers: <Widget>[widget._listView],
          onRefresh: widget._onRefresh,
          onLoad: widget._loadMore,
        );
      default:
        return null;
    }
  }

  Widget getInit() => widget._init ?? getDefaultInitView();

  Widget getEmpty() => widget._empty ?? getDefaultEmpty();

  Widget getError() => widget._error ?? getDefaultError();

}
