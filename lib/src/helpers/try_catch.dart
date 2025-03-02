/// A custom error type that wraps an error and its stack trace.
///
/// [E] is the type of error that will be wrapped.
/// The internal value is a tuple containing the error and optional stack trace.
extension type TryCatchError<E extends Object>._(
    (E error, StackTrace? stackTrace) value) {
  /// Creates a new [TryCatchError] instance.
  ///
  /// Parameters:
  /// - [error]: The error object to wrap
  /// - [stackTrace]: Optional stack trace associated with the error
  factory TryCatchError(E error, [StackTrace? stackTrace]) =>
      TryCatchError<E>._((error, stackTrace));

  /// Returns the wrapped error object.
  E get error => value.$1;

  /// Returns the stack trace associated with the error, if any.
  StackTrace? get stacktrace => value.$2;
}

/// Safely executes an asynchronous operation and catches specific error types.
///
/// This function wraps a Future operation and returns a tuple containing either:
/// - The successful result and null error, or
/// - A null result and the caught error wrapped in [TryCatchError]
///
/// Type Parameters:
/// - [R]: The type of the successful result
/// - [E]: The specific type of error to catch
///
/// Parameters:
/// - [future]: The Future operation to execute
///
/// Returns a tuple containing the result and error, where one will always be null.
Future<(R? data, TryCatchError<E>? error)> tryCatchOnly<R, E extends Object>(
    Future<R> future) async {
  try {
    return (await future, null);
  } on E catch (error, stacktrace) {
    return (null, TryCatchError<E>(error, stacktrace));
  }
}

/// Safely executes an asynchronous operation and catches any error.
///
/// This function wraps a Future operation and returns a tuple containing either:
/// - The successful result and null error, or
/// - A null result and the caught error wrapped in [TryCatchError]
///
/// Unlike [tryCatchOnly], this catches all error types rather than a specific one.
///
/// Type Parameters:
/// - [R]: The type of the successful result
///
/// Parameters:
/// - [future]: The Future operation to execute
///
/// Returns a tuple containing the result and error, where one will always be null.
Future<(R? data, TryCatchError? error)> tryCatch<R>(Future<R> future) async {
  try {
    return (await future, null);
  } catch (error, stacktrace) {
    return (null, TryCatchError(error, stacktrace));
  }
}
