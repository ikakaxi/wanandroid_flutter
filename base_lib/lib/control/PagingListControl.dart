import 'package:get/get.dart';
import 'package:base_lib/widget/paging_list.dart';
import 'package:flutter/material.dart';
import '../widget/PagingData.dart';

abstract class PagingListControl<LIST_ITEM> extends GetxController {
  @protected
  final int firstPageIndex;

  @protected
  int pageIndex;

  //当前列表状态
  ListState listState = ListState.LOADING;

  //当前列表的数据
  @protected
  PagingData<LIST_ITEM> pagingData;

  List<LIST_ITEM> get dataList => pagingData?.dataList ?? [];

  PagingListControl({int firstPageIndex = 1})
      : this.firstPageIndex = firstPageIndex,
        this.pageIndex = firstPageIndex;

  Future<PagingData<LIST_ITEM>> loadPagingData(BuildContext context, {
    @required int pageIndex,
    @required bool reset,
  });

  bool hasNext() => pagingData?.hasNext ?? false;

  ///在进入页面后调用此方法获取第一页数据
  void loadFirstPage(BuildContext context) async {
    try {
      pagingData = await loadPagingData(context, pageIndex: firstPageIndex, reset: true);
      if (pagingData?.dataList?.isEmpty == true) {
        listState = ListState.EMPTY;
      } else {
        listState = ListState.CONTENT;
      }
      update();
    } catch (e) {
      if (listState != ListState.CONTENT) {
        listState = ListState.ERROR;
        pagingData?.reset();
        update();
      }
    }
  }

  ///上拉加载
  Future loadMore(BuildContext context) async {
    try {
      pagingData = await loadPagingData(context, pageIndex: ++pageIndex, reset: false);
      update();
    } catch (e) {
      --pageIndex;
      if (listState != ListState.CONTENT) {
        listState = ListState.ERROR;
        pagingData?.reset();
        update();
      }
    }
  }

  ///下拉刷新
  Future onRefresh(BuildContext context) async {
    try {
      pagingData?.reset();
      pageIndex = firstPageIndex;
      pagingData = await loadPagingData(context, pageIndex: firstPageIndex, reset: true);
      if (pagingData?.dataList?.isEmpty == true) {
        listState = ListState.EMPTY;
      } else {
        listState = ListState.CONTENT;
      }
      update();
    } catch (e) {
      if (listState != ListState.CONTENT) {
        listState = ListState.ERROR;
        pagingData?.reset();
        update();
      }
    }
  }

  ///点击重试按钮调用此方法
  Future onRetry(BuildContext context) async => onRefresh;
}