sealed class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => message;
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server encountered an error.']);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection failed.']);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'The operation timed out.']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class RateLimitFailure extends Failure {
  const RateLimitFailure([super.message = 'Rate limit reached. Please wait before submitting again.']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to load local cached data.']);
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed. Invalid credentials.']);
}

