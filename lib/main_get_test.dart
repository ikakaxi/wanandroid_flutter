import 'package:base_lib/export.dart';
import 'package:flutter/material.dart';

import 'network/ApiService.dart';
import 'network/AppNet.dart';
import 'network/LogInterceptor.dart';
import 'network/StatusCheckInterceptor.dart';

void main() {
  ApiService.init(
    AppNet.BASE_URL,
    interceptors: [
      LogInterceptor(),
      StatusCheckInterceptor(),
    ],
  );
  runApp(
    DemoApp(),
  );
}

class Control extends GetxController {
  RxInt num = 0.obs;
  RxInt num2 = 0.obs;
  int n = 0;

  void add() {
    n++;
    update();
  }
}

class Control2 extends GetxController {
  RxInt num = 0.obs;
}

class DemoApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第二页"),
      ),
      body: GetX<Control2>(
        builder: (control2) {
          return Column(
            children: [
              // Text('aaa'),
              Text(control2.num.toString()),
              RaisedButton(
                onPressed: () {
                  control2.num++;
                },
                child: Text("点击"),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

RxInt num11 = 0.obs;
RxInt num22 = 0.obs;
RxString s = "11".obs;
final user = User().obs;

class User {
  User({this.name = '', this.age = 0});

  String name;
  int age;
}

class _DemoAppState extends State<DemoApp> {
  @override
  void initState() {
    // Get.put(Control());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var message = 'Hello world'.obs;
    // print( 'Message "$message" has Type ${message.runtimeType}');
    // print("build");
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put<Control>(Control());
        // Get.lazyPut<Control2>(()=>Control2(),fenix: true);
        Get.create<Control2>(() => Control2());
        // Get.lazyPut<Control>(()=>Control());
        // // Get.lazyPut<Control2>(()=>Control2(),fenix: true);
        // Get.lazyPut<Control2>(() {
        //   print("Get.lazyPut<Control2>");
        //   return Control2();
        // },fenix: true);
      }),
      title: 'WanAndroid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('title'),
        ),
        body: Column(
          children: [
            GetX<Control>(builder: (controller) {
              return Column(
                children: [
                  Text('${controller.num}'),
                  RaisedButton(
                    onPressed: () {
                      controller.num++;
                    },
                    child: Text('上面的+1'),
                  ),
                ],
              );
            }),
            Obx(() {
              return Text(num22.toString());
            }),
            RaisedButton(
              onPressed: () {
                num22.value++;
              },
              child: Text('上面的+1'),
            ),
            Obx(() {
              return Text(s.toString());
            }),
            RaisedButton(
              onPressed: () {
                s.value = s + "a";
              },
              child: Text('上面的改变'),
            ),
            Obx(() {
              return Text("${user.value.name} ${user.value.age} ");
            }),
            RaisedButton(
              onPressed: () {
                user(User(name: 'João', age: 35));
              },
              child: Text('上面的改变'),
            ),
            GetBuilder<Control>(
              init: Control(), // 首次启动
              builder: (control) {
                return Column(
                  children: [
                    Text(
                      '${control.n}',
                    ),
                    RaisedButton(
                      onPressed: () {
                        control.add();
                      },
                      child: Text('改变上面的'),
                    )
                  ],
                );
              },
            ),
            RaisedButton(
              onPressed: () {
                Get.to(DemoApp2());
                // Get.to(
                //   DemoApp2(),
                //   binding: BindingsBuilder(() {
                //     Get.put<Control2>(Control2());
                //   }),
                // );
              },
              child: Text('跳到页面2'),
            ),
          ],
        ),
      ),
    );
  }
}
