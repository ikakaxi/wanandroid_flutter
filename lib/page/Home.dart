import 'package:base_lib/export.dart';
import 'package:base_lib/widget/paging_list.dart';

/// author: liuhaichao
/// description: 首页
/// create date：2020-11-10 on 11:50 AM
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/bean/HomeArticleBean.dart';
import 'package:wanandroid_flutter/control/HomeChangeControl.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PagingListWidget<Datas, HomeChangeControl>(
      createItem: (BuildContext context, int index, Datas data) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Text(data.title),
        );
      },
    );
  }
}
