import 'package:flutter/material.dart';

/// 这个类的生命周期，只有在程序退到后台和恢复的时候才执行didChangeAppLifecycleState，
/// 页面的切换并不会执行didChangeAppLifecycleState方法
mixin LifeCycle<T extends StatefulWidget> on State<T> implements WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        onInBackground();
        break;
      case AppLifecycleState.resumed:
        onForeground();
        break;
    }
  }

  /// android程序退到后台执行AppLifecycleState.inactive->ppLifecycleState.paused
  void onInBackground() {}

  /// android程序从后台进入前台执行AppLifecycleState.inactive->ppLifecycleState.resumed
  void onForeground() {}

  @override
  void didChangeAccessibilityFeatures() {
    // TODO: implement didChangeAccessibilityFeatures
  }

  @override
  void didChangeLocales(List<Locale> locale) {
    // TODO: implement didChangeLocales
  }

  @override
  void didChangeMetrics() {
    // TODO: implement didChangeMetrics
  }

  @override
  void didChangePlatformBrightness() {
    // TODO: implement didChangePlatformBrightness
  }

  @override
  void didChangeTextScaleFactor() {
    // TODO: implement didChangeTextScaleFactor
  }

  @override
  void didHaveMemoryPressure() {
    // TODO: implement didHaveMemoryPressure
  }

  @override
  Future<bool> didPopRoute() {
    // TODO: implement didPopRoute
    return null;
  }

  @override
  Future<bool> didPushRoute(String route) {
    // TODO: implement didPushRoute
    return null;
  }
}
