import 'package:base_lib/widget/paging_list.dart';
import 'package:flutter/material.dart';
import '../widget/PagingData.dart';

///具有分页功能的ChangeNotifier
///author:liuhc

abstract class PagingListChangeNotifier<LIST_ITEM> extends ChangeNotifier {
  //当前列表状态
  ListState listState = ListState.LOADING;

  @protected
  int firstPageIndex;

  //当前列表的数据
  @protected
  PagingData<LIST_ITEM> pagingData;

  List<LIST_ITEM> get dataList => pagingData?.dataList;

  PagingListChangeNotifier({int firstPageIndex = 1}) : this.firstPageIndex = firstPageIndex;

  Future<PagingData<LIST_ITEM>> loadPagingData(
    BuildContext context, {
    @required int pageIndex,
    @required bool reset,
  });

  bool hasNext() => pagingData.hasNext;

  ///在进入页面后调用此方法获取第一页数据
  void loadFirstPage(BuildContext context) async {
    try {
      pagingData = await loadPagingData(context, pageIndex: firstPageIndex, reset: true);
      if (pagingData.dataList?.isEmpty == true) {
        listState = ListState.EMPTY;
      } else {
        listState = ListState.CONTENT;
      }
      notifyListeners();
    } catch (e) {
      if (listState != ListState.CONTENT) {
        listState = ListState.ERROR;
        pagingData?.reset();
        notifyListeners();
      }
    }
  }

  ///上拉加载
  void loadMore(BuildContext context) async {
    try {
      pagingData = await loadPagingData(context, pageIndex: pagingData.page + 1, reset: false);
      notifyListeners();
    } catch (e) {
      if (listState != ListState.CONTENT) {
        listState = ListState.ERROR;
        pagingData?.reset();
        notifyListeners();
      }
    }
  }

  ///上拉刷新
  void onRefresh(BuildContext context) async {
    try {
      pagingData = await loadPagingData(context, pageIndex: firstPageIndex, reset: true);
      if (pagingData.dataList?.isEmpty == true) {
        listState = ListState.EMPTY;
      } else {
        listState = ListState.CONTENT;
      }
      notifyListeners();
    } catch (e) {
      if (listState != ListState.CONTENT) {
        listState = ListState.ERROR;
        pagingData?.reset();
        notifyListeners();
      }
    }
  }

  ///点击重试按钮调用此方法
  void onRetry(BuildContext context) => onRefresh;
}
