import 'package:flutter/material.dart';

class TabView extends StatefulWidget {
  final PreferredSizeWidget _appBar;
  final PageController _pageController;
  final List<String> _tabTitles;
  final List<Widget> _tabWidgets;

  TabView({
    PreferredSizeWidget appBar,
    @required PageController pageController,
    @required List<String> tabTitles,
    @required List<Widget> tabWidgets,
  })  : this._appBar = appBar,
        this._pageController = pageController,
        this._tabTitles = tabTitles,
        this._tabWidgets = tabWidgets;

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin<TabView> {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
      vsync: this, //动画效果的异步处理，默认格式，背下来即可
      length: widget._tabTitles.length, //需要控制的Tab页数量
    );
    _tabController.addListener(() {
      widget._pageController.jumpToPage(_tabController.index);
    });
  }

  // 当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _tabController.dispose();
    widget._pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget._appBar,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: widget._pageController,
        children: widget._tabWidgets,
        onPageChanged: (index) {
          _tabController.animateTo(index);
        },
      ),
    );
  }
}
