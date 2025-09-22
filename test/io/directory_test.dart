// Author: Birju Vachhani
// Created Date: August 30, 2020

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:screwdriver/screwdriver_io.dart';
import 'package:test/test.dart';

void main() {
  group('directory tests', () {
    final dir = Directory('temp');

    test('file tests', () async {
      expect(dir.file('temp.txt').path, equals(p.join('temp', 'temp.txt')));
      expect(dir.file('').path, equals('temp'));
      expect(dir.file('.gitignore').path, equals(p.join('temp', '.gitignore')));
      expect(dir.file('Fastfile').path, equals(p.join('temp', 'Fastfile')));
    });

    test('subDir tests', () async {
      expect(dir.subDir('sub').path, equals(p.join('temp', 'sub')));
      expect(dir.subDir('').path, equals('temp'));
      expect(dir.subDir(r'sub/sub').path, equals(p.join('temp', 'sub', 'sub')));
      expect(dir.subDir('sub', 'sub1').path,
          equals(p.join('temp', 'sub', 'sub1')));
      expect(dir.subDir('sub', 'sub1', 'sub2').path,
          equals(p.join('temp', 'sub', 'sub1', 'sub2')));
      expect(dir.subDir('sub', 'sub1', 'sub2', 'sub3').path,
          equals(p.join('temp', 'sub', 'sub1', 'sub2', 'sub3')));
      expect(dir.subDir('sub', 'sub1', 'sub2', 'sub3', 'sub4').path,
          equals(p.join('temp', 'sub', 'sub1', 'sub2', 'sub3', 'sub4')));
    });

    group('deleteIfExists tests', () {
      test('deleteIfExists - directory exists', () async {
        final testDir = Directory('test_delete_exists');
        await testDir.create();
        expect(testDir.existsSync(), isTrue);

        final result = await testDir.deleteIfExists();
        expect(result, isNotNull);
        expect(testDir.existsSync(), isFalse);
      });

      test('deleteIfExists - directory does not exist', () async {
        final testDir = Directory('test_delete_not_exists');
        expect(testDir.existsSync(), isFalse);

        final result = await testDir.deleteIfExists();
        expect(result, isNull);
        expect(testDir.existsSync(), isFalse);
      });

      test('deleteIfExists - with recursive option', () async {
        final testDir = Directory('test_delete_recursive');
        final subDir = testDir.subDir('subdir');
        await subDir.create(recursive: true);
        subDir.file('test.txt').writeAsStringSync('test content');
        expect(testDir.existsSync(), isTrue);
        expect(subDir.existsSync(), isTrue);

        final result = await testDir.deleteIfExists(recursive: true);
        expect(result, isNotNull);
        expect(testDir.existsSync(), isFalse);
        expect(subDir.existsSync(), isFalse);
      });
    });

    group('deleteIfExistsSync tests', () {
      test('deleteIfExistsSync - directory exists', () {
        final testDir = Directory('test_delete_sync_exists');
        testDir.createSync();
        expect(testDir.existsSync(), isTrue);

        testDir.deleteIfExistsSync();
        expect(testDir.existsSync(), isFalse);
      });

      test('deleteIfExistsSync - directory does not exist', () {
        final testDir = Directory('test_delete_sync_not_exists');
        expect(testDir.existsSync(), isFalse);

        testDir.deleteIfExistsSync();
        expect(testDir.existsSync(), isFalse);
      });

      test('deleteIfExistsSync - with recursive option', () {
        final testDir = Directory('test_delete_sync_recursive');
        final subDir = testDir.subDir('subdir');
        subDir.createSync(recursive: true);
        subDir.file('test.txt').writeAsStringSync('test content');
        expect(testDir.existsSync(), isTrue);
        expect(subDir.existsSync(), isTrue);

        testDir.deleteIfExistsSync(recursive: true);
        expect(testDir.existsSync(), isFalse);
        expect(subDir.existsSync(), isFalse);
      });
    });

    group('createIfMissing tests', () {
      test('createIfMissing - directory does not exist', () async {
        final testDir = Directory('test_create_missing');
        if (testDir.existsSync()) testDir.deleteSync(recursive: true);
        expect(testDir.existsSync(), isFalse);

        final result = await testDir.createIfMissing();
        expect(result, equals(testDir));
        expect(testDir.existsSync(), isTrue);

        testDir.deleteSync();
      });

      test('createIfMissing - directory already exists', () async {
        final testDir = Directory('test_create_exists');
        testDir.createSync();
        expect(testDir.existsSync(), isTrue);

        final result = await testDir.createIfMissing();
        expect(result, equals(testDir));
        expect(testDir.existsSync(), isTrue);

        testDir.deleteSync();
      });

      test('createIfMissing - with recursive option', () async {
        final testDir = Directory('test_create_recursive/deep/nested');
        if (Directory('test_create_recursive').existsSync()) {
          Directory('test_create_recursive').deleteSync(recursive: true);
        }
        expect(testDir.existsSync(), isFalse);

        final result = await testDir.createIfMissing(recursive: true);
        expect(result, equals(testDir));
        expect(testDir.existsSync(), isTrue);
        expect(Directory('test_create_recursive').existsSync(), isTrue);

        Directory('test_create_recursive').deleteSync(recursive: true);
      });
    });

    group('createIfMissingSync tests', () {
      test('createIfMissingSync - directory does not exist', () {
        final testDir = Directory('test_create_sync_missing');
        if (testDir.existsSync()) testDir.deleteSync(recursive: true);
        expect(testDir.existsSync(), isFalse);

        testDir.createIfMissingSync();
        expect(testDir.existsSync(), isTrue);

        testDir.deleteSync();
      });

      test('createIfMissingSync - directory already exists', () {
        final testDir = Directory('test_create_sync_exists');
        testDir.createSync();
        expect(testDir.existsSync(), isTrue);

        testDir.createIfMissingSync();
        expect(testDir.existsSync(), isTrue);

        testDir.deleteSync();
      });

      test('createIfMissingSync - with recursive option', () {
        final testDir = Directory('test_create_sync_recursive/deep/nested');
        if (Directory('test_create_sync_recursive').existsSync()) {
          Directory('test_create_sync_recursive').deleteSync(recursive: true);
        }
        expect(testDir.existsSync(), isFalse);

        testDir.createIfMissingSync(recursive: true);
        expect(testDir.existsSync(), isTrue);
        expect(Directory('test_create_sync_recursive').existsSync(), isTrue);

        Directory('test_create_sync_recursive').deleteSync(recursive: true);
      });
    });
  });
}
