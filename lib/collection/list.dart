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

/// provides extensions for List
extension ListScrewDriver<E> on List<E> {
  /// adds [element] into the list and returns the list
  List<E> operator <<(E element) => this..add(element);

  /// Removes [element] from the list and returns true if the element is removed.
  bool operator >>(E element) => remove(element);

  /// Replaces an item in the list with [replacement] where [predicate] returns
  /// true. Returns true if an item is replaced, false otherwise.
  bool replaceFirstWhere(E replacement, bool Function(E item) predicate) {
    if (isEmpty) return false;
    for (int index = 0; index < length; index++) {
      if (predicate(elementAt(index))) {
        this[index] = replacement;
        return true;
      }
    }
    return false;
  }

  /// Replaces an item in the list with [replacement] where [predicate] returns
  /// true. Returns true if an item is replaced, false otherwise.
  bool replaceLastWhere(E replacement, bool Function(E item) predicate) {
    if (isEmpty) return false;
    for (int index = length - 1; index >= 0; index--) {
      if (predicate(elementAt(index))) {
        this[index] = replacement;
        return true;
      }
    }
    return false;
  }

  /// Reverse the list if [condition] is true.
  Iterable<E> reverseIf(bool condition) => condition ? toList().reversed : this;

  /// Returns a random element from this list.
  ///
  /// Returns `null` if this list is empty.
  ///
  /// If [random] is provided, it is used as the random number generator.
  /// This allows callers to pass a seeded [Random] for deterministic behavior
  /// or [Random.secure] for security-sensitive randomness.
  ///
  /// This operation is O(1), because [List] provides indexed access.
  E? randomOrNull([Random? random]) {
    if (length == 0) return null;
    if (length == 1) return first;

    final generator = random ?? Random();
    return this[generator.nextInt(length)];
  }

  /// Returns a random element from this list.
  ///
  /// Throws a [StateError] if this list is empty.
  ///
  /// If [random] is provided, it is used as the random number generator.
  /// This allows callers to pass a seeded [Random] for deterministic behavior
  /// or [Random.secure] for security-sensitive randomness.
  ///
  /// This operation is O(1), because [List] provides indexed access.
  E random([Random? random]) {
    if (length == 0) throw StateError('No elements');
    if (length == 1) return first;

    final generator = random ?? Random();
    return this[generator.nextInt(length)];
  }
}

/// provides extensions for List of integers. e.g. bytes
extension IntListScrewdriver on List<int> {
  /// Converts the list of integers to a base64 encoded string. e.g. converting
  /// bytes to base64 string.
  String toBase64() => base64Encode(this);

  /// Converts [this] list of integers to a [Uint8List].
  Uint8List toUint8List() => Uint8List.fromList(this);

  /// Converts [this] list of integers to a [Uint16List].
  Uint16List toUint16List() => Uint16List.fromList(this);
}
