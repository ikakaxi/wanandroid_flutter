import 'dart:convert';

import 'package:base_lib/CommonApiService.dart';
import 'package:base_lib/DioCreator.dart';
import 'package:base_lib/export.dart';
import 'package:flutter/widgets.dart';
import 'package:wanandroid_flutter/bean/ArticleBeanList.dart';
import 'package:wanandroid_flutter/bean/BannerBeanList.dart';
import 'package:wanandroid_flutter/bean/HomeArticleBean.dart';

class ApiService {
  ApiService._();

  static void init(String baseUrl, {List<Interceptor> interceptors}) {
    DioCreator.initDio(baseUrl, interceptors: interceptors);
  }

  ///置顶文章
  static Future<TopArticleBeanList> requestArticleBeanList(BuildContext context) async {
    String string = await CommonApiService.requestGet(
      context,
      url: '/article/top/json',
    );
    return TopArticleBeanList.fromJson(json.decode(string));
  }

  ///首页文章列表
  static Future<HomeArticleBeanList> requestHomeArticle(BuildContext context, int page) async {
    String string = await CommonApiService.requestGet(
      context,
      url: '/article/list/$page/json',
    );
    return HomeArticleBeanList.fromJson(json.decode(string));
  }

  ///首页banner
  static Future<BannerBeanList> requestBannerBeanList(BuildContext context) async {
    String string = await CommonApiService.requestGet(
      context,
      url: '/banner/json',
    );
    return BannerBeanList.fromJson(json.decode(string));
  }
}
