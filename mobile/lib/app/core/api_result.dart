sealed class ApiResult<T> {
  const ApiResult();

  const factory ApiResult.success(T data, {int? statusCode}) = ApiSuccess<T>;

  const factory ApiResult.failure(
    String message, {
    int? statusCode,
    bool sessionExpired,
    Map<String, dynamic>? detailBody,
  }) = ApiFailure<T>;

  bool get isSuccess => this is ApiSuccess<T>;
  bool get isFailure => this is ApiFailure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(ApiFailure<T> failure) failure,
  }) {
    return switch (this) {
      ApiSuccess<T>(:final data) => success(data),
      final ApiFailure<T> error => failure(error),
    };
  }
}

class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data, {this.statusCode});

  final T data;
  final int? statusCode;
}

class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(
    this.message, {
    this.statusCode,
    this.sessionExpired = false,
    this.detailBody,
  });

  final String message;
  final int? statusCode;
  final bool sessionExpired;
  final Map<String, dynamic>? detailBody;
}

extension ApiMapResult on Map<String, dynamic> {
  ApiResult<Map<String, dynamic>> toApiResult() {
    if (this['error'] == true) {
      return ApiResult.failure(
        this['message'] as String? ?? 'Permintaan gagal',
        statusCode: this['statusCode'] as int?,
        sessionExpired: this['session_expired'] == true,
        detailBody: this['detail_body'] as Map<String, dynamic>?,
      );
    }

    return ApiResult.success(
      this['data'] as Map<String, dynamic>? ?? <String, dynamic>{},
      statusCode: this['statusCode'] as int?,
    );
  }
}
