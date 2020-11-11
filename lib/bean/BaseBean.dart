class BaseBean {
  int errorCode;
  String errorMsg;

  BaseBean({this.errorCode, this.errorMsg});

  bool isSuccess() => errorCode == 0;
}
