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

/// provides extensions for Iterable
extension IterableScrewDriver<E> on Iterable<E> {
  /// Returns the first element in the iterable or returns null
  /// if iterable is empty.
  E get firstOrNull => isNotEmpty ? first : null;

  /// Returns the first element that satisfies the given predicate [test] or
  /// returns null.
  E firstOrNullWhere(bool test(E e)) {
    if (isEmpty) return null;
    return firstWhere((element) => test(element), orElse: () => null);
  }

  /// Returns the second element in the iterable or
  /// returns null if iterable is empty or has only 1 element.
  E get secondOrNull => length > 1 ? elementAt(1) : null;

  /// Returns the third element in the iterable or
  /// returns null if iterable is empty or has less than 3 elements.
  E get thirdOrNull => length > 2 ? elementAt(2) : null;

  /// Returns the last element in the iterable or returns null
  /// if iterable is empty.
  E get lastOrNull => isNotEmpty ? last : null;

  /// Returns the last element that satisfies the given predicate [test] or
  /// returns null.
  E lastOrNullWhere(bool test(E e)) {
    if (isEmpty) return null;
    return lastWhere((element) => test(element), orElse: () => null);
  }

  /// Returns single element that satisfies the given predicate [test] or
  /// returns null.
  E singleOrNullWhere(bool test(E e)) {
    if (isEmpty) return null;
    return singleWhere((element) => test(element), orElse: () => null);
  }

  /// Appends all elements matching the given [predicate] to
  /// the given [destination].
  Iterable<E> filterTo(List<E> destination, bool predicate(E element)) {
    for (final element in this) {
      if (predicate(element)) destination.add(element);
    }
    return destination;
  }

  /// alias for [Iterable.where]
  Iterable<E> filter(bool predicate(E element)) => filterTo(<E>[], predicate);

  /// alias for [whereIndexed]
  Iterable<E> filterIndexed(bool test(int index, E element)) =>
      whereIndexed(test);

  /// alias for [Iterable.map]
  Iterable<R> flatMap<R>(R transform(E element)) => map<R>(transform);

  /// alias for [Iterable.skip]
  Iterable<E> drop(int count) => skip(count);

  /// alias for [Iterable.skip]
  Iterable<E> takeLast(int count) {
    assert(count > -1);
    if (isEmpty) return [];
    if (length <= count) return this;
    return toList().sublist(length - count, length);
  }

  /// alias for [Iterable.skipWhile]
  Iterable<E> dropWhile(bool test(E element)) => skipWhile(test);

  /// alias for [Iterable.skip]
  Iterable<E> dropLast(int count) {
    assert(count > -1);
    if (count == 0) return this;
    if (count >= length) return [];
    return toList().sublist(0, length - count);
  }

  /// alias for [Iterable.every]
  bool all(bool test(E element)) => every(test);

  /// Checks whether no elements of this iterable satisfies [test] or not.
  ///
  /// Checks every element in iteration order, and returns `false` if
  /// any of them make [test] return `true`, otherwise returns `true`.
  bool none(bool test(E element)) {
    for (final element in this) {
      if (test(element)) return false;
    }
    return true;
  }

  /// Returns an iterable containing all elements hat satisfies
  /// the given predicate [test].
  Iterable<E> whereIndexed(bool test(int index, E element)) sync* {
    for (var index = 0; index < length; index++) {
      final element = elementAt(index);
      if (test(index, element)) {
        yield element;
      }
    }
  }

  /// Returns a list containing the results of applying the given [transform]
  /// function to each element and its index in the original List.
  Iterable<R> mapIndexed<R>(R transform(int index, E element)) sync* {
    for (var index = 0; index < length; index++) {
      yield transform(index, elementAt(index));
    }
  }

  /// Performs the given [action] on each element, providing sequential
  /// index with the element.
  void forEachIndexed(void action(int index, E element)) {
    for (var index = 0; index < length; index++) {
      action(index, elementAt(index));
    }
  }

