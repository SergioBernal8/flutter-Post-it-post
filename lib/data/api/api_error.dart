enum ErrorType {
  BadRequest,
  Unauthorized,
  Forbidden,
  NotFound,
  InternalServerError,
  BadGateway,
  ServiceUnavailable,
  Unknown
}

class ApiError extends Error {
  final int errorCode;
  final ErrorType errorType;

  ApiError._(this.errorCode, this.errorType);

  factory ApiError(error) {
    switch (error) {
      case 400:
        return ApiError._(error, ErrorType.BadRequest);
      case 401:
        return ApiError._(error, ErrorType.Unauthorized);
      case 403:
        return ApiError._(error, ErrorType.Forbidden);
      case 404:
        return ApiError._(error, ErrorType.NotFound);
      case 500:
        return ApiError._(error, ErrorType.InternalServerError);
      case 502:
        return ApiError._(error, ErrorType.BadGateway);
      case 503:
        return ApiError._(error, ErrorType.ServiceUnavailable);
      default:
        return ApiError._(error, ErrorType.Unknown);
    }
  }
}
