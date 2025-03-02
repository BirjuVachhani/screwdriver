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
  /// using [characters] allows to handle unicode characters that are more
  /// than 1 byte long. e.g. emojis.
  String get capitalized {
    if (isBlank) return this;
    if (characters.length == 1) return toUpperCase();
    return characters.first.toUpperCase() + characters.skip(1).toString();
  }

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
          r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$",
          caseSensitive: false)
      .hasMatch(this);

  /// Returns a reversed string of [this]
  String get reversed => characters.toList().reversed.join();

  /// Whether [this] is a valid regular expression or not. Creating an instance
  /// of [RegExp] with invalid patten throws a [FormatException]. This allows
  /// to check if a string is a valid regex pattern or not without throwing.
  bool get isRegex {
    try {
      RegExp(this);
    } on FormatException catch (_) {
      return false;
    }
    return true;
  }

  /// This would tokenize [this] into words by breaking it with space.
  List<String> get words =>
      trim().split(' ').where((element) => element.isNotBlank).toList();

  /// Toggles the case of the characters
  String get toggledCase => characters
      .map((e) => e.toUpperCase() == e ? e.toLowerCase() : e.toUpperCase())
      .join();

  /// Returns the index of the last character in [this].
  int get lastIndex => length - 1;

  /// Returns [this] as [int] or null
  /// Radix be between 2..36
  int? toIntOrNull({int? radix}) => int.tryParse(this, radix: radix);

  /// Returns [this] as [double] or null
  double? toDoubleOrNull() => double.tryParse(this);

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
  bool? toBoolOrNull() {
    if (toLowerCase() == 'true') return true;
    return toLowerCase() != 'false' ? toIntOrNull()?.asBool : false;
  }

  /// wraps [this] between [prefix] and [suffix].
  /// Uses [prefix] as [suffix] if [suffix] is null.
  /// e.g.
  ///       'hello'.wrap("*");          // returns *hello*
  ///       'html'.wrap('<','>');       // returns `<html>`
  String wrap(String prefix, [String? suffix]) =>
      (prefix) + this + (suffix ?? prefix);

  /// unwraps [this] between [prefix] and [suffix].
  /// Uses [prefix] as [suffix] if [suffix] is null.
  /// e.g.
  ///       '*hello*'.unwrap("*");          // returns hello
  ///       `<html>`.unwrap('<','>');       // returns html
  String unwrap(String prefix, [String? suffix]) {
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

  /// Tries to convert [this] into a [DateTime].
  DateTime? toDateTimeOrNull() => DateTime.tryParse(this);

  /// Converts [this] to a JSON map.
  Map<String, dynamic> parseJson() => json.decode(this) as Map<String, dynamic>;

  /// Converts [this] to a JSON map.
  List<Map<String, dynamic>> parseJsonArray() =>
      List<Map<String, dynamic>>.from(json.decode(this) as Iterable);

  /// Returns count of given [match] in this string
  int count(String match, {bool caseSensitive = true}) {
    var count = 0;
    for (final char in characters) {
      if (caseSensitive ? char == match : char.equalsIgnoreCase(match)) {
        count++;
      }
    }
    return count;
  }

  /// alias for [indexOf]
  int find(Pattern match) => indexOf(match);

  /// Makes all the words capitalized in this string
  /// Note that this does not work properly if the first character of any
  /// word is an Emoji character.
  String title() => split(' ').map((e) => e.capitalized).join(' ');

  /// Compares two strings ignoring the case.
  bool equalsIgnoreCase(String matcher) =>
      toLowerCase() == matcher.toLowerCase();

  /// An alternative to [String.splitMapJoin] which provides access to
  /// [RegExpMatch] instead of [Match].
  /// [Match] does not provide access to named groups. [RegExpMatch] does.
  /// Reference: https://github.com/dart-lang/sdk/issues/52721
  String splitMapJoinRegex(
    RegExp regex, {
    String Function(RegExpMatch match)? onMatch,
    String Function(String text)? onNonMatch,
  }) {
    return splitMapJoin(
      regex,
      onMatch:
          onMatch != null ? (match) => onMatch(match as RegExpMatch) : null,
      onNonMatch: onNonMatch,
    );
  }

  /// An alternative to [String.splitMapJoin] which allows to return mapped
  /// values from [onMatch] and [onNonMatch] callbacks unlike the original
  /// [String.splitMapJoin] which only allows to return [String] values.
  ///
  /// This uses [splitMapJoinRegex] internally which provides access to
  /// [RegExpMatch] instead of [Match] providing access to named groups as well.
  List<R> splitMap<R>(
    RegExp regex, {
    R? Function(RegExpMatch match)? onMatch,
    R? Function(String text)? onNonMatch,
  }) {
    List<R> list = [];
    splitMapJoinRegex(
      regex,
      onMatch: onMatch != null
          ? (match) {
              onMatch(match);
              final result = onMatch(match);
              if (result != null) list.add(result);
              return match[0]!;
            }
          : null,
      onNonMatch: onNonMatch != null
          ? (nonMatch) {
              final result = onNonMatch(nonMatch);
              if (result != null) list.add(result);
              return nonMatch;
            }
          : null,
    );
    return list;
  }

  /// Prepends given [prefix] to [this] if it does not already start with it.
  /// If [force] is true, it will append the [prefix] regardless of whether
  /// [this] already starts with it or not.
  String prefix(String prefix, {bool force = false}) =>
      startsWith(prefix) && !force ? this : '$prefix$this';

  /// Appends given [suffix] to [this] if it does not already end with it.
  /// If [force] is true, it will append the [suffix] regardless of whether
  /// [this] already ends with it or not.
  String suffix(String suffix, {bool force = false}) =>
      endsWith(suffix) && !force ? this : '$this$suffix';

  /// Converts [this] string to bytes. Default encoding is UTF-8.
  /// Use [toUtf16Bytes] for UTF-16 encoding.
  List<int> toBytes() => utf8.encode(this);

  /// Converts [this] string to bytes using UTF-16 encoding. Use [toBytes]
  /// for UTF-8 encoding.
  List<int> toUtf16Bytes() => codeUnits.toList();

  /// Converts [this] string to bytes using Unicode encoding.
  List<int> toUnicodeBytes() => runes.toList();

  /// Returns the substring after the first occurrence of [pattern].
  /// Returns empty string if [pattern] is not found.
  String takeAfter(Pattern pattern) {
    final Match? match = pattern.allMatches(this).firstOrNull;
    return match == null ? '' : substring(match.end);
  }

  /// Returns the substring before the first occurrence of [pattern].
  /// Returns empty string if [pattern] is not found.
  String takeBefore(Pattern pattern) {
    final Match? match = pattern.allMatches(this).firstOrNull;
    return match == null ? '' : substring(0, match.start);
  }

  /// Returns the substring after the last occurrence of [pattern].
  /// Returns empty string if [pattern] is not found.
  String takeAfterLast(Pattern pattern) {
    final Match? match = pattern.allMatches(this).lastOrNull;
    return match == null ? '' : substring(match.end);
  }

  /// Returns the substring before the last occurrence of [pattern].
  /// Returns empty string if [pattern] is not found.
  String takeBeforeLast(Pattern pattern) {
    final Match? match = pattern.allMatches(this).lastOrNull;
    return match == null ? '' : substring(0, match.start);
  }

  /// Returns the substring between the first occurrence of [start] and [end].
  /// Returns empty string if [start] or [end] is not found.
  String takeBetween(Pattern start, [Pattern? end]) {
    final Match? startMatch = start.allMatches(this).firstOrNull;
    if (startMatch == null) return '';
    final Match? endMatch =
        (end ?? start).allMatches(this, startMatch.end).firstOrNull;
    if (endMatch == null) return '';
    return substring(startMatch.end, endMatch.start);
  }

  /// Returns the substring with the first [count] characters.
  String take(int count) => characters.take(count).toString();

  /// Returns the substring with the last [count] characters.
  String takeLast(int count) => characters.takeLast(count).toString();
}

