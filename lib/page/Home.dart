import 'package:base_lib/export.dart';
import 'package:base_lib/widget/state_abstract_paging_list.dart';

/// author: liuhaichao
/// description: 首页
/// create date：2020-11-10 on 11:50 AM
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/bean/HomeArticleBean.dart';
import 'package:wanandroid_flutter/notifier/HomeChangeNotifier.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PagingListWidget<Datas, HomeChangeNotifier>(
      createItem: (BuildContext context, int index, Datas data) {
        return Text(data.title);
      },
    );
  }
}
