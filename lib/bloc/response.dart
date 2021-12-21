abstract class ResponseBase<T> {
  final T result;
  final ResponseError error;
  final bool hasError;
  ResponseBase(this.result, this.error, this.hasError);
}

class ResponseError {
  ResponseError(this.code, this.message, this.data);
  final int code;
  final String message;
  final dynamic data;
}

class Response<T> implements ResponseBase<T> {
  Response(this.result, this.error, this.hasError);

  Response.fromJson(Map<String, dynamic> json)
      : result = json["result"],
        error = json["result"],
        hasError = json["hasError"];

  @override
  // TODO: implement error
  final ResponseError error;

  @override
  // TODO: implement hasError
  final bool hasError;

  @override
  // TODO: implement result
  final T result;
}
