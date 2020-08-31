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

/// Throws [IllegalStateException] if [argument] is `null`.
/// If [name] is supplied, it is used as the parameter name
/// in the error message.
/// Returns the [argument] if it is not null.
T checkNotNull<T>(T argument, [String message]) =>
    argument == null ? throw IllegalStateException(message) : argument;

/// Throws [IllegalStateException] if [argument] is `null`.
/// If [name] is supplied, it is used as the parameter name
/// in the error message.
/// Returns the [argument] if it is not null.
// ignore: avoid_positional_boolean_parameters
void check(bool value, [String message]) {
  if (!value) {
    throw IllegalStateException(message);
  }
}

/// Throws [IllegalArgumentException] if [argument] is `null`.
/// If [name] is supplied, it is used as the parameter name
/// in the error message.
/// Returns the [argument] if it is not null.
T requireNotNull<T>(T argument, [String message]) =>
    argument == null ? throw IllegalArgumentException(message) : argument;

/// Throws [IllegalArgumentException] if [argument] is `null`.
/// If [name] is supplied, it is used as the parameter name
/// in the error message.
/// Returns the [argument] if it is not null.
// ignore: avoid_positional_boolean_parameters
void require(bool value, [String message]) {
  if (!value) {
    throw IllegalArgumentException(message);
  }
}

/// Thrown to indicate that a method has been passed an illegal or
/// inappropriate argument.
class IllegalArgumentException implements Exception {
  /// message explaining why this occurred
  final String message;

  /// factory constructor that allows to pass a message
  IllegalArgumentException([this.message]);

  @override
  String toString() {
    if (message != null) {
      return 'IllegalArgumentException: $message';
    }
    return 'IllegalArgumentException';
  }
}

/// Signals that a method has been invoked at an illegal or
/// inappropriate time.
class IllegalStateException implements Exception {
  /// message explaining why this occurred
  final String message;

  /// factory constructor that allows to pass a message
  IllegalStateException([this.message]);

  @override
  String toString() {
    if (message != null) {
      return 'IllegalStateException: $message';
    }
    return 'IllegalStateException';
  }
}