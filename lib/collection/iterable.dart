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
  /// Returns the second element in the iterable or
  /// returns null if iterable is empty or has only 1 element.
  E? get secondOrNull => length > 1 ? elementAt(1) : null;

  /// Returns the third element in the iterable or
  /// returns null if iterable is empty or has less than 3 elements.
  E? get thirdOrNull => length > 2 ? elementAt(2) : null;

  /// Returns the index of the last element in the collection.
  int get lastIndex => length > 0 ? length - 1 : 0;

  /// Returns true if the collection only has 1 element.
  bool get hasOnlyOneElement => length == 1;

  /// Appends all elements matching the given [predicate] to
  /// the given [destination].
  Iterable<E> filterTo(
      List<E> destination, bool Function(E element) predicate) {
    for (final element in this) {
      if (predicate(element)) destination.add(element);
    }
    return destination;
  }

  /// alias for [Iterable.where]
  Iterable<E> filter(bool Function(E element) predicate) =>
      filterTo(<E>[], predicate);

  /// alias for [whereIndexed] which returns a new lazy Iterable.
  Iterable<E> filterIndexed(bool Function(int index, E element) test) sync* {
    var index = 0;
    for (var element in this) {
      if (test(index++, element)) yield element;
    }
  }

  /// alias for [Iterable.map]
  Iterable<R> flatMap<R>(R Function(E element) transform) => map<R>(transform);

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
  Iterable<E> dropWhile(bool Function(E element) test) => skipWhile(test);

  /// alias for [Iterable.skip]
  Iterable<E> dropLast(int count) {
    assert(count > -1);
    if (count == 0) return this;
    if (count >= length) return [];
    return toList().sublist(0, length - count);
  }

  /// alias for [Iterable.every]
  bool all(bool Function(E element) test) => every(test);

  /// Alias for [associate].
  /// Returns a [Map] containing key-value pairs provided by [transform]
  /// function applied to elements of the given List.
  Map<K, V> toMap<K, V>((K, V) Function(E element) transform) =>
      associate<K, V>(transform);

  /// Returns a [Map] containing key-value pairs provided by [transform]
  /// function applied to elements of the given List.
  Map<K, V> associate<K, V>((K, V) Function(E element) transform) =>
      associateTo(<K, V>{}, transform);

  /// Populates and returns the [destination] map with key-value pairs
  /// provided by [transform] function applied to each element
  /// of the given iterable.
  Map<K, V> associateTo<K, V>(
      Map<K, V> destination, (K, V) Function(E element) transform) {
    for (final element in this) {
      destination + transform(element);
    }
    return destination;
  }

  /// Returns a [Map] containing the elements from the given List
  /// indexed by the key returned from [keySelector] function applied
  /// to each element.
  Map<K, E> associateBy<K>(K Function(E element) keySelector) =>
      associateByTo(<K, E>{}, keySelector);

  /// Populates and returns the [destination] mutable map with key-value pairs,
  /// where key is provided by the [keySelector] function applied to each
  /// element of the given iterable and value is the element itself.
  Map<K, E> associateByTo<K>(
          Map<K, E> destination, K Function(E element) keySelector) =>
      {for (final element in this) keySelector(element): element};

  /// Returns a [Map] where keys are elements from the given iterable
  /// and values are produced by the [valueSelector] function
  /// applied to each element.
  Map<E, V> associateWith<V>(V Function(E element) valueSelector) =>
      associateWithTo(<E, V>{}, valueSelector);

  /// Populates and returns the [destination] map with key-value
  /// pairs for each element of the given iterable,
  /// where key is the element itself and value is provided
  /// by the [valueSelector] function applied to that key.
  Map<E, V> associateWithTo<V>(
          Map<E, V> destination, V Function(E element) valueSelector) =>
      {for (final element in this) element: valueSelector(element)};

  /// Groups elements of the original iterable by the key returned by
  /// the given [keySelector] function applied to each element
  /// and returns a map where each group key is associated with a
  /// list of corresponding elements.
  Map<K, List<E>> groupBy<K>(K Function(E element) keySelector) =>
      groupByTo(<K, List<E>>{}, keySelector);

  /// Groups elements of the original iterable by the key returned by
  /// the given [keySelector] function applied to each element
  /// and puts to the [destination] map each group key associated
  /// with a list of corresponding elements.
  Map<K, List<E>> groupByTo<K>(
      Map<K, List<E>> destination, K Function(E element) keySelector) {
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
  Iterable<E> distinctBy<K>(K Function(E element) selector) =>
      distinctByTo(<E>[], selector);

  /// Populates and returns the [destination] list with containing only
  /// elements from the given iterable having distinct keys returned by
  /// the given [selector] function.
  Iterable<E> distinctByTo<K>(
      List<E> destination, K Function(E element) selector) {
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
  int count(bool Function(E element) predicate) {
    if (isEmpty) return 0;
    var count = 0;
    for (var element in this) {
      if (predicate(element)) ++count;
    }
    return count;
  }

  /// Accumulates value starting with [initialValue] value and
  /// applying [operation] from right to left to each element
  /// and current accumulator value.
  R foldRight<R>(
      R initialValue, R Function(R previousValue, E element) operation) {
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
  R foldRightIndexed<R>(R initialValue,
      R Function(int index, R previousValue, E element) operation) {
    var accumulator = initialValue;
    if (isNotEmpty) {
      for (var index = length - 1; index >= 0; index--) {
        accumulator = operation(index, accumulator, elementAt(index));
      }
    }
    return accumulator;
  }

  /// Returns a random element from [this]. Returns null if no elements
  /// are present.
  E? randomOrNull([Random? random]) {
    if (isEmpty) return null;
    if (length == 1) return first;
    return elementAt((random ?? Random()).nextInt(length));
  }

  /// Returns a random element from [this].
  /// Throws [StateError] if there are no elements in the collection.
  E random([Random? random]) {
    if (isEmpty) throw StateError('no elements');
    if (length == 1) return first;
    return elementAt((random ?? Random()).nextInt(length));
  }

  /// Performs the given [action] on each element and returns the
  /// iterable itself afterwards.
  Iterable<E> onEach(void Function(E element) action) => this..forEach(action);

  /// Returns the first element yielding the largest value of the given
  /// function or `null` if there are no elements.
  E? maxByOrNull<R extends Comparable<dynamic>>(
      R Function(E element) selector) {
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

  /// Returns the first element yielding the largest value of the given
  /// function.
  /// Throws [StateError] if there are no elements in the collection.
  E maxBy<R extends Comparable<dynamic>>(R Function(E element) selector) {
    if (isEmpty) throw StateError('no elements');
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
  E? maxByLastOrNull<R extends Comparable<dynamic>>(
      R Function(E element) selector) {
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

  /// Returns the last element yielding the largest value of the given
  /// function.
  /// Throws [StateError] if there are no elements in the collection.
  E maxByLast<R extends Comparable<dynamic>>(R Function(E element) selector) {
    if (isEmpty) throw StateError('no elements');
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

  /// Returns the first element yielding the smallest value of the given
  /// function or `null` if there are no elements.
  E? minByOrNull<R extends Comparable<dynamic>>(
      R Function(E element) selector) {
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

  /// Returns the first element yielding the smallest value of the given
  /// function.
  /// Throws [StateError] if there are no elements in the collection.
  E minBy<R extends Comparable<dynamic>>(R Function(E element) selector) {
    if (isEmpty) throw StateError('no elements');
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

  /// Returns the last element yielding the smallest value of the given
  /// function or `null` if there are no elements.
  E? minByLastOrNull<R extends Comparable<dynamic>>(
      R Function(E element) selector) {
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

  /// Returns the last element yielding the smallest value of the given
  /// function.
  /// Throws [StateError] if there are no elements in the collection.
  E minByLast<R extends Comparable<dynamic>>(R Function(E element) selector) {
    if (isEmpty) throw StateError('no elements');
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

  /// Returns the sum of all values produced by [selector] function
  /// applied to each element in the collection.
  R sumBy<R extends num>(R Function(E element) selector) => fold<R>(
      (R == int ? 0 : 0.0) as R,
      (previousValue, element) => previousValue + selector(element) as R);

  /// Returns the average of all values produced by [selector] function
  /// applied to each element in the collection.
  double averageBy<R extends num>(R Function(E element) selector) {
    if (isEmpty) return 0;
    return sumBy(selector) / length;
  }

  /// Alias for [subtract].
  Iterable<E> except(Iterable<E> other) => subtract(other);

  /// Returns true if the collection contains all the elements
  /// present in [other] collection.
  bool containsAll(Iterable<E> other) => other.every(contains);

  /// Returns true if the collection doesn't contain any of the elements
  /// present in [other] collection.
  bool containsNone(Iterable<E> other) =>
      none((element) => other.contains(element));

  /// Returns an iterable containing the items with their respective indices
  /// in form of records.
  ///
  /// One of the use-cases includes iterating over the collection with access
  /// to the index of each item in a for loop.
  ///
  /// e.g.
  ///
  /// for (final (index, item) in list.records) {
  ///   print('$index: $item');
  /// }
  ///
  Iterable<(int, E)> get records sync* {
    for (int index = 0; index < length; index++) {
      yield (index, elementAt(index));
    }
  }

  /// Finds an element where the result of [selector] matches the [query].
  /// Throws [StateError] if no element is found.
  E findBy<S>(S query, S Function(E item) selector) {
    for (final item in this) {
      if (selector(item) == query) return item;
    }
    throw StateError('no element found');
  }

  /// Finds an element where the result of [selector] matches the [query].
  /// Returns null if no element is found.
  E? findByOrNull<C>(C query, C Function(E item) selector) {
    for (final item in this) {
      if (selector(item) == query) return item;
    }
    return null;
  }

  /// Finds all elements where the result of [selector] matches the [query].
  /// Returns empty collection if no element is found.
  Iterable<E> findAllBy<S>(S query, S Function(E item) selector) sync* {
    for (final item in this) {
      if (selector(item) == query) yield item;
    }
  }
}

/// provides extensions for nullable Iterable
extension NullableIterableScrewDriver<E> on Iterable<E>? {
  /// Returns true if [this] is either null or empty collection.
  bool get isNullOrEmpty {
    var iterable = this;
    return iterable == null || iterable.isEmpty;
  }

  /// Alias for [isNullOrEmpty].
  /// Returns true if [this] is either null or empty collection.
  bool get isBlank => isNullOrEmpty;

  /// Alias for [isNotNullOrEmpty].
  /// Returns true if [this] is neither null nor empty collection.
  bool get isNotBlank => isNotNullOrEmpty;

  /// Returns true if [this] is neither null nor empty collection.
  bool get isNotNullOrEmpty {
    var iterable = this;
    return iterable != null && iterable.isNotEmpty;
  }
}
