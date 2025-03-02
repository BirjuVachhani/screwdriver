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

part of '../screwdriver.dart';

/// Runs given [action] no sooner than in the next event-loop iteration,
/// after all micro-tasks have run.
Future<T> post<T>(FutureOr<T> Function() action) =>
    Future.delayed(Duration.zero, action);

/// Runs given [action] after a delay of [millis], no sooner than in the
/// next event-loop iteration, after all micro-tasks have run.
Future<T> postDelayed<T>(int millis, FutureOr<T> Function() action) =>
    Future.delayed(Duration(milliseconds: millis), action);

/// Provides extensions on [Future].
extension FutureScrewdriver<R> on Future<R> {
  /// Safely executes this future and catches specific error types.
  ///
  /// Returns a tuple containing either:
  /// - The successful result and null error, or
  /// - A null result and the caught error wrapped in [TryCatchError]
  ///
  /// Type Parameters:
  /// - [E]: The specific type of error to catch
  ///
  /// Example:
  /// ```dart
  /// final (data, error) = await myFuture.tryCatch<HttpException>();
  /// if (error != null) {
  ///   // Handle HttpException
  /// } else {
  ///   // Use data
  /// }
  /// ```
  ///
  /// See also:
  /// - [tryCatchOnly] for a standalone version of this function
  Future<(R? data, TryCatchError<E>? error)>
      tryCatch<E extends Object>() async {
    try {
      return (await this, null);
    } on E catch (error, stacktrace) {
      return (null, TryCatchError<E>(error, stacktrace));
    }
  }
}
