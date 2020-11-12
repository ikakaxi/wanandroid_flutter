import 'package:base_lib/export.dart';
import 'package:base_lib/widget/BasePage.dart';
import 'package:flutter/widgets.dart';
import 'package:wanandroid_flutter/bean/HomeArticleBean.dart';
import 'package:wanandroid_flutter/network/ApiService.dart';

class HomeChangeNotifier extends PagingListChangeNotifier<Datas> {
  @override
  Future requestData(BuildContext context, {int pageIndex, bool reset}) async {
    try {
      HomeArticleBeanList result = await ApiService.requestHomeArticle(context, pageIndex);
      basePage = basePage ?? BasePage();
      basePage
        ..page = result.data.curPage
        ..hasNext = result.data.total > result.data.size
        ..dataList.addAll(result.data.datas);
      if (basePage.dataList?.isEmpty == true) {
        listState = ListState.EMPTY;
      } else {
        listState = ListState.CONTENT;
      }
      notifyListeners();
    } catch (e) {
      listState = ListState.ERROR;
      notifyListeners();
    }
  }
}
