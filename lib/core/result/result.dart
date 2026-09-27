import 'package:follio/core/errors/failures.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  T? get dataOrNull => switch (this) {
        Success<T>(:final T data) => data,
        FailureResult<T>() => null,
      };

  T? get valueOrNull => dataOrNull;

  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        FailureResult<T>(:final Failure failure) => failure,
      };

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Success<T>(:final T data) => success(data),
      FailureResult<T>(failure: final Failure f) => failure(f),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);
  final Failure failure;
}
