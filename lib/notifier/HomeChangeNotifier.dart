import 'package:base_lib/export.dart';
import 'package:base_lib/widget/BasePage.dart';
import 'package:flutter/widgets.dart';
import 'package:wanandroid_flutter/bean/HomeArticleBean.dart';
import 'package:wanandroid_flutter/network/ApiService.dart';

class HomeChangeNotifier extends PagingListChangeNotifier<Datas> {
  @override
  Future refreshData(BuildContext context, {int pageIndex, bool reset}) async {
    HomeArticleBeanList result = await ApiService.requestHomeArticle(context, pageIndex);
    basePage = basePage ?? BasePage();
    basePage
      ..page = 1
      ..pages = 1
      ..dataList = result.data.datas;
  }
}
