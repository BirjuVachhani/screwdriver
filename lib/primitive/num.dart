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
// Created Date: August 17, 2020

part of '../screwdriver.dart';

/// Provides extensions for [num].
extension NumScrewdriver on num {
  /// converts positive numbers into negative ones.
  /// Use [abs] for conversion to positive numbers.
  num get negative => sign > 0 ? -this : this;

  /// Returns true if [this] falls between [value1] and [value2] irrespective
  /// of the order of [value1] and [value2].
  /// Includes boundaries if [inclusive] is true.
  bool isBetween(num value1, num value2, {bool inclusive = false}) => inclusive
      ? (this >= value1 && this <= value2) || (this >= value2 && this <= value1)
      : (this > value1 && this < value2) || (this > value2 && this < value1);

  /// Rounds value [precision] number of fraction points.
  num roundToPrecision(int precision) =>
      num.parse((this).toStringAsFixed(precision));

  /// Turns this number from degrees to radians.
  double get inRadians => this * pi / 180;

  /// Turns this number from radians to degrees.
  double get inDegrees => this * 180 / pi;
}

/// Provides typed extensions for num and all its subtypes.
extension TypedNumScrewdriver<T extends num> on T {
  /// Returns [upperBound] if this value is greater than or equal to
  /// [upperBound], otherwise returns this value.
  ///
  /// If [exclusive] is true, then it will return [upperBound] if this value
  /// is greater than [upperBound].
  T max(T upperBound, {bool exclusive = false}) {
    if (exclusive) return this < upperBound ? this : upperBound;
    return this < upperBound ? this : upperBound;
  }

  /// Returns [lowerBound] if this value is less than or equal to
  /// [lowerBound], Otherwise returns this value.
  ///
  /// If [exclusive] is true, then it will return [lowerBound] if this value
  /// is less than [lowerBound].
  T min(T lowerBound, {bool exclusive = false}) {
    if (exclusive) return this > lowerBound ? this : lowerBound;
    return this > lowerBound ? this : lowerBound;
  }

  /// Returns this value if it is greater than or equal to [lowerBound].
  /// Returns [lowerBound] otherwise.
  T clampAtLeast(T lowerBound) => this < lowerBound ? lowerBound : this;

  /// Returns this value if it is less than or equal to [upperBound].
  /// Returns [upperBound] otherwise.
  T clampAtMost(T upperBound) => this > upperBound ? upperBound : this;
}

/// Provides extensions for nullable [num] types.
extension NullableNumScrewdriver on num? {
  /// Returns this value or 0 if null. Useful for equations.
  num get orZero => this == null ? 0 : this!;

  /// Returns this value or 1 if null. Useful for equations.
  num get orOne => this == null ? 1 : this!;

  /// Returns this or [value] if null.  Useful for equations.
  num or(num value) => this == null ? value : this!;
}
