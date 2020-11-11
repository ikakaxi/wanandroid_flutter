import 'package:base_lib/widget/multi_state_list.dart';
import 'package:flutter/material.dart';
import '../widget/BasePage.dart';

///具有分页功能的ChangeNotifier
///author:liuhc

abstract class PagingListChangeNotifier<LIST_ITEM> extends ChangeNotifier {
  //当前列表状态
  ListState listState = ListState.SHOW_INIT;

  int firstPageIndex;

  //当前列表的数据
  BasePage<LIST_ITEM> basePage;

  PagingListChangeNotifier({int firstPageIndex = 1}) : this.firstPageIndex = firstPageIndex;

  Future refreshData(
    BuildContext context, {
    @required int pageIndex,
    @required bool reset,
  });

  bool hasNext() {
    return basePage.page >= basePage.pages;
  }

  ///调用该方法前先调用hasNext判断有没有下一页
  void loadMore(BuildContext context) async {
    assert(hasNext());
    try {
      await refreshData(context, pageIndex: basePage.page + 1, reset: false);
      listState = ListState.SHOW_LIST;
      notifyListeners();
    } catch (e) {
      listState = ListState.SHOW_ERROR;
      notifyListeners();
    }
  }

  void onRefresh(BuildContext context) async {
    try {
      await refreshData(context, pageIndex: firstPageIndex, reset: true);
      listState = ListState.SHOW_LIST;
      notifyListeners();
    } catch (e) {
      listState = ListState.SHOW_ERROR;
      notifyListeners();
    }
  }

  void onRetry(BuildContext context) => onRefresh;
}
