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
  GlobalKey<EasyRefreshState> easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> footerKey = GlobalKey<RefreshFooterState>();

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
          easyRefreshKey: easyRefreshKey,
          headerKey: headerKey,
          footerKey: footerKey,
          listState: value.listState,
          retry: value.onRetry,
          onRefresh: widget._refreshEnable
              ? () async {
                  await value.onRefresh(context);
                }
              : null,
          loadMore: widget._loadMoreEnable
              ? () async {
                  await value.loadMore(context);
                }
              : null,
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return Divider(height: 0, color: Colors.grey);
            },
            itemCount: value.dataList?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
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
  final OnRefresh _onRefresh;
  final LoadMore _loadMore;

  final GlobalKey<EasyRefreshState> _easyRefreshKey;
  final GlobalKey<RefreshHeaderState> _headerKey;
  final GlobalKey<RefreshFooterState> _footerKey;

  //列表
  final Widget _child;

  //列表状态
  final ListState _listState;

  MultiStateList(
      {Key key,
      GlobalKey<EasyRefreshState> easyRefreshKey,
      GlobalKey<RefreshHeaderState> headerKey,
      GlobalKey<RefreshFooterState> footerKey,
      Widget init,
      Widget empty,
      Widget error,
      ListState listState,
      OnRefresh onRefresh,
      LoadMore loadMore,
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
        _easyRefreshKey = easyRefreshKey,
        _headerKey = headerKey,
        _footerKey = footerKey,
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
        return EasyRefresh(
          key: _easyRefreshKey,
          behavior: ScrollOverBehavior(),
          refreshHeader: ClassicsHeader(
            key: _headerKey,
            refreshText: '下拉刷新',
            refreshReadyText: '释放刷新',
            refreshingText: '正在刷新...',
            refreshedText: '刷新结束',
            moreInfo: '更新于 %T',
            bgColor: Colors.transparent,
            textColor: Colors.black87,
            moreInfoColor: Colors.black54,
            showMore: true,
          ),
          refreshFooter: ClassicsFooter(
            key: _footerKey,
            loadText: '上拉加载',
            loadReadyText: '释放加载',
            loadingText: '正在加载...',
            loadedText: '加载结束',
            noMoreText: '没有更多数据',
            moreInfo: '更新于 %T',
            bgColor: Colors.transparent,
            textColor: Colors.black87,
            moreInfoColor: Colors.black54,
            showMore: true,
          ),
          child: _child,
          onRefresh: _onRefresh,
          loadMore: _loadMore,
        );
      default:
        return null;
    }
  }
}
