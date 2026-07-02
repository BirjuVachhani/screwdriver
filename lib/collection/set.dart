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
// Created Date: August 20, 2020

part of '../screwdriver.dart';

/// Provides extensions for [Set].
extension SetScrewdriver<E> on Set<E> {
  /// Returns a random element from this set.
  ///
  /// Returns `null` if this set is empty.
  ///
  /// If [random] is provided, it is used as the random number generator.
  /// This allows callers to pass a seeded [Random] for deterministic behavior
  /// or [Random.secure] for security-sensitive randomness.
  ///
  /// This operation is O(n), because [Set] does not provide indexed access.
  E? randomOrNull([Random? random]) {
    final length = this.length;

    if (length == 0) return null;
    if (length == 1) return first;

    random ??= Random();

    return elementAt(random.nextInt(length));
  }

  /// Returns a random element from this set.
  ///
  /// Throws a [StateError] if this set is empty.
  ///
  /// If [random] is provided, it is used as the random number generator.
  /// This allows callers to pass a seeded [Random] for deterministic behavior
  /// or [Random.secure] for security-sensitive randomness.
  ///
  /// This operation is O(n), because [Set] does not provide indexed access.
  E random([Random? random]) {
    final length = this.length;

    if (length == 0) throw StateError('No elements');
    if (length == 1) return first;

    random ??= Random();

    return elementAt(random.nextInt(length));
  }
}
