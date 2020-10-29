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
extension ScopeScrewdriver<T> on T {
  /// Calls the specified function [block] with `this` value as its argument
  /// and returns `this` value.
  T apply(void block(T obj)) {
    if (block != null) {
      block(this);
    }
    return this;
  }

  /// Calls the specified function [block] with `this` value as its argument
  /// and returns `this` value.
  R run<R>(R block(T obj)) {
    if (block != null) {
      return block(this);
    }
    return null;
  }

  /// Returns [this] if it satisfies the given [predicate] or null,
  /// if it doesn't.
  T takeIf(bool predicate(T obj)) {
    if (predicate != null && predicate(this)) {
      return this;
    }
    return null;
  }

  /// Returns [this] if it doesn't satisfy the given [predicate] or null,
  /// if it doesn't.
  T takeUnless(bool predicate(T obj)) {
    if (predicate != null && !predicate(this)) {
      return this;
    }
    return null;
  }

  /// alias for [to]
  Pair<T, V> pairWith<V>(V value) => Pair(this, value);

  /// pairs [this] with given [value] and returns an instance of [Pair]
  Pair<T, V> to<V>(V value) => Pair(this, value);
}

// Calls the specified function [block] with `this` value as its argument
/// and returns `this` value.
R run<R>(R block()) {
  return block?.call();
}

/// Always throws [UnimplementedError] stating that operation is
/// not implemented.
// ignore: non_constant_identifier_names
void TODO([String reason]) =>
    throw UnimplementedError(reason ?? 'An operation is not implemented.');

/// Run given [action] in a try-catch block and calls [onError] on exception.
T runCaching<T>(T action(),
    {void onError(dynamic error, StackTrace stacktrace)}) {
  try {
    return action?.call();
  } catch (error, stacktrace) {
    onError?.call(error, stacktrace);
    return null;
  }
}
