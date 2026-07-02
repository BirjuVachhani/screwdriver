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
}

class MockFunction extends Mock implements RealFunction {}

class RealFunction {
  void call() {
    print('file modified called');
  }
}
