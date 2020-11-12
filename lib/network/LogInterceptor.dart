import 'package:dio/dio.dart';

class LogInterceptor extends Interceptor {
  static const String _TAG = "LogInterceptor";

  onRequest(RequestOptions options) async {
    String url = "";
    if (options.path.startsWith("http")) {
      url = options.path;
    } else {
      url = options.baseUrl + options.path;
    }
    print("""
$_TAG request==>
  path=$url
  method=${options.method}
  token=${options.headers["token"]}
  ${options.data == null ? "" : "\n\t\tparam=${options.data}"}
""");
    return options;
  }

  onResponse(Response response) async {
    String url = "";
    if (response.request.path.startsWith("http")) {
      url = response.request.path;
    } else {
      url = response.request.baseUrl + response.request.path;
    }
    String dataString = response.data.toString();
    print("""
$_TAG <==response
  path=$url
  method=${response.request.method}
  token=${response.request.headers["token"]}
  ${response.request.data == null ? "" : "\n\t\tparam=${response.request.data}"}
  response=$dataString
""");
    return response;
  }

  onError(DioError err) async {
    print("$_TAG onError=>" + err.toString());
    return err;
  }
}
