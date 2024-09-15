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

/// provides extensions for map
extension MapScrewdriver<K, V> on Map<K, V> {
  /// Allows to add a record entry to [this].
  void operator +((K, V) entry) => this[entry.$1] = entry.$2;

  /// Allows to add [MapEntry] to [this].
  void operator <<(MapEntry<K, V> entry) => this[entry.key] = entry.value;

  /// Converts [this] map into a JSON string.
  String toJson() => json.encode(this);

  /// Returns a new [Map] with the same keys and values as [this] except
  /// keys present [keys].
  Map<K, V> except(Iterable<K> keys) =>
      Map.fromEntries(entries.where((entry) => !keys.contains(entry.key)));

  /// Returns a new [Map] with the same keys and values but only contains
  /// the keys present in [keys].
  Map<K, V> only(Iterable<K> keys) => {
        for (final MapEntry(:key, :value) in entries)
          if (keys.contains(key)) key: value
      };

  /// Returns a new [Map] with the same keys and values as [this] where the
  /// key-value pair satisfies the [test] function. Similar to [Iterable.where].
  Map<K, V> where(bool Function(K key, V value) test) => {
        for (final MapEntry(:key, :value) in entries)
          if (test(key, value)) key: value
      };

  /// Returns a new [Map] with the same keys and values as [this] where the
  /// key-value pair doesn't satisfy the [test] function.
  Map<K, V> whereNot(bool Function(K key, V value) test) => {
        for (final MapEntry(:key, :value) in entries)
          if (!test(key, value)) key: value
      };

  /// Similar to [Map.entries] but returns an iterable of records instead of
  /// [MapEntry].
  ///
  /// One of the use-cases includes iterating over the collection with access
  /// to the key of each item in a for loop.
  /// e.g.
  ///
  /// for (final (key, value) in map.records) {
  ///   print('$key: $value');
  /// }
  Iterable<(K key, V value)> get records sync* {
    for (final entry in entries) {
      yield (entry.key, entry.value);
    }
  }

  /// Removes all the keys present in [keys] from [this] map. If [this] is
  /// an instance of [UnmodifiableMapBase], it will return a new map with
  /// the same keys and values except the keys present in [keys].
  Map<K, V> removeKeys(Iterable<K> keys) {
    if (this is UnmodifiableMapBase) return except(keys);
    return this..removeWhere((key, value) => keys.contains(key));
  }

  /// Returns a new [Map] with the keys and values reversed such that
  /// the values become keys and keys become values.
  ///
  /// Note: In case of duplicate values, the last key-value pair will be persisted
  /// in the new map and the rest will be discarded.
  Map<V, K> get reversed =>
      Map.fromEntries(entries.map((e) => MapEntry(e.value, e.key)));

  /// Finds the first key-value pair where the value is equal to [value].
  MapEntry<K, V> findByValue(V value) =>
      entries.firstWhere((element) => element.value == value);

  /// Finds the first key-value pair where the value is equal to [value].
  /// Returns `null` if no such key-value pair is found.
  MapEntry<K, V>? findByValueOrNull(V value) =>
      entries.firstWhereOrNull((element) => element.value == value);
}
