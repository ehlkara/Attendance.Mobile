class Response {
  Response({this.result, this.success, this.error});
  final bool success;
  final dynamic result;
  final ResponseError error;
}

class ResponseError {
  ResponseError({this.code, this.message});
  final int code;
  final String message;
}
