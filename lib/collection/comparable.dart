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
// Created Date: August 21, 2020

part of screwdriver;

/// provides extensions for [Comparable]
extension ComparableScrewdriver<E extends Comparable<dynamic>> on E {
  /// Returns true if [other] object is less than [this].
  bool operator <(E other) => compareTo(other) < 0;

  /// Returns true if [other] object is less than or equal to [this].
  bool operator <=(E other) => compareTo(other) <= 0;

  /// Returns true if [other] object is greater than [this].
  bool operator >(E other) => compareTo(other) > 0;

  /// Returns true if [other] object is greater than or equal to [this].
  bool operator >=(E other) => compareTo(other) >= 0;

  /// Ensures that this value is not less than the specified [minimum] value.
  /// returns this value if it's greater than or equal to the [minimum] value
  /// or the [minimum] value otherwise.
  E coerceAtLeast(E minimum) => this < minimum ? minimum : this;

  /// Ensures that this value is not greater than the specified [maximum] value.
  /// Returns this value if it's less than or equal to the [maximum] value
  /// or the [maximum] value otherwise.
  E coerceAtMost(E maximum) => this > maximum ? maximum : this;

  /// Ensures that this value lies in the specified range [min] <--> [max].
  /// Return this value if it's in the range, or [min] value if this value
  /// is less than [min] value, or [max] value if this value is
  /// greater than [max] value.
  E coerceIn(E min, E max) {
    if (min > max) {
      throw IllegalArgumentException(
          'Cannot coerce value to an empty range: maximum $max is '
          'less than minimum $min.');
    }
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}
