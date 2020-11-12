import 'package:base_lib/widget/paging_list.dart';
import 'package:flutter/material.dart';
import '../widget/BasePage.dart';

///具有分页功能的ChangeNotifier
///author:liuhc

abstract class PagingListChangeNotifier<LIST_ITEM> extends ChangeNotifier {
  //当前列表状态
  ListState listState = ListState.LOADING;

  @protected
  int firstPageIndex;

  //当前列表的数据
  @protected
  BasePage<LIST_ITEM> basePage;

  List<LIST_ITEM> get dataList => basePage?.dataList;

  PagingListChangeNotifier({int firstPageIndex = 1}) : this.firstPageIndex = firstPageIndex;

  ///在子类实现该方法的时候要改变listState的状态,否则即使有数据页面也不会显示数据
  Future requestData(
    BuildContext context, {
    @required int pageIndex,
    @required bool reset,
  });

  bool hasNext() => basePage.hasNext;

  void loadMore(BuildContext context) async {
    try {
      await requestData(context, pageIndex: basePage.page + 1, reset: false);
    } catch (e) {
      listState = ListState.ERROR;
      notifyListeners();
    }
  }

  void onRefresh(BuildContext context) async {
    try {
      await requestData(context, pageIndex: firstPageIndex, reset: true);
    } catch (e) {
      listState = ListState.ERROR;
      notifyListeners();
    }
  }

  void onRetry(BuildContext context) => onRefresh;
}
