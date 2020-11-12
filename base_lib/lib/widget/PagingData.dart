class PagingData<T> {
  bool hasNext;
  List<T> dataList = [];

  void reset() {
    hasNext = null;
    dataList?.clear();
  }
}
