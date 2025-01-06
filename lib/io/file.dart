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
// Created Date: August 29, 2020

part of '../screwdriver_io.dart';

/// provides extensions for [File]
extension FileScrewdriver on File {
  /// Returns a [Future] containing a [bool] indicating whether
  /// [this] file is empty or not.
  Future<bool> get isEmpty async => await length() == 0;

  /// Returns true if [this] file is empty
  bool get isEmptySync => lengthSync() == 0;

  /// operator that allows to append [value] string at the end of the file
  /// using provided UTF-8 encoding.
  void operator <<(String value) => appendStringSync(value);

  /// Allows to append content of [file] to [this].
  void operator +(File file) => appendFromSync(file);

  /// Copies content of [this] to [other] file.
  Future<void> copyTo(File other) async {
    final sink = other.openWrite();
    await sink.addStream(openRead());
    await sink.close();
  }

  /// Asynchronously flushes all the data in [this] file leaving it to be empty.
  Future<void> clear() => writeAsString('');

  /// Synchronously flushes all the data in [this] file leaving it to be empty.
  void clearSync() => writeAsStringSync('');

  /// Calls [block] whenever the [this] file is modified.
  /// Returns [StreamSubscription] which allows to cancel the listener.
  StreamSubscription<FileSystemEvent> onModified(void Function() block) {
    return watch(events: FileSystemEvent.modify).listen((event) => block());
  }

  /// Calls [block] whenever the [this] file is deleted.
  /// Returns [StreamSubscription] which allows to cancel the listener.
  StreamSubscription<FileSystemEvent> onDeleted(void Function() block) {
    return watch(events: FileSystemEvent.delete).listen((event) => block());
  }

  /// Appends [value] string at the end of the file using provided [encoding].
  Future<void> appendString(String value, {Encoding encoding = utf8}) async {
    final fileAccess = await open(mode: FileMode.writeOnlyAppend);
    await fileAccess.writeString(value, encoding: encoding);
    await fileAccess.close();
  }

  /// Appends [value] string at the end of the file using provided [encoding].
  void appendStringSync(String value, {Encoding encoding = utf8}) {
    final fileAccess = openSync(mode: FileMode.writeOnlyAppend);
    fileAccess.writeStringSync(value, encoding: encoding);
    fileAccess.closeSync();
  }

  /// Appends [value] string as a new line at the end of the file using
  /// provided [encoding].
  Future<void> appendStringLine(String value,
      {Encoding encoding = utf8}) async {
    final sink = openWrite(mode: FileMode.writeOnlyAppend, encoding: encoding);
    sink.writeln(value);
    await sink.close();
  }

  /// Appends [value] bytes at the end of the file.
  Future<void> appendBytes(List<int> value) async {
    final fileAccess = await open(mode: FileMode.writeOnlyAppend);
    await fileAccess.writeFrom(value);
    await fileAccess.close();
  }

  /// Appends [value] bytes at the end of the file.
  Future<void> appendBytesSync(List<int> value) async {
    final fileAccess = openSync(mode: FileMode.writeOnlyAppend);
    fileAccess.writeFromSync(value);
    fileAccess.closeSync();
  }

  /// Appends content of [file] at the end of [this] file.
  Future<void> appendFrom(File file) async {
    final sink = openWrite(mode: FileMode.writeOnlyAppend);
    await sink.addStream(file.openRead());
    await sink.close();
  }

  /// Appends content of [file] at the end of [this] file.
  void appendFromSync(File file) {
    final fileAccess = openSync(mode: FileMode.writeOnlyAppend);
    fileAccess.writeFromSync(file.readAsBytesSync().toList());
    fileAccess.closeSync();
  }
}
