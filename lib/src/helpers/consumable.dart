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
// Created Date: February 18, 2025

import 'package:meta/meta.dart';

/// Utility functions and classes for creating consumable values that can be used
/// a limited number of times before being exhausted.

/// Creates a [Consumable] that can only be consumed once.
///
/// Example:
/// ```dart
/// final consumable = consumeOnce(42);
/// print(consumable.consume()); // Prints: 42
/// print(consumable.consume()); // Prints: null
/// ```
Consumable<T> consumeOnce<T extends Object>(T value) =>
    SingleConsumable<T>(value);

/// Creates a [Consumable] that can be consumed multiple times.
///
/// [times] specifies how many times the value can be consumed before being exhausted.
/// Defaults to 1 if not specified.
///
/// Example:
/// ```dart
/// final consumable = consume(42, times: 2);
/// print(consumable.consume()); // Prints: 42
/// print(consumable.consume()); // Prints: 42
/// print(consumable.consume()); // Prints: null
/// ```
Consumable<T> consume<T extends Object>(T value, {int times = 1}) =>
    MultiConsumable<T>(value, times: times);

/// Base class for implementing consumable values.
///
/// A consumable value is a wrapper around a value that can be accessed a limited
/// number of times before becoming unavailable.
abstract base class Consumable<T extends Object> {
  /// The wrapped value. Becomes null when consumed.
  T? _value;

  /// Creates a new consumable with the given [value].
  Consumable(T value) : _value = value;

  /// Creates a [SingleConsumable] that can only be consumed once.
  factory Consumable.single(T value) => SingleConsumable(value);

  /// Creates a [MultiConsumable] that can be consumed multiple times.
  ///
  /// [times] specifies how many times the value can be consumed before being exhausted.
  factory Consumable.multi(T value, {int times = 1}) =>
      MultiConsumable(value, times: times);

  /// Whether the value has been fully consumed.
  bool get isConsumed => _value == null;

  /// Whether the value can still be consumed.
  bool get canConsume => _value != null;

  /// Consumes and returns the value if available, otherwise returns null.
  ///
  /// This method must be called by subclasses when implementing custom
  /// consumption logic.
  @mustCallSuper
  T? consume() {
    final value = _value;
    markConsumed();
    return value;
  }

  /// Marks the value as consumed, making it unavailable for future consumption.
  @mustCallSuper
  void markConsumed() => _value = null;
}

/// A consumable that can only be consumed once.
///
/// After the first consumption, the value becomes null and cannot be accessed again.
final class SingleConsumable<T extends Object> extends Consumable<T> {
  /// Creates a new single-use consumable with the given [value].
  SingleConsumable(super.value);
}

/// A consumable that can be consumed multiple times before being exhausted.
final class MultiConsumable<T extends Object> extends Consumable<T> {
  /// The total number of times the value can be consumed.
  final int _count;

  int _remaining;

  /// The remaining number of times the value can be consumed.
  int get remaining => _remaining;

  /// Returns the total number of times this value can be consumed.
  int get count => _count;

  /// Creates a new multi-use consumable with the given [value] and consumption [times].
  ///
  /// The value can be consumed up to [times] times before being exhausted.
  MultiConsumable(super.value, {int times = 1})
      : _count = times,
        _remaining = times {
    if (times < 1) throw ArgumentError('times must be greater than 1');
  }

  /// Consumes and returns the value if there are remaining uses, otherwise returns null.
  ///
  /// The value becomes null only after all permitted uses are exhausted.
  @override
  T? consume() {
    if (_remaining <= 0) return null;
    _remaining--;
    if (_remaining == 0) return super.consume();
    return _value;
  }

  /// Marks the value as fully consumed, regardless of remaining uses.
  @override
  void markConsumed() {
    _remaining = 0;
    super.markConsumed();
  }
}
