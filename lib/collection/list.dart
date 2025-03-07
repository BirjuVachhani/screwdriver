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
}
