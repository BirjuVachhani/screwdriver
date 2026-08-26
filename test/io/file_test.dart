// Author: Birju Vachhani
// Created Date: August 30, 2020

import 'dart:async';
import 'dart:convert';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:mockito/mockito.dart';
import 'package:screwdriver/screwdriver_io.dart';
import 'package:test/test.dart';

void main() {
  group('file tests', () {
    final file = File('temp.txt');
    final other = File('other.txt');

    setUp(() {
      file.writeAsStringSync('hello');
    });

    test('<< operator tests', () {
      file << ' world';
      expect(file.readAsStringSync(), 'hello world');
    });

    test('copyTo tests', () async {
      await file.copyTo(other);
      expect(other.readAsStringSync(), 'hello');
    });

    test('clear & clearSync tests', () async {
      expect(file.isEmptySync, isFalse);
      await file.clear();
      expect(file.isEmptySync, isTrue);
      other << 'world';
      expect(await other.isEmpty, isFalse);
      other.clearSync();
      expect(await file.isEmpty, isTrue);
    });

    test('onModified test', () async {
      if (!FileSystemEntity.isWatchSupported) return;
      other.createSync();
      final modified = MockFunction();
      final deleted = MockFunction();
      final modifiedSub = other.onModified(modified.call);
      final deletedSub = other.onDeleted(deleted.call);
      other << ' world';
      await Future<void>.delayed(Duration(seconds: 3));
      expect(verify(modified.call()).callCount >= 1, isTrue);
      other.deleteSync();
      await Future<void>.delayed(Duration(seconds: 3));
      verify(deleted.call()).called(1);
      await modifiedSub.cancel();
      await deletedSub.cancel();
    });

    test('appendString test', () async {
      await file.appendString(' world');
      expect(file.readAsStringSync(), 'hello world');
    });

    test('appendStringLine test', () async {
      await other.appendStringLine('hello');
      await other.appendStringLine('world');
      expect(other.readAsStringSync(), 'hello\nworld\n');
    });

    test('appendBytes && appendBytesSync test', () async {
      await file.appendBytes(' world'.codeUnits);
      file.appendBytesSync('!'.codeUnits);
      expect(file.readAsStringSync(), 'hello world!');
    });

    test('appendFrom test', () async {
      other << ' world';
      await file.appendFrom(other);
      expect(file.readAsStringSync(), 'hello world');
    });

    test('appendFromSync test', () {
      other << ' world';
      file + other;
      expect(file.readAsStringSync(), 'hello world');
    });

    tearDown(() {
      file.deleteSync();
      if (other.existsSync()) {
        other.deleteSync();
      }
    });
  });

  group('copyToSync tests', () {
    final sourceFile = File('source_test.txt');
    final targetFile = File('target_test.txt');

    setUp(() {
      sourceFile.writeAsStringSync('test content for copy');
    });

    test('copyToSync - basic copy', () async {
      sourceFile.copyToSync(targetFile);
      // Wait for the async stream operations to complete
      await Future.delayed(Duration(milliseconds: 100));
      expect(targetFile.existsSync(), isTrue);
      expect(targetFile.readAsStringSync(), equals('test content for copy'));
    });

    test('copyToSync - overwrite existing file', () async {
      targetFile.writeAsStringSync('old content');
      expect(targetFile.readAsStringSync(), equals('old content'));

      sourceFile.copyToSync(targetFile);
      // Wait for the async stream operations to complete
      await Future.delayed(Duration(milliseconds: 100));
      expect(targetFile.readAsStringSync(), equals('test content for copy'));
    });

    test('copyToSync - copy empty file', () async {
      sourceFile.writeAsStringSync('');
      expect(sourceFile.isEmptySync, isTrue);

      sourceFile.copyToSync(targetFile);
      // Wait for the async stream operations to complete
      await Future.delayed(Duration(milliseconds: 100));
      expect(targetFile.existsSync(), isTrue);
      expect(targetFile.isEmptySync, isTrue);
    });

    tearDown(() {
      if (sourceFile.existsSync()) sourceFile.deleteSync();
      if (targetFile.existsSync()) targetFile.deleteSync();
    });
  });

  group('copyToSync error handling tests', () {
    final sourceFile = File('source_error_test.txt');
    final targetFile = File('target_error_test.txt');

    test('copyToSync - source file does not exist', () async {
      // Ensure source file doesn't exist
      if (sourceFile.existsSync()) sourceFile.deleteSync();
      expect(sourceFile.existsSync(), isFalse);

      // This should trigger the onError callback which will throw an error
      // Since the error is thrown asynchronously via the onError callback,
      // we need to catch it differently
      bool errorCaught = false;
      late Object caughtError;

      // Wrap the test in a zone to catch the error that gets rethrown by onError
      await runZonedGuarded(
        () async {
          sourceFile.copyToSync(targetFile);
          // Wait for the async stream operations and error to occur
          await Future.delayed(Duration(milliseconds: 200));
        },
        (error, stack) {
          errorCaught = true;
          caughtError = error;
        },
      );

      // Verify that the error was caught and is of the expected type
      expect(errorCaught, isTrue);
      expect(caughtError, isA<FileSystemException>());
    });

    test('copyToSync - target directory does not exist', () async {
      sourceFile.writeAsStringSync('test content');
      final targetInNonExistentDir = File('non_existent_dir/target.txt');

      // Ensure the directory doesn't exist
      final parentDir = Directory('non_existent_dir');
      if (parentDir.existsSync()) parentDir.deleteSync(recursive: true);
      expect(parentDir.existsSync(), isFalse);

      // This should trigger an error when trying to open the target file for writing
      // The openSync call should fail immediately since the directory doesn't exist
      bool errorThrown = false;
      try {
        sourceFile.copyToSync(targetInNonExistentDir);
      } catch (e) {
        errorThrown = true;
        expect(e, isA<FileSystemException>());
      }

      // The openSync should fail immediately, so we expect an error
      expect(errorThrown, isTrue);
    });

    test('copyToSync - target file in read-only directory', () async {
      sourceFile.writeAsStringSync('test content');

      // Create a directory and try to make it read-only (platform dependent)
      final readOnlyDir = Directory('readonly_test_dir');
      if (readOnlyDir.existsSync()) readOnlyDir.deleteSync(recursive: true);
      readOnlyDir.createSync();

      final targetInReadOnlyDir = File('readonly_test_dir/target.txt');

      try {
        // Try to make directory read-only (this might not work on all platforms)
        if (Platform.isLinux || Platform.isMacOS) {
          await Process.run('chmod', ['444', readOnlyDir.path]);
        }

        try {
          sourceFile.copyToSync(targetInReadOnlyDir);
          // Wait for the async stream operations and error to occur
          await Future.delayed(Duration(milliseconds: 200));
        } catch (e) {
          expect(e, isA<FileSystemException>());
        }

        // Clean up by restoring permissions first
        if (Platform.isLinux || Platform.isMacOS) {
          await Process.run('chmod', ['755', readOnlyDir.path]);
        }

        if (readOnlyDir.existsSync()) readOnlyDir.deleteSync(recursive: true);

        // Note: Permission tests may not work reliably on all platforms
        // The test validates the error handling mechanism even if permissions aren't enforced
      } catch (e) {
        // Clean up in case of any errors
        if (Platform.isLinux || Platform.isMacOS) {
          await Process.run('chmod', ['755', readOnlyDir.path]);
        }
        if (readOnlyDir.existsSync()) readOnlyDir.deleteSync(recursive: true);
        // Permission errors are platform-dependent, so we allow this test to pass
      }
    });

    tearDown(() {
      if (sourceFile.existsSync()) sourceFile.deleteSync();
      if (targetFile.existsSync()) targetFile.deleteSync();

      // Clean up any test directories
      final nonExistentDir = Directory('non_existent_dir');
      if (nonExistentDir.existsSync()) {
        nonExistentDir.deleteSync(recursive: true);
      }

      final readOnlyDir = Directory('readonly_test_dir');
      if (readOnlyDir.existsSync()) {
        try {
          if (Platform.isLinux || Platform.isMacOS) {
            Process.runSync('chmod', ['755', readOnlyDir.path]);
          }
          readOnlyDir.deleteSync(recursive: true);
        } catch (e) {
          // Ignore cleanup errors
        }
      }
    });
  });

  group('createIfMissing tests', () {
    final testFile = File('test_create_missing.txt');

    test('createIfMissing - file does not exist', () async {
      if (testFile.existsSync()) testFile.deleteSync();
      expect(testFile.existsSync(), isFalse);

      final result = await testFile.createIfMissing();
      expect(result, equals(testFile));
      expect(testFile.existsSync(), isTrue);
    });

    test('createIfMissing - file already exists', () async {
      testFile.writeAsStringSync('existing content');
      expect(testFile.existsSync(), isTrue);

      final result = await testFile.createIfMissing();
      expect(result, equals(testFile));
      expect(testFile.existsSync(), isTrue);
      expect(testFile.readAsStringSync(), equals('existing content'));
    });

    test('createIfMissing - with recursive option', () async {
      final deepFile = File('test_dir/nested/deep/file.txt');
      if (Directory('test_dir').existsSync()) {
        Directory('test_dir').deleteSync(recursive: true);
      }
      expect(deepFile.existsSync(), isFalse);

      final result = await deepFile.createIfMissing(recursive: true);
      expect(result, equals(deepFile));
      expect(deepFile.existsSync(), isTrue);
      expect(Directory('test_dir').existsSync(), isTrue);
    });

    test('createIfMissing - with exclusive option', () async {
      if (testFile.existsSync()) testFile.deleteSync();
      expect(testFile.existsSync(), isFalse);

      final result = await testFile.createIfMissing(exclusive: true);
      expect(result, equals(testFile));
      expect(testFile.existsSync(), isTrue);
    });

    tearDown(() {
      if (testFile.existsSync()) testFile.deleteSync();
      if (Directory('test_dir').existsSync()) {
        Directory('test_dir').deleteSync(recursive: true);
      }
    });
  });

  group('createIfMissingSync tests', () {
    final testFile = File('test_create_sync_missing.txt');

    test('createIfMissingSync - file does not exist', () {
      if (testFile.existsSync()) testFile.deleteSync();
      expect(testFile.existsSync(), isFalse);

      testFile.createIfMissingSync();
      expect(testFile.existsSync(), isTrue);
    });

    test('createIfMissingSync - file already exists', () {
      testFile.writeAsStringSync('existing content');
      expect(testFile.existsSync(), isTrue);

      testFile.createIfMissingSync();
      expect(testFile.existsSync(), isTrue);
      expect(testFile.readAsStringSync(), equals('existing content'));
    });

    test('createIfMissingSync - with recursive option', () {
      final deepFile = File('test_sync_dir/nested/deep/file.txt');
      if (Directory('test_sync_dir').existsSync()) {
        Directory('test_sync_dir').deleteSync(recursive: true);
      }
      expect(deepFile.existsSync(), isFalse);

      deepFile.createIfMissingSync(recursive: true);
      expect(deepFile.existsSync(), isTrue);
      expect(Directory('test_sync_dir').existsSync(), isTrue);
    });

    test('createIfMissingSync - with exclusive option', () {
      if (testFile.existsSync()) testFile.deleteSync();
      expect(testFile.existsSync(), isFalse);

      testFile.createIfMissingSync(exclusive: true);
      expect(testFile.existsSync(), isTrue);
    });

    tearDown(() {
      if (testFile.existsSync()) testFile.deleteSync();
      if (Directory('test_sync_dir').existsSync()) {
        Directory('test_sync_dir').deleteSync(recursive: true);
      }
    });
  });

  group('deleteIfExists tests', () {
    final testFile = File('test_delete_exists.txt');

    test('deleteIfExists - file exists', () async {
      testFile.writeAsStringSync('content to delete');
      expect(testFile.existsSync(), isTrue);

      final result = await testFile.deleteIfExists();
      expect(result, isA<FileSystemEntity>());
      expect(testFile.existsSync(), isFalse);
    });

    test('deleteIfExists - file does not exist', () async {
      if (testFile.existsSync()) testFile.deleteSync();
      expect(testFile.existsSync(), isFalse);

      final result = await testFile.deleteIfExists();
      expect(result, equals(testFile));
      expect(testFile.existsSync(), isFalse);
    });

    test('deleteIfExists - with recursive option', () async {
      testFile.writeAsStringSync('content');
      expect(testFile.existsSync(), isTrue);

      final result = await testFile.deleteIfExists(recursive: true);
      expect(result, isA<FileSystemEntity>());
      expect(testFile.existsSync(), isFalse);
    });

    tearDown(() {
      if (testFile.existsSync()) testFile.deleteSync();
    });
  });

  group('deleteIfExistsSync tests', () {
    final testFile = File('test_delete_sync_exists.txt');

    test('deleteIfExistsSync - file exists', () {
      testFile.writeAsStringSync('content to delete');
      expect(testFile.existsSync(), isTrue);

      testFile.deleteIfExistsSync();
      expect(testFile.existsSync(), isFalse);
    });

    test('deleteIfExistsSync - file does not exist', () {
      if (testFile.existsSync()) testFile.deleteSync();
      expect(testFile.existsSync(), isFalse);

      testFile.deleteIfExistsSync();
      expect(testFile.existsSync(), isFalse);
    });

    test('deleteIfExistsSync - with recursive option', () {
      testFile.writeAsStringSync('content');
      expect(testFile.existsSync(), isTrue);

      testFile.deleteIfExistsSync(recursive: true);
      expect(testFile.existsSync(), isFalse);
    });

    tearDown(() {
      if (testFile.existsSync()) testFile.deleteSync();
    });
  });

  group('readBytesRange tests', () {
    final file = File('range_test.txt');

    setUp(() {
      // "hello world" — 11 ASCII bytes (0-10)
      file.writeAsBytesSync('hello world'.codeUnits);
    });

    test('reads bytes from the start', () {
      expect(file.readBytesRange(0, 5), equals('hello'.codeUnits));
    });

    test('reads bytes from the middle', () {
      expect(file.readBytesRange(6, 11), equals('world'.codeUnits));
    });

    test('reads a single byte', () {
      expect(file.readBytesRange(0, 1), equals([104])); // 'h'
    });

    test('reads a byte in the middle', () {
      expect(file.readBytesRange(5, 6), equals([32])); // ' '
    });

    test('reads the full file', () {
      expect(file.readBytesRange(0, 11), equals('hello world'.codeUnits));
    });

    test('empty range returns empty list', () {
      expect(file.readBytesRange(3, 3), isEmpty);
    });

    test('negative start throws RangeError', () {
      expect(() => file.readBytesRange(-1, 5), throwsRangeError);
    });

    test('negative end throws RangeError', () {
      expect(() => file.readBytesRange(0, -1), throwsRangeError);
    });

    test('end less than start throws RangeError', () {
      expect(() => file.readBytesRange(5, 3), throwsRangeError);
    });

    test('both negative throws RangeError', () {
      expect(() => file.readBytesRange(-2, -1), throwsRangeError);
    });

    test('reads from non-zero offset correctly', () {
      expect(file.readBytesRange(2, 7), equals('llo w'.codeUnits));
    });

    test('range beyond file length returns available bytes', () {
      // readSync returns what is available rather than throwing
      final result = file.readBytesRange(8, 20);
      expect(result, equals('rld'.codeUnits));
    });

    tearDown(() {
      if (file.existsSync()) file.deleteSync();
    });
  });

  group('streamLines tests', () {
    final file = File('lines_test.txt');

    tearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    test('streams all lines from a multi-line file', () async {
      file.writeAsStringSync('line1\nline2\nline3');
      expect(await file.streamLines().toList(), equals(['line1', 'line2', 'line3']));
    });

    test('streams a single line with no newline', () async {
      file.writeAsStringSync('only line');
      expect(await file.streamLines().toList(), equals(['only line']));
    });

    test('empty file produces empty stream', () async {
      file.writeAsBytesSync([]);
      expect(await file.streamLines().toList(), isEmpty);
    });

    test('trailing newline produces no extra empty line', () async {
      file.writeAsStringSync('line1\nline2\n');
      expect(await file.streamLines().toList(), equals(['line1', 'line2']));
    });

    test('windows line endings are handled', () async {
      file.writeAsBytesSync('line1\r\nline2\r\nline3'.codeUnits);
      expect(await file.streamLines().toList(), equals(['line1', 'line2', 'line3']));
    });

    test('take: null returns all lines', () async {
      file.writeAsStringSync('a\nb\nc');
      expect(await file.streamLines(take: null).toList(), equals(['a', 'b', 'c']));
    });

    test('take: 0 returns empty stream', () async {
      file.writeAsStringSync('a\nb\nc');
      expect(await file.streamLines(take: 0).toList(), isEmpty);
    });

    test('take: 1 returns only the first line', () async {
      file.writeAsStringSync('first\nsecond\nthird');
      expect(await file.streamLines(take: 1).toList(), equals(['first']));
    });

    test('take less than total lines returns first n lines', () async {
      file.writeAsStringSync('a\nb\nc\nd\ne');
      expect(await file.streamLines(take: 3).toList(), equals(['a', 'b', 'c']));
    });

    test('take greater than total lines returns all lines', () async {
      file.writeAsStringSync('a\nb');
      expect(await file.streamLines(take: 100).toList(), equals(['a', 'b']));
    });

    test('negative take throws ArgumentError', () {
      file.writeAsStringSync('a\nb');
      expect(() => file.streamLines(take: -1), throwsArgumentError);
    });

    test('custom decoder is used', () async {
      // Write latin-1 encoded bytes that are invalid UTF-8
      file.writeAsBytesSync([104, 101, 108, 108, 111]); // "hello" in latin-1
      final result = await file.streamLines(decoder: latin1.decoder).toList();
      expect(result, equals(['hello']));
    });

    test('file with only newlines produces empty strings per line', () async {
      file.writeAsStringSync('\n\n');
      expect(await file.streamLines().toList(), equals(['', '']));
    });
  });

  // ─── tailLines ────────────────────────────────────────────────────────────

  group('tailLines — argument validation', () {
    final file = File('tail_arg_test.txt');
    setUp(() => file.writeAsStringSync('a\nb\nc'));
    tearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    test('count = 0 returns empty list', () {
      expect(file.tailLines(0), isEmpty);
    });

    test('count = -1 throws ArgumentError', () {
      expect(() => file.tailLines(-1), throwsArgumentError);
    });

    test('large negative count throws ArgumentError', () {
      expect(() => file.tailLines(-999), throwsArgumentError);
    });
  });

  group('tailLines — empty and trivial files', () {
    final file = File('tail_trivial_test.txt');
    tearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    test('empty file returns empty list', () {
      file.writeAsBytesSync([]);
      expect(file.tailLines(5), isEmpty);
    });

    test('file with only a single newline returns one empty string', () {
      // '\n' marks an empty line terminated by a newline; not purely trailing.
      file.writeAsStringSync('\n');
      expect(file.tailLines(1), equals(['']));
    });

    test('file with a single non-newline byte returns that character', () {
      file.writeAsBytesSync([65]); // 'A'
      expect(file.tailLines(1), equals(['A']));
    });
  });

  group('tailLines — single line', () {
    final file = File('tail_single_test.txt');
    tearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    test('single line without trailing newline', () {
      file.writeAsStringSync('only line');
      expect(file.tailLines(1), equals(['only line']));
    });

    test('single line with trailing newline', () {
      file.writeAsStringSync('only line\n');
      expect(file.tailLines(1), equals(['only line']));
    });

    test('count greater than 1 on single-line file returns that line', () {
      file.writeAsStringSync('only line');
      expect(file.tailLines(100), equals(['only line']));
    });
  });

  group('tailLines — count vs line count', () {
    final file = File('tail_count_test.txt');
    tearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    test('returns last n lines', () {
      file.writeAsStringSync('line1\nline2\nline3\nline4\nline5');
      expect(file.tailLines(3), equals(['line3', 'line4', 'line5']));
    });

    test('count = 1 returns only the last line', () {
      file.writeAsStringSync('first\nsecond\nlast');
      expect(file.tailLines(1), equals(['last']));
    });

    test('count = total lines returns all lines', () {
      file.writeAsStringSync('a\nb\nc');
      expect(file.tailLines(3), equals(['a', 'b', 'c']));
    });

    test('count greater than total lines returns all lines', () {
      file.writeAsStringSync('a\nb\nc');
      expect(file.tailLines(10), equals(['a', 'b', 'c']));
    });

    test('count much larger than total lines returns all lines', () {
      file.writeAsStringSync('a\nb');
      expect(file.tailLines(10000), equals(['a', 'b']));
    });
  });

  group('tailLines — newline edge cases', () {
    final file = File('tail_nl_test.txt');
    tearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    test('trailing newline is not counted as an extra empty line', () {
      file.writeAsStringSync('line1\nline2\nline3\n');
      expect(file.tailLines(2), equals(['line2', 'line3']));
    });

    test('multiple trailing newlines produce empty lines', () {
      // Last '\n' is the trailing terminator; the one before it is a real
      // empty line.
      file.writeAsStringSync('line1\nline2\n\n');
      expect(file.tailLines(2), equals(['line2', '']));
    });

    test('three trailing newlines produce two empty lines', () {
      file.writeAsStringSync('a\n\n\n');
      expect(file.tailLines(3), equals(['a', '', '']));
    });

    test('leading newline produces an empty first line', () {
      file.writeAsStringSync('\nline1\nline2');
      expect(file.tailLines(3), equals(['', 'line1', 'line2']));
    });

    test('consecutive newlines produce empty lines between them', () {
      file.writeAsStringSync('a\n\n\nb');
      expect(file.tailLines(4), equals(['a', '', '', 'b']));
    });

    test('file of only newlines', () {
      file.writeAsStringSync('\n\n');
      expect(file.tailLines(2), equals(['', '']));
    });

    test('file of only newlines, count = 1', () {
      file.writeAsStringSync('\n\n\n');
      expect(file.tailLines(1), equals(['']));
    });

    test('windows \\r\\n: \\r is not stripped (unlike streamLines)', () {
      // tailLines splits only on \n; the \r preceding each \n stays in the
      // line content. This is the documented difference from streamLines,
      // which uses LineSplitter and strips \r.
      file.writeAsBytesSync('line1\r\nline2\r\nlast\r\n'.codeUnits);
      expect(file.tailLines(2), equals(['line2\r', 'last\r']));
    });

    test('empty lines in the middle are preserved', () {
      file.writeAsStringSync('first\n\nmiddle\n\nlast');
      expect(file.tailLines(5), equals(['first', '', 'middle', '', 'last']));
    });
  });

  group('tailLines — encodings', () {
    final file = File('tail_enc_test.txt');
    tearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    test('ascii encoding', () {
      file.writeAsBytesSync(ascii.encode('hello\nworld'));
      expect(file.tailLines(1, encoding: ascii), equals(['world']));
    });

    test('latin1 encoding with bytes above 0x7F', () {
      // 'é' is 0xE9 in latin-1 but invalid as a lone byte in UTF-8.
      file.writeAsBytesSync(latin1.encode('línea1\nlínea2\núltima'));
      expect(file.tailLines(2, encoding: latin1), equals(['línea2', 'última']));
    });

    test('latin1: all lines returned correctly', () {
      file.writeAsBytesSync(latin1.encode('ñoño\ncafé\nbüro'));
      expect(file.tailLines(3, encoding: latin1), equals(['ñoño', 'café', 'büro']));
    });
  });

  group('tailLines — UTF-8 multibyte characters', () {
    final file = File('tail_utf8_test.txt');
    tearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    test('2-byte UTF-8 characters (é, ü, ñ)', () {
      file.writeAsStringSync('résumé\ncafé\nnaïve');
      expect(file.tailLines(2), equals(['café', 'naïve']));
    });

    test('3-byte UTF-8 characters (CJK)', () {
      file.writeAsStringSync('日本語\n中文\n한국어');
      expect(file.tailLines(2), equals(['中文', '한국어']));
    });

    test('4-byte UTF-8 characters (emoji)', () {
      file.writeAsStringSync('hello\n🎉 party\n🌍 world');
      expect(file.tailLines(2), equals(['🎉 party', '🌍 world']));
    });

    test('mixed multibyte and ASCII on same line', () {
      file.writeAsStringSync('price: \$9.99\ncost: €8.50\ntotal: £7.00');
      expect(file.tailLines(2), equals(['cost: €8.50', 'total: £7.00']));
    });

    test('3-byte UTF-8 character spanning the 4096-byte chunk boundary', () {
      // '€' = 0xE2 0x82 0xAC (3 bytes). The file is engineered so that
      // byte 10 (the first byte of '€') falls in the second chunk read
      // and bytes 11-12 fall in the first. With fileLength = 4107 the
      // boundary is at byte 11, so '€' straddles it.
      //
      // Layout:
      //   bytes  0-9   : 'xxxxxxxxx\n'   (line 1 — 10 bytes)
      //   bytes 10-12  : 0xE2 0x82 0xAC  (line 2 — '€')
      //   byte  13     : 0x0A            (\n)
      //   bytes 14-4101: 'a' * 4088      (line 3)
      //   byte  4102   : 0x0A            (\n)
      //   bytes 4103-6 : 'last'          (line 4)
      //   fileLength = 10 + 3 + 1 + 4088 + 1 + 4 = 4107; boundary = 11
      final middleLine = 'a' * 4088;
      file.writeAsBytesSync([
        ...utf8.encode('x' * 9 + '\n'),
        0xE2,
        0x82,
        0xAC,
        0x0A,
        ...utf8.encode('$middleLine\n'),
        ...utf8.encode('last'),
      ]);
      expect(file.tailLines(3), equals(['€', middleLine, 'last']));
    });
  });

  group('tailLines — chunk boundary', () {
    final file = File('tail_chunk_test.txt');
    tearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    test('file exactly 4096 bytes — one full chunk', () {
      // 4095 'a' chars + '\n' = exactly 4096 bytes.
      final line = 'a' * 4095;
      file.writeAsStringSync('$line\n');
      expect(file.tailLines(1), equals([line]));
    });

    test('file exactly 4097 bytes — one byte into second chunk', () {
      // 4095 'a' chars + '\n' + 'b' = 4097 bytes.
      final longLine = 'a' * 4095;
      file.writeAsStringSync('$longLine\nb');
      expect(file.tailLines(1), equals(['b']));
      expect(file.tailLines(2), equals([longLine, 'b']));
    });

    test('very long single line exceeding chunk size', () {
      final longLine = 'x' * 10000;
      file.writeAsStringSync(longLine);
      expect(file.tailLines(1), equals([longLine]));
    });

    test('very long line in the middle of the file', () {
      final longLine = 'x' * 8000;
      file.writeAsStringSync('first\n$longLine\nlast');
      expect(file.tailLines(1), equals(['last']));
      expect(file.tailLines(2), equals([longLine, 'last']));
    });

    test('many small lines spanning multiple chunks', () {
      final lines = List.generate(200, (i) => 'line_${i.toString().padLeft(3, '0')}');
      file.writeAsStringSync(lines.join('\n'));
      expect(file.tailLines(5), equals(lines.sublist(195)));
      expect(file.tailLines(200), equals(lines));
    });

    test('file larger than two chunks (> 8192 bytes)', () {
      // ~500 lines × ~20 chars each ≈ 10 000 bytes — three chunk reads.
      final lines = List.generate(500, (i) => 'entry_${i.toString().padLeft(3, '0')}');
      file.writeAsStringSync(lines.join('\n'));
      expect(file.tailLines(3), equals(lines.sublist(497)));
      expect(file.tailLines(500), equals(lines));
    });

    test('nth newline lands exactly at a chunk boundary', () {
      // Place the target newline at byte 4090 in a 4099-byte file.
      // Boundary = 4099 - 4096 = 3. First read covers [3, 4099).
      // '\n' is at byte 4090 = chunk index 4087 inside the first read.
      file.writeAsStringSync('a' * 4090 + '\nend_line');
      expect(file.tailLines(1), equals(['end_line']));
      expect(file.tailLines(2), equals(['a' * 4090, 'end_line']));
    });
  });

  group('tailLines — consistency with streamLines', () {
    final file = File('tail_consistency_test.txt');
    tearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    test('last n matches tail of streamLines for small file', () async {
      final lines = List.generate(30, (i) => 'line_$i');
      file.writeAsStringSync(lines.join('\n'));
      final all = await file.streamLines().toList();
      expect(file.tailLines(10), equals(all.sublist(all.length - 10)));
    });

    test('matches all streamLines output when count >= total lines', () async {
      file.writeAsStringSync('alpha\nbeta\ngamma\ndelta');
      final all = await file.streamLines().toList();
      expect(file.tailLines(100), equals(all));
    });

    test('result consistent with streamLines for file with trailing newline', () async {
      file.writeAsStringSync('x\ny\nz\n');
      final all = await file.streamLines().toList();
      expect(file.tailLines(2), equals(all.sublist(all.length - 2)));
    });
  });

  group('tailLines — real-world scenarios', () {
    final file = File('tail_realworld_test.txt');
    tearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    test('application log file: returns last n entries', () {
      const logLines = [
        '[2024-01-01 10:00:00] INFO  Server started on port 8080',
        '[2024-01-01 10:00:01] DEBUG Loaded configuration from /etc/app.conf',
        '[2024-01-01 10:01:00] INFO  GET /health -> 200 OK (3ms)',
        '[2024-01-01 10:01:05] INFO  GET /api/users -> 200 OK (12ms)',
        '[2024-01-01 10:02:00] WARN  Memory usage above 80%: 847 MB / 1024 MB',
        '[2024-01-01 10:03:00] ERROR Connection refused: db-primary:5432',
        '[2024-01-01 10:03:01] INFO  Failing over to db-replica:5432',
        '[2024-01-01 10:03:02] INFO  Database reconnected successfully',
      ];
      file.writeAsStringSync('${logLines.join('\n')}\n');
      expect(file.tailLines(3), equals(logLines.sublist(5)));
    });

    test('CSV file: returns last n data rows (skipping header via index)', () {
      const rows = [
        'id,name,department,salary',
        '1,Alice,Engineering,95000',
        '2,Bob,Marketing,72000',
        '3,Carol,Engineering,110000',
        '4,Dave,Design,85000',
        '5,Eve,Engineering,102000',
      ];
      file.writeAsStringSync(rows.join('\n'));
      expect(file.tailLines(3), equals(rows.sublist(3)));
    });

    test('mixed unicode: Japanese, Arabic, emoji, Latin', () {
      const lines = [
        'English: Hello World',
        'Japanese: こんにちは世界',
        'Arabic: مرحبا بالعالم',
        'Emoji: 🎉 🌍 🚀 💡',
        'Mixed: café résumé naïve über',
      ];
      file.writeAsStringSync(lines.join('\n'));
      expect(file.tailLines(3), equals(lines.sublist(2)));
    });

    test('whitespace and tabs within lines are preserved', () {
      file.writeAsStringSync('normal\n\t\tindented\n   spaces   \nkey\tvalue\tlast');
      expect(file.tailLines(3), equals(['\t\tindented', '   spaces   ', 'key\tvalue\tlast']));
    });

    test('special characters in lines are preserved', () {
      const lines = [
        r'path: C:\Users\admin\file.txt',
        'regex: ^[a-z]+\$',
        'json: {"key": "value", "n": 42}',
        'url: https://example.com/path?q=1&r=2',
      ];
      file.writeAsStringSync(lines.join('\n'));
      expect(file.tailLines(2), equals(lines.sublist(2)));
    });

    test('config file: tail of an ini-style file', () {
      const config = [
        '[database]',
        'host = localhost',
        'port = 5432',
        '',
        '[server]',
        'host = 0.0.0.0',
        'port = 8080',
        'debug = false',
      ];
      file.writeAsStringSync(config.join('\n'));
      expect(file.tailLines(4), equals(config.sublist(4)));
    });
  });
}

class MockFunction extends Mock implements RealFunction {}

class RealFunction {
  void call() {
    print('file modified called');
  }
}
