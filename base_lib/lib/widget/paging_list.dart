import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';

import '../notifier/PagingListChangeNotifier.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, int index, T data);
typedef RetryLoad = void Function(BuildContext context);

///继承该类的Widget就有了上拉加载下拉刷新的功能
class PagingListWidget<LIST_ITEM, C extends PagingListChangeNotifier<LIST_ITEM>> extends StatefulWidget {
  final ItemBuilder<LIST_ITEM> _createItem;

  //是否可以下拉刷新
  final bool _refreshEnable;

  //是否可以上拉加载
  final bool _loadMoreEnable;

  PagingListWidget({
    bool refreshEnable: true,
    bool loadMoreEnable: true,
    @required ItemBuilder<LIST_ITEM> createItem,
  })  : this._createItem = createItem,
        this._refreshEnable = refreshEnable,
        this._loadMoreEnable = loadMoreEnable;

  @override
  State<StatefulWidget> createState() {
    return _PagingListWidgetState<LIST_ITEM, C>();
  }
}

class _PagingListWidgetState<LIST_ITEM, C extends PagingListChangeNotifier<LIST_ITEM>>
    extends State<PagingListWidget<LIST_ITEM, C>> {
  final EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    C consumer = context.read<C>();
    consumer.loadFirstPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<C>(
      builder: (BuildContext context, C value, Widget child) {
        return MultiStateList(
          controller: _controller,
          listState: value.listState,
          retry: value.onRetry,
          onRefresh: widget._refreshEnable
              ? () async {
                  await value.onRefresh(context);
                  _controller.resetLoadState();
                }
              : null,
          loadMore: widget._loadMoreEnable
              ? () async {
                  await value.loadMore(context);
                  _controller.finishLoad(noMore: !value.hasNext());
                }
              : null,
          child: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                Widget child = widget._createItem(context, index, value.dataList[index]);
                return Column(
                  children: [
                    Row(
                      children: [
                        Text("$index"),
                        Expanded(child: child),
                      ],
                    ),
                    Divider(height: 0, color: Colors.grey),
                  ],
                );
              },
              childCount: value.dataList?.length ?? 0,
            ),
          ),
        );
      },
    );
  }
}

enum ListState {
  //第一次显示时的loading状态
  LOADING,
  //显示内容
  CONTENT,
  //显示空数据
  EMPTY,
  //显示错误信息
  ERROR
}

/// 多状态列表，具有下拉刷新，上拉加载，无数据时显示无数据控件，发生错误时显示错误信息这4种功能
/// 临时封装了一个第三方具有下拉刷新，上拉加载功能的列表，后期替换为自定义的
class MultiStateList extends StatelessWidget {
  static const TEXT_TIP = Color(0xFF666666); //提示文字的颜色
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

  final EasyRefreshController _controller;

  //列表
  final Widget _child;

  //列表状态
  final ListState _listState;

  MultiStateList(
      {Key key,
      Widget init,
      Widget empty,
      Widget error,
      ListState listState,
      OnRefreshCallback onRefresh,
      OnLoadCallback loadMore,
      @required EasyRefreshController controller,
      @required RetryLoad retry,
      @required Widget child})
      : assert(retry != null),
        assert(child != null),
        _init = init,
        _empty = empty,
        _error = error,
        _listState = listState ?? ListState.LOADING,
        _retry = retry,
        _onRefresh = onRefresh,
        _loadMore = loadMore,
        _controller = controller,
        _child = child,
        super(key: key);

  Widget getDefaultInitView() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget getDefaultEmpty(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _retry(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image(
                image: AssetImage("assets/images/empty.png", package: "base_lib"),
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

  Widget getDefaultError(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _retry(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image(
                image: AssetImage("assets/images/error.png", package: "base_lib"),
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

  @override
  Widget build(BuildContext context) {
    switch (_listState) {
      case ListState.LOADING:
        return _init ?? getDefaultInitView();
      case ListState.EMPTY:
        return _empty ?? getDefaultEmpty(context);
      case ListState.ERROR:
        return _error ?? getDefaultError(context);
      case ListState.CONTENT:
        return EasyRefresh.custom(
          behavior: ScrollBehavior(),
          header: ClassicalHeader(),
          footer: ClassicalFooter(),
          controller: _controller,
          slivers: <Widget>[_child],
          onRefresh: _onRefresh,
          onLoad: _loadMore,
        );
      default:
        return null;
    }
  }
}
