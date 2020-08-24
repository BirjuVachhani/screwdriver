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
// Created Date: August 18, 2020

part of '../screwdriver.dart';

/// Provides extensions for [String].
extension StringScrewdriver on String {
  /// Returns true if [this] only contains white-spaces.
  bool get isBlank => trim().isEmpty;

  /// Returns true if [this] contains characters other than white-spaces.
  bool get isNotBlank => trim().isNotEmpty;

  /// Converts the first character of [this] to upper case.
  String get capitalized {
    if (isBlank) return this;
    if (length == 1) return toUpperCase();
    return characters.first.toUpperCase() + substring(1);
  }

  /// Returns [this] as [int] or null
  /// Radix be between 2..36
  int toIntOrNull({int radix}) => int.tryParse(this, radix: radix);

  /// Returns [this] as [double] or null
  double toDoubleOrNull() => double.tryParse(this);

  /// Returns true only if [this] equals to be true (insensitive of case) or
  /// if a non-zero integer.
  ///
  /// e.g
  ///         'true'.toBoolOrNull()             // returns true
  ///         'TRUE'.toBoolOrNull()             // returns true
  ///         'FALSE'.toBoolOrNull()            // returns false
  ///         'something'.toBoolOrNull()        // returns null
  ///         '1'.toBoolOrNull()                // returns true
  ///         '0'.toBoolOrNull()                // returns false
  bool toBoolOrNull() {
    if (toLowerCase() == 'true') return true;
    return toLowerCase() != 'false' ? toIntOrNull()?.asBool : false;
  }

  /// wraps [this] between [prefix] and [suffix].
  /// Uses [prefix] as [suffix] if [suffix] is null.
  /// e.g.
  ///       'hello'.wrap("*");          // returns *hello*
  ///       'html'.wrap('<','>');       // returns <html>
  String wrap(String prefix, [String suffix]) =>
      (prefix ?? '') + this + (suffix ?? prefix ?? '');

  /// unwraps [this] between [prefix] and [suffix].
  /// Uses [prefix] as [suffix] if [suffix] is null.
  /// e.g.
  ///       '*hello*'.unwrap("*");          // returns hello
  ///       '<html>'.unwrap('<','>');       // returns html
  String unwrap(String prefix, [String suffix]) {
    prefix ??= '';
    suffix ??= prefix;
    if (startsWith(prefix)) {
      return substring(
          prefix.length, endsWith(suffix) ? length - suffix.length : length);
    }
    return endsWith(suffix) ? substring(0, length - suffix.length) : this;
  }

  /// removes [prefix] from [this] and returns remaining.
  /// e.g.
  ///       'hello-world'.removePrefix('hello');    // returns -world
  ///       'hello-world'.removePrefix('world');    // returns hello-world
  String removePrefix(String prefix) =>
      startsWith(prefix) ? substring(prefix.length) : this;

  /// removes [suffix] from [this] and returns remaining.
  /// e.g.
  ///       'hello-world'.removeSuffix('world');    // returns hello-
  ///       'hello-world'.removeSuffix('hello');    // returns hello-world
  String removeSuffix(String suffix) =>
      endsWith(suffix) ? substring(0, length - suffix.length) : this;

  /// Returns true if [this] is a binary string which only contains 1's and 0's
  bool get isBinary => toIntOrNull(radix: 2) != null;

  /// Returns true if [this] is a hex string which only
  /// contains 0-9 and A-F | a-f
  bool get isHexadecimal => toIntOrNull(radix: 16) != null;

  /// Returns true if [this] is a hex string which only
  /// contains 0-7
  bool get isOctal => toIntOrNull(radix: 8) != null;

  /// Returns true if [this] is an int
  bool get isDecimal => toIntOrNull() != null;

  /// Returns true if [this] is a double
  bool get isDouble => toDoubleOrNull() != null;

  /// Returns true if [this] happens to be an email
  /// This uses RFC822 email validation specs which is widely accepted.
  /// check this: https://regexr.com/2rhq7
  /// Original Ref: https://www.ietf.org/rfc/rfc822.txt
  bool get isEmail => RegExp(
          r"^[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$")
      .hasMatch(this);

  /// Returns a reversed string of [this]
  String get reversed => characters.toList().reversed.join();

  /// Tries to convert [this] into a [DateTime].
  DateTime toDateTimeOrNull() => DateTime.tryParse(this);

  /// This would tokenize [this] into words by breaking it with space.
  List<String> get words =>
      trim().split(' ').where((element) => element.isNotBlank).toList();

  /// Converts [this] to a JSON map.
  Map<String, dynamic> parseJson() => json.decode(this);
}
