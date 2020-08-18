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
  String get capitalized => characters.first.toUpperCase() + substring(1);

  /// Returns [this] as [int] or null
  int toIntOrNull() => int.tryParse(this);

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
      prefix + this + (suffix ?? prefix);

// TODO: unwrap
}
