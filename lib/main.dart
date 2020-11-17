import 'package:base_lib/export.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid_flutter/page/Home.dart';

import 'control/AppChangeNotifier.dart';
import 'control/HomeChangeControl.dart';
import 'network/ApiService.dart';
import 'network/AppNet.dart';
import 'network/LogInterceptor.dart';
import 'network/StatusCheckInterceptor.dart';
import 'notifier/AppChangeNotifier.dart';

void main() {
  ApiService.init(
    AppNet.BASE_URL,
    interceptors: [
      LogInterceptor(),
      StatusCheckInterceptor(),
    ],
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppChangeNotifier(),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<HomeChangeControl>(() => HomeChangeControl(), fenix: true);
        Get.lazyPut<AppChangeControl>(() => AppChangeControl(), fenix: true);
      }),
      title: 'WanAndroid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppPage(),
    );
  }
}

class AppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Home(),
    );
  }
}