/// Provides extensions for nullable [String].
extension NullableStringScrewdriver on String? {
  /// Returns true if [this] is either null or empty string.
  bool get isNullOrEmpty {
    var value = this;
    return value == null || value.isEmpty;
  }

  /// Returns true if [this] is neither null nor empty string.
  bool get isNotNullOrEmpty {
    var value = this;
    return value != null && value.isNotEmpty;
  }

  /// Returns true if [this] is either null or blank string.
  bool get isNullOrBlank {
    var value = this;
    return value == null || value.isBlank;
  }

  /// Returns true if [this] is neither null nor blank string.
  bool get isNotNullOrBlank {
    var value = this;
    return value != null && value.isNotBlank;
  }

  /// Alias for [isNotNullOrEmpty]
  bool get hasContent => isNotNullOrEmpty;

  /// Returns [this] if it is not null, otherwise returns empty string.
  String get orEmpty => this ?? '';

  /// Returns true if this string exactly matches the given [pattern].
  bool matchesExactly(Pattern pattern) => pattern.hasExactMatch(this);
}

/// Allows to build a string with [StringBuffer] using [builder].
String buildString(void Function(StringBuffer buffer) builder) {
  final buffer = StringBuffer();
  builder(buffer);
  return buffer.toString();
}

/// Generates a random string of given [length].
/// [alphabets] decides whether to include alphabets or not.
/// [digits] decides whether to include digits or not.
/// [specialChars] decides whether to include special characters or not.
///
/// [seed] is used to seed the RNG. Use the same seed to generate the same
/// sequence again.
///
/// [pool] is a custom set of characters to use for generating the string.
/// [alphabets], [digits], and [specialChars] are ignored if [pool] is provided
/// and not empty.
String randomString(
  int length, {
  bool alphabets = true,
  bool digits = true,
  bool specialChars = false,
  int? seed,
  String? pool,
}) {
  if (length <= 0) return '';

  final StringBuffer buffer = StringBuffer();
  if (pool == null || pool.isEmpty) {
    if (alphabets) {
      buffer.write('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');
    }
    if (digits) buffer.write('0123456789');
    if (specialChars) buffer.write('!@#\$%^&*()_+-=[]{}|;:,.<>?');

    pool = buffer.toString();
    buffer.clear();
  }

  if (pool.isEmpty) {
    throw ArgumentError('At least one character set must be enabled');
  }

  final Characters poolChars = Characters(pool);

  final random = Random(seed);
  for (int index = 0; index < length; index++) {
    buffer.write(poolChars.elementAt(random.nextInt(poolChars.length)));
  }
  return buffer.toString();
}
