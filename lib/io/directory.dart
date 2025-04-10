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
// Created Date: November 14, 2024

part of '../screwdriver_io.dart';

/// Provides extensions for [Directory].
extension DirectoryScrewdriver on Directory {
  /// Creates a [File] instance with the given [fileName] in this directory.
  ///
  /// Example:
  /// ```dart
  /// final dir = Directory('path/to/dir');
  /// final file = dir.file('test.txt'); // Creates File at 'path/to/dir/test.txt'
  /// ```
  File file(String fileName) => File(p.join(path, fileName));

  /// Creates a [Directory] instance representing a subdirectory in this directory.
  ///
  /// Takes up to 5 path components that will be joined together with this directory's path.
  /// All components after [part1] are optional.
  ///
  /// Example:
  /// ```dart
  /// final dir = Directory('path/to/dir');
  /// final subDir = dir.subDir('foo', 'bar'); // Creates Directory at 'path/to/dir/foo/bar'
  /// ```
  Directory subDir(
    String part1, [
    String? part2,
    String? part3,
    String? part4,
    String? part5,
  ]) =>
      Directory(p.join(path, part1, part2, part3, part4, part5));
}
