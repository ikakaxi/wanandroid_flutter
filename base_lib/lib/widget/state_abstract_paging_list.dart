import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/PagingListChangeNotifier.dart';
import 'multi_state_list.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, int index, T data);

///继承该类的Widget就有了上拉加载下拉刷新的功能
class PagingListWidget<LIST_ITEM, C extends PagingListChangeNotifier<LIST_ITEM>> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Consumer<C>(
      builder: (BuildContext context, C value, Widget child) {
        return MultiStateList(
          context: context,
          listState: value.listState,
          retry: value.onRetry,
          onRefresh: _refreshEnable
              ? () async {
                  value.onRefresh(context);
                }
              : null,
          loadMore: _loadMoreEnable
              ? () async {
                  value.loadMore(context);
                }
              : null,
          listView: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _createItem(context, index, value.basePage.dataList[index]),
              childCount: value.basePage?.dataList?.length ?? 0,
            ),
          ),
        );
      },
    );
  }
}
