import 'package:base_lib/DioCreator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';


class CommonApiService{

  static Future<String> _request(BuildContext context, Future<Response> future) {
    assert(() {
      try {
        if (context != null && Navigator.of(context) == null) {
          throw 'context必须是Scaffold的context';
        }
      } catch (error) {
        throw error.toString();
      }
      return true;
    }());
    return future.then((response) {
      String dataString = response.data.toString();
      return dataString;
    });
  }

  static Future requestGet(
      BuildContext context, {
        @required String url,
        dynamic data,
      }) {
    return _request(context, DioCreator.getDio().get(url, queryParameters: data));
  }

  static Future requestPost(
      BuildContext context, {
        @required String url,
        dynamic data,
      }) {
    return _request(context, DioCreator.getDio().post(url, data: data));
  }

  static Future requestDelete(
      BuildContext context, {
        @required String url,
        dynamic data,
      }) {
    return _request(context, DioCreator.getDio().delete(url, data: data));
  }

  static Future requestPut(
      BuildContext context, {
        @required String url,
        dynamic data,
      }) {
    return _request(context, DioCreator.getDio().put(url, data: data));
  }
}