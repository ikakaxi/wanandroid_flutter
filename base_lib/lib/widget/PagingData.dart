class PagingData<T> {
  int page;
  bool hasNext;
  List<T> dataList = [];

  void reset() {
    page = null;
    hasNext = null;
    dataList?.clear();
  }
}
