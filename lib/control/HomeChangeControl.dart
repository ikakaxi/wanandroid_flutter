import 'package:base_lib/control/PagingListControl.dart';
import 'package:base_lib/export.dart';
import 'package:base_lib/widget/PagingData.dart';
import 'package:wanandroid_flutter/bean/HomeArticleBean.dart';
import 'package:wanandroid_flutter/network/ApiService.dart';

class HomeChangeControl extends PagingListControl<Datas> {
  HomeChangeControl() : super(firstPageIndex: 0);

  @override
  Future<PagingData<Datas>> loadPagingData({int pageIndex, bool reset}) async {
    HomeArticleBeanList result = await ApiService.requestHomeArticle(Get.context, pageIndex);
    pagingData = pagingData ?? PagingData<Datas>();
    pagingData
      ..hasNext = result.data.total > pagingData.dataList.length
      ..dataList.addAll(result.data.datas);
    return pagingData;
  }
}
