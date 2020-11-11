import 'package:dio/dio.dart' hide LogInterceptor;

///创建dio联网工具类的类
class DioCreator {
  static Dio _dio;

  DioCreator._();

  static void initDio(String baseUrl, {List<Interceptor> interceptors}) {
    if (_dio == null) {
      BaseOptions options = new BaseOptions(
        responseType: ResponseType.plain,
        baseUrl: baseUrl,
        connectTimeout: 10 * 1000,
        receiveTimeout: 10 * 1000,
      );
      _dio = Dio(options);
      interceptors?.forEach((element) {
        _dio.interceptors.add(element);
      });
    }
  }

  static Dio getDio() => _dio;

  static void reset() {
    _dio?.interceptors?.clear();
    _dio?.clear();
    _dio = null;
  }
}