  /// Returns a [Map] containing key-value pairs provided by [transform]
  /// function applied to elements of the given List.
  Map<K, V> associate<K, V>(Pair<K, V> transform(E element)) =>
      associateTo(<K, V>{}, transform);

  /// Populates and returns the [destination] map with key-value pairs
  /// provided by [transform] function applied to each element
  /// of the given iterable.
  Map<K, V> associateTo<K, V>(
      Map<K, V> destination, Pair<K, V> transform(E element)) {
    for (final element in this) {
      destination + transform(element);
    }
    return destination;
  }

  /// Returns a [Map] containing the elements from the given List
  /// indexed by the key returned from [keySelector] function applied
  /// to each element.
  Map<K, E> associateBy<K>(K keySelector(E element)) =>
      associateByTo(<K, E>{}, keySelector);

  /// Populates and returns the [destination] mutable map with key-value pairs,
  /// where key is provided by the [keySelector] function applied to each
  /// element of the given iterable and value is the element itself.
  Map<K, E> associateByTo<K>(Map<K, E> destination, K keySelector(E element)) =>
      {for (final element in this) keySelector(element): element};

  /// Returns a [Map] where keys are elements from the given iterable
  /// and values are produced by the [valueSelector] function
  /// applied to each element.
  Map<E, V> associateWith<V>(V valueSelector(E element)) =>
      associateWithTo(<E, V>{}, valueSelector);

  /// Populates and returns the [destination] map with key-value
  /// pairs for each element of the given iterable,
  /// where key is the element itself and value is provided
  /// by the [valueSelector] function applied to that key.
  Map<E, V> associateWithTo<V>(
          Map<E, V> destination, V valueSelector(E element)) =>
      {for (final element in this) element: valueSelector(element)};

  /// Groups elements of the original iterable by the key returned by
  /// the given [keySelector] function applied to each element
  /// and returns a map where each group key is associated with a
  /// list of corresponding elements.
  Map<K, List<E>> groupBy<K>(K keySelector(E element)) =>
      groupByTo(<K, List<E>>{}, keySelector);

  /// Groups elements of the original iterable by the key returned by
  /// the given [keySelector] function applied to each element
  /// and puts to the [destination] map each group key associated
  /// with a list of corresponding elements.
  Map<K, List<E>> groupByTo<K>(
      Map<K, List<E>> destination, K keySelector(E element)) {
    for (final element in this) {
      final key = keySelector(element);
      final list = destination.putIfAbsent(key, () => []);
      list.add(element);
    }
    return destination;
  }

  /// Returns an iterable containing only distinct elements from
  /// the given iterable.
  Iterable<E> distinct() => toSet().toList();

  /// Returns an iterable containing only elements from the given iterable
  /// having distinct keys returned by the given [selector] function.
  Iterable<E> distinctBy<K>(K selector(E element)) =>
      distinctByTo(<E>[], selector);

  /// Populates and returns the [destination] list with containing only
  /// elements from the given iterable having distinct keys returned by
  /// the given [selector] function.
  Iterable<E> distinctByTo<K>(List<E> destination, K selector(E element)) {
    final set = HashSet<K>();
    for (var element in this) {
      final key = selector(element);
      if (set.add(key)) destination.add(element);
    }
    return destination;
  }

  /// Returns a set containing all elements that are contained by both
  /// [this] iterable and the [other] iterable.
  Iterable<E> intersect(Iterable<E> other) =>
      (toSet()..retainAll(other)).toList();

  /// Returns a set containing all elements that are contained by [this]
  /// iterable and not contained by the [other] iterable.
  Iterable<E> subtract(Iterable<E> other) =>
      (toSet()..removeAll(other)).toList();

  /// Returns an iterable containing all distinct elements from both iterables.
  Iterable<E> union(Iterable<E> other) => (toSet()..addAll(other)).toList();

  /// Returns the number of elements matching the given [predicate].
  int count(bool predicate(E element)) {
    if (isEmpty) return 0;
    var count = 0;
    for (var element in this) {
      if (predicate(element)) ++count;
    }
    return count;
  }

