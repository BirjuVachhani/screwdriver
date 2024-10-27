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
// Created Date: October 27, 2023

import 'dart:async';

/// Waits for the given [action] to complete and returns the result.
/// This is useful when an async operation doesn't support async/await and
/// you have to use a callback-based approach that requires you to utilize
/// a completer. This function helps you to avoid writing boilerplate code
/// for creating a completer and returning its future.
///
/// [action] is a function that takes a [Completer] as an argument. You can
/// call `completer.complete(value)` to return a value or
/// `completer.completeError(error)` to return an error.
///
/// Example:
///
/// Without using `complete`:
/// ```dart
///   final Completer<String> completer = Completer<String>();
///
///   // perform async operation
///   myAsyncOperation((String data) {
///     completer.complete(data);
///   });
///
///   final String result = await completer.future;
///   print(result);
/// ```
///
/// Using `complete`:
///
/// ```dart
///   final String result = await complete<String>((completer) {
///      // perform async operation
///      myAsyncOperation((String data) {
///        completer.complete(data);
///      });
///   });
///
///   print(result);
/// ```
///
/// This does not handle the case where [action] throws an error. If you want
/// to handle errors, you can use a try-catch block inside the
/// [action] function and call `completer.completeError(error)` to return an
/// error to the caller of `complete`.
Future<T> complete<T>(void Function(Completer<T> completer) action) async {
  final Completer<T> completer = Completer<T>();
  action(completer);
  return completer.future;
}
