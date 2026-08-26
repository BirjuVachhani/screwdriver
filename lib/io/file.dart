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

/// ASCII/UTF-8 byte value for the line-feed character `\n`.
const int _newline = 0x0A;

/// Flattens [chunks] into a single [Uint8List], decodes it with [encoding],
/// splits on newlines, and strips a trailing empty string produced by a
/// trailing `\n` (so callers never receive a phantom empty last line).
///
/// Chunks must be in file order (earliest bytes first). Pre-computing the
/// total size allows a single fixed-size allocation instead of a growable
/// list, and [Uint8List] stores one byte per element rather than the eight
/// bytes that a boxed [List<int>] uses.
List<String> _toLines(Iterable<List<int>> chunks, Encoding encoding) {
  final totalSize = chunks.fold(0, (sum, c) => sum + c.length);
  final buffer = Uint8List(totalSize);
  var offset = 0;
  for (final chunk in chunks) {
    buffer.setRange(offset, offset + chunk.length, chunk);
    offset += chunk.length;
  }
  final lines = encoding.decode(buffer).split('\n');
  if (lines.isNotEmpty && lines.last.isEmpty) lines.removeLast();
  return lines;
}

/// Extensions on [File] providing convenience methods for common I/O tasks:
/// appending content, copying, clearing, watching, reading byte ranges,
/// and streaming or tail-reading lines.
extension FileScrewdriver on File {
  /// Returns a [Future] containing a [bool] indicating whether
  /// [this] file is empty or not.
  Future<bool> get isEmpty async => await length() == 0;

  /// Returns true if [this] file is empty.
  bool get isEmptySync => lengthSync() == 0;

  /// Appends [value] to [this] file using UTF-8 encoding.
  void operator <<(String value) => appendStringSync(value);

  /// Appends the content of [file] to [this] file.
  void operator +(File file) => appendFromSync(file);

  /// Asynchronously copies the content of [this] to [other], overwriting
  /// [other] if it already exists.
  Future<void> copyTo(File other) async {
    final sink = other.openWrite();
    await sink.addStream(openRead());
    await sink.close();
  }

  /// Synchronously copies the content of [this] to [other], overwriting
  /// [other] if it already exists.
  ///
  /// Uses a stream subscription internally; any error during the copy closes
  /// [other] and rethrows.
  void copyToSync(File other) {
    final otherSink = other.openSync(mode: FileMode.write);
    final thisStream = openRead();
    StreamSubscription<List<int>>? sub;
    sub = thisStream.listen(
      (data) => otherSink.writeFromSync(data),
      onDone: () {
        otherSink.close();
        sub?.cancel();
      },
      onError: (Object e) {
        otherSink.close();
        sub?.cancel();
        throw e;
      },
    );
  }

  /// Asynchronously truncates [this] file to zero bytes, leaving it empty.
  ///
  /// If [flush] is true, the OS buffer is flushed to disk before the returned
  /// [Future] completes.
  Future<void> clear({bool flush = false}) => writeAsBytes([], flush: flush);

  /// Synchronously truncates [this] file to zero bytes, leaving it empty.
  ///
  /// If [flush] is true, the OS buffer is flushed to disk before returning.
  void clearSync({bool flush = false}) => writeAsBytesSync([], flush: flush);

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

  /// Appends [value] to [this] file using [encoding] (defaults to UTF-8).
  Future<void> appendString(String value, {Encoding encoding = utf8}) async {
    final fileAccess = await open(mode: FileMode.writeOnlyAppend);
    await fileAccess.writeString(value, encoding: encoding);
    await fileAccess.flush();
    await fileAccess.close();
  }

  /// Synchronously appends [value] to [this] file using [encoding] (defaults to UTF-8).
  void appendStringSync(String value, {Encoding encoding = utf8}) {
    final fileAccess = openSync(mode: FileMode.writeOnlyAppend);
    fileAccess.writeStringSync(value, encoding: encoding);
    fileAccess.flushSync();
    fileAccess.closeSync();
  }

  /// Appends [value] followed by a newline to [this] file using [encoding]
  /// (defaults to UTF-8).
  Future<void> appendStringLine(String value, {Encoding encoding = utf8}) async {
    final sink = openWrite(mode: FileMode.writeOnlyAppend, encoding: encoding);
    sink.writeln(value);
    await sink.flush();
    await sink.close();
  }

  /// Asynchronously appends the raw [value] bytes to [this] file.
  Future<void> appendBytes(List<int> value) async {
    final fileAccess = await open(mode: FileMode.writeOnlyAppend);
    await fileAccess.writeFrom(value);
    await fileAccess.flush();
    await fileAccess.close();
  }

  /// Synchronously appends the raw [value] bytes to [this] file.
  void appendBytesSync(List<int> value) {
    final fileAccess = openSync(mode: FileMode.writeOnlyAppend);
    fileAccess.writeFromSync(value);
    fileAccess.flushSync();
    fileAccess.closeSync();
  }

  /// Asynchronously appends the entire content of [file] to [this] file.
  Future<void> appendFrom(File file) async {
    final sink = openWrite(mode: FileMode.writeOnlyAppend);
    await sink.addStream(file.openRead());
    await sink.flush();
    await sink.close();
  }

  /// Synchronously appends the entire content of [file] to [this] file.
  void appendFromSync(File file) {
    final fileAccess = openSync(mode: FileMode.writeOnlyAppend);
    fileAccess.writeFromSync(file.readAsBytesSync().toList());
    fileAccess.flushSync();
    fileAccess.closeSync();
  }