  /// Accumulates value starting with [initialValue] value and applying
  /// [operation] from left to right to current accumulator value and
  /// each element with its index in the original collection.
  T foldIndexed<T>(
      T initialValue, T operation(int index, T previousValue, E element)) {
    var value = initialValue;
    for (var index = 0; index < length; index++) {
      value = operation(index, value, elementAt(index));
    }
    return value;
  }

  /// Accumulates value starting with [initialValue] value and
  /// applying [operation] from right to left to each element
  /// and current accumulator value.
  R foldRight<R>(R initialValue, R operation(R previousValue, E element)) {
    var accumulator = initialValue;
    if (isNotEmpty) {
      for (final element in toList().reversed) {
        accumulator = operation(accumulator, element);
      }
    }
    return accumulator;
  }

  /// Accumulates value starting with [initialValue] value and applying
  /// [operation] from right to left to each element with its index in
  /// the original list and current accumulator value.
  R foldRightIndexed<R>(
      R initialValue, R operation(int index, R previousValue, E element)) {
    var accumulator = initialValue;
    if (isNotEmpty) {
      for (var index = length - 1; index >= 0; index--) {
        accumulator = operation(index, accumulator, elementAt(index));
      }
    }
    return accumulator;
  }

  /// Returns a random element from [this].
  E random() {
    if (isEmpty) return null;
    if (length == 1) return first;
    return elementAt(Random().nextInt(length));
  }

  /// Performs the given [action] on each element and returns the
  /// iterable itself afterwards.
  Iterable<E> onEach(void action(E element)) => this..forEach(action);

  /// Reduces a collection to a single value by iteratively combining elements
  /// of the collection using the provided function with index.
  E reduceIndexed(E combine(int index, E value, E element)) {
    if (isEmpty) return null;
    var value = first;
    for (var index = 1; index < length; index++) {
      value = combine(index, value, elementAt(index));
    }
    return value;
  }

  /// Returns the first element yielding the largest value of the given
  /// function or `null` if there are no elements.
  E maxBy<R extends Comparable>(R selector(E element)) {
    if (isEmpty) return null;
    if (length == 1) return first;
    var maxElement = first;
    var maxValue = selector(maxElement);
    for (final element in this) {
      final value = selector(element);
      if (maxValue < value) {
        maxValue = value;
        maxElement = element;
      }
    }
    return maxElement;
  }

  /// Returns the last element yielding the largest value of the given
  /// function or `null` if there are no elements.
  E maxByLast<R extends Comparable>(R selector(E element)) {
    if (isEmpty) return null;
    if (length == 1) return first;
    var maxElement = first;
    var maxValue = selector(maxElement);
    for (final element in this) {
      final value = selector(element);
      if (maxValue <= value) {
        maxValue = value;
        maxElement = element;
      }
    }
    return maxElement;
  }

  // Returns the first element yielding the largest value of the given
  /// function or `null` if there are no elements.
  E minBy<R extends Comparable>(R selector(E element)) {
    if (isEmpty) return null;
    if (length == 1) return first;
    var minElement = first;
    var minValue = selector(minElement);
    for (final element in this) {
      final value = selector(element);
      if (minValue > value) {
        minValue = value;
        minElement = element;
      }
    }
    return minElement;
  }

  // Returns the last element yielding the largest value of the given
  /// function or `null` if there are no elements.
  E minByLast<R extends Comparable>(R selector(E element)) {
    if (isEmpty) return null;
    if (length == 1) return first;
    var minElement = first;
    var minValue = selector(minElement);
    for (final element in this) {
      final value = selector(element);
      if (minValue >= value) {
        minValue = value;
        minElement = element;
      }
    }
    return minElement;
  }

  // Returns the first element yielding the largest value of the given
  /// function or `null` if there are no elements.
  R sumBy<R extends num>(R selector(E element)) => fold<R>(
      (R == int ? 0 : 0.0) as R,
      (previousValue, element) => previousValue + selector(element));

  // Returns the first element yielding the largest value of the given
  /// function or `null` if there are no elements.
  double averageBy<R extends num>(R selector(E element)) {
    if (isEmpty) return 0;
    return sumBy(selector) / length;
  }
}
