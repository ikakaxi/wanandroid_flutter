import 'dart:convert';

import 'package:dio/dio.dart';

/// author:liuhaichao
/// description:检查状态码来判断请求是否成功
/// create date：2020-11-09 on 8:48 PM
class StatusCheckInterceptor extends Interceptor {
  onResponse(Response response) async {
    String dataString = response.data.toString();
    dynamic responseJson = json.decode(dataString);
    if (responseJson is Map) {
      Map<String, dynamic> jsonObject = json.decode(dataString);
      if (jsonObject.containsKey('errorCode')) {
        if (jsonObject['errorCode'] == 0) {
          return response;
        } else {
          throw jsonObject['message'] ?? "未知错误";
        }
      } else {
        return response;
      }
    }
    return response;
  }
}