  /// Creates [this] file if it does not already exist and returns it.
  ///
  /// If [recursive] is true, any missing parent directories are created.
  /// If [exclusive] is true, throws a [FileSystemException] if the file
  /// already exists.
  Future<File> createIfMissing({bool recursive = false, bool exclusive = false}) async {
    if (!await exists()) {
      return await create(recursive: recursive, exclusive: exclusive);
    }
    return this;
  }

  /// Synchronously creates [this] file if it does not already exist.
  ///
  /// If [recursive] is true, any missing parent directories are created.
  /// If [exclusive] is true, throws a [FileSystemException] if the file
  /// already exists.
  void createIfMissingSync({bool recursive = false, bool exclusive = false}) {
    if (!existsSync()) createSync(recursive: recursive, exclusive: exclusive);
  }

  /// Deletes [this] file if it exists and returns the deleted entity, or
  /// returns [this] unchanged if the file did not exist.
  ///
  /// If [recursive] is true, any child files or directories are also deleted.
  Future<FileSystemEntity> deleteIfExists({bool recursive = false}) async {
    if (await exists()) return await delete(recursive: recursive);
    return this;
  }

  /// Synchronously deletes [this] file if it exists.
  ///
  /// If [recursive] is true, any child files or directories are also deleted.
  void deleteIfExistsSync({bool recursive = false}) {
    if (existsSync()) deleteSync(recursive: recursive);
  }

  /// Synchronously reads a byte range from [this] file.
  ///
  /// Returns a list of bytes from position [start] (inclusive) to [end]
  /// (exclusive). Both [start] and [end] are zero-based byte offsets.
  ///
  /// Throws a [RangeError] if [start] is negative, [end] is negative, or
  /// [end] is less than [start].
  List<int> readBytesRange(int start, int end) {
    RangeError.checkNotNegative(start, 'start');
    RangeError.checkNotNegative(end, 'end');
    if (end < start) {
      throw RangeError.range(end, start, null, 'end', 'end must be >= start');
    }
    final fileAccess = openSync(mode: FileMode.read);
    try {
      fileAccess.setPositionSync(start);
      return fileAccess.readSync(end - start);
    } finally {
      fileAccess.closeSync();
    }
  }

  /// Streams the content of [this] file as lines of text.
  ///
  /// Each item emitted by the returned stream is one line from the file,
  /// with line endings stripped.
  ///
  /// [take] limits the number of lines returned. If null, all lines are
  /// emitted. If 0, an empty stream is returned.
  ///
  /// [decoder] overrides the default UTF-8 decoder used to convert raw bytes
  /// to a string before splitting on line boundaries.
  ///
  /// Throws an [ArgumentError] if [take] is negative.
  Stream<String> streamLines({int? take, Converter<List<int>, String>? decoder}) {
    if (take != null) {
      if (take < 0) throw ArgumentError.value(take, 'take', 'must not be negative');
      if (take == 0) return Stream.empty();
    }
    final stream = LineSplitter().bind((decoder ?? utf8.decoder).bind(openRead()));
    return take == null ? stream : stream.take(take);
  }

  /// Returns the last [count] lines of [this] file.
  ///
  /// Scans backwards from the end of the file in chunks to locate newline
  /// boundaries, then forward-reads and decodes only the relevant byte slice.
  /// This avoids loading the entire file into memory.
  ///
  /// [encoding] must be an encoding where `\n` is always the single byte
  /// `0x0A` and never a continuation byte — UTF-8, ASCII, and Latin-1 all
  /// qualify. UTF-16 is not supported.
  ///
  /// A trailing newline is not counted as an extra empty line, consistent
  /// with [streamLines].
  ///
  /// Throws an [ArgumentError] if [count] is negative.
  List<String> tailLines(int count, {Encoding encoding = utf8}) {
    if (count < 0) throw ArgumentError.value(count, 'count', 'must not be negative');
    if (count == 0) return [];

    final fileLength = lengthSync();
    if (fileLength == 0) return [];

    final fileAccess = openSync(mode: FileMode.read);
    try {
      int newlinesFound = 0;
      int pos = fileLength;
      const chunkSize = 4096;
      // Chunks are stored in reverse-read order: index 0 is the last chunk
      // of the file, index 1 the one before it, and so on.
      final chunks = <List<int>>[];

      while (pos > 0) {
        final readFrom = (pos - chunkSize).clamp(0, pos);
        fileAccess.setPositionSync(readFrom);
        final bytes = fileAccess.readSync(pos - readFrom);

        for (int i = bytes.length - 1; i >= 0; i--) {
          if (bytes[i] == _newline) {
            // A trailing newline marks the end of the last line, not the
            // start of a new empty one — skip it without counting.
            if (readFrom + i == fileLength - 1) continue;
            newlinesFound++;
            if (newlinesFound == count) {
              // All needed bytes are already in memory. Take the tail of the
              // current chunk (everything after this newline), then append
              // previously cached chunks in file order (reverse of read order).
              return _toLines([bytes.sublist(i + 1), ...chunks.reversed], encoding);
            }
          }
        }

        chunks.add(bytes);
        pos = readFrom;
      }

      // Fewer lines than [count] in the file — return everything.
      return _toLines(chunks.reversed, encoding);
    } finally {
      fileAccess.closeSync();
    }
  }
}
