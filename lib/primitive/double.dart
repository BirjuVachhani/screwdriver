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
// Created Date: August 19, 2020

part of '../screwdriver.dart';

final NumberFormat _formatter = NumberFormat('0.##')..minimumFractionDigits = 0;

/// Provides extensions for [double].
extension DoubleScrewdriver on double {
  /// Returns to if [this] has .00000 fraction points
  bool get isWhole =>
      this != double.infinity &&
      this != double.negativeInfinity &&
      !isNaN &&
      truncate() == this;

  /// Rounds value [precision] number of fraction points.
  /// Example:
  /// 2.1234567890.roundToPrecision(0)=> 2
  /// 2.1234567890.roundToPrecision(1)=> 2.1
  /// 2.1234567890.roundToPrecision(2)=> 2.12
  /// 2.1234567890.roundToPrecision(3)=> 2.123
  double roundToPrecision(int nthPosition) {
    if (isNaN || isInfinite || this == double.negativeInfinity) return this;
    _formatter.maximumFractionDigits = nthPosition;
    return double.parse(_formatter.format(this));
  }

  /// Returns true if [this] is close to [other] within [precision].
  /// By default, [precision] is set to 1.0e-8 which is 0.00000001 which makes
  /// it suitable for most of the cases.
  bool isCloseTo(double other, {double precision = 1.0e-8}) {
    return (this - other).abs() <= precision;
  }
}

/// Generates a non-negative random floating point value uniformly distributed
/// in the range from 0.0, inclusive, to 1.0, exclusive.
double randomDouble({double? max}) => Random().nextDouble() * (max ?? 1);
