import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid_flutter/page/Home.dart';

import 'network/ApiService.dart';
import 'network/AppNet.dart';
import 'network/LogInterceptor.dart';
import 'network/StatusCheckInterceptor.dart';
import 'notifier/AppChangeNotifier.dart';
import 'notifier/HomeChangeNotifier.dart';

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
    return MaterialApp(
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
      body: ChangeNotifierProvider<HomeChangeNotifier>(
        create: (context) => HomeChangeNotifier(),
        child: Home(),
      ),
    );
  }
}
