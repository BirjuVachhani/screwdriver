/*
 *  Copyright (c) 2020, Birju Vachhani
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 *  1. Redistributions of source code must retain the above copyright notice,
 *     this list of conditions and the following disclaimer.
 *
 *  2. Redistributions in binary form must reproduce the above copyright notice,
 *     this list of conditions and the following disclaimer in the documentation
 *     and/or other materials provided with the distribution.
 *
 *  3. Neither the name of the copyright holder nor the names of its
 *     contributors may be used to endorse or promote products derived from
 *     this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 *  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 *  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *  POSSIBILITY OF SUCH DAMAGE.
 */

// Author: Birju Vachhani
// Created Date: August 27, 2020

part of screwdriver;

/// provides scope functions as extensions on [T]
extension GenericScrewdriver<T extends Object> on T {
  /// Calls the specified function [block] with `this` value as its argument
  /// and returns `this` value.
  T apply(void Function(T obj) block) {
    block(this);
    return this;
  }

  /// Calls the specified function [block] with `this` value as its argument
  /// and returns `this` value.
  R run<R>(R Function(T obj) block) {
    return block(this);
  }

  /// Returns [this] if it satisfies the given [predicate] or null,
  /// if it doesn't.
  T? takeIf(bool Function(T obj) predicate) {
    if (predicate(this)) {
      return this;
    }
    return null;
  }

  /// Returns [this] if it doesn't satisfy the given [predicate] or null,
  /// if it doesn't.
  T? takeUnless(bool Function(T obj) predicate) {
    if (!predicate(this)) {
      return this;
    }
    return null;
  }

  /// A safe cast operation that returns null if the cast is not possible.
  /// Otherwise, returns the casted value.
  R? tryCast<R>() {
    try {
      return this as R?;
    } catch (e) {
      return null;
    }
  }
}

// Calls the specified function [block] with `this` value as its argument
/// and returns `this` value.
@Deprecated('Call block directly instead.')
R run<R>(R Function() block) => block();

/// Always throws [UnimplementedError] stating that operation is
/// not implemented.
// ignore: non_constant_identifier_names
void TODO([String? reason]) =>
    throw UnimplementedError(reason ?? 'An operation is not implemented.');

/// Executes a provided action and handles potential errors.
///
/// The function returns T? which represents the result of the executed action
/// if the action is not asynchronous. If the action completes successfully,
/// the result is returned as is. If an exception occurs during the execution,
/// the [onError] function is called with the error and stack trace. If the
/// [onError] function is not provided or returns null, the error is swallowed
/// and the result is set to null.
///
/// The function returns a [Future] of type T? which represents the result of
/// the executed action if the action is asynchronous. If the action completes
/// successfully, the result is returned as is. If an exception occurs during
/// the execution, the [onError] function is called with the error and stack
/// trace. If the [onError] function is not provided or returns null, the error
/// is swallowed and the result is set to null.
///
/// If the [onError] function is synchronous, the result is returned as is. If
/// it throws an error, the error is swallowed and the result is set to null.
///
/// If the [onError] function is asynchronous, a [Future] of type T? is
/// returned. If the [onError] function completes successfully, the result is
/// returned as is. If it throws an error, the error is swallowed and the
/// result is set to null.
FutureOr<T?> runCaching<T>(
  FutureOr<T?> Function() action, {
  FutureOr<T?> Function(dynamic error, StackTrace stacktrace)? onError,
}) {
  FutureOr<T?> result;
  try {
    result = action.call();
  } catch (error, stacktrace) {
    try {
      // call onError if exception occurs.
      result = onError?.call(error, stacktrace);
    } catch (error) {
      // Swallow error if onError throws an error.
      result = null;
    }
  }

  if (result is Future) {
    return (result as Future<T?>)
        // return the value if future completes successfully.
        .then((value) => value)
        // call onError if future completes with error.
        .catchError(
            (error, StackTrace stacktrace) => onError?.call(error, stacktrace))
        // swallow error and return null if onError throws an error.
        .catchError((error) => null);
  }

  return result;
}
