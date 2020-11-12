class BasePage<T> {
  int page;
  bool hasNext;
  List<T> dataList = [];

  void clear() {
    dataList?.clear();
  }
}
