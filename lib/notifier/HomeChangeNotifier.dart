import 'package:base_lib/export.dart';
import 'package:base_lib/widget/PagingData.dart';
import 'package:flutter/widgets.dart';
import 'package:wanandroid_flutter/bean/HomeArticleBean.dart';
import 'package:wanandroid_flutter/network/ApiService.dart';

class HomeChangeNotifier extends PagingListChangeNotifier<Datas> {
  @override
  Future<PagingData<Datas>> loadPagingData(BuildContext context, {int pageIndex, bool reset}) async {
    HomeArticleBeanList result = await ApiService.requestHomeArticle(context, pageIndex);
    pagingData = pagingData ?? PagingData<Datas>();
    pagingData
      ..page = result.data.curPage
      ..hasNext = result.data.total > result.data.size
      ..dataList.addAll(result.data.datas);
    return pagingData;
  }
}
