// Author: Birju Vachhani
// Created Date: August 30, 2020

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
      expect(await file.isEmptySync, isFalse);
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
      await Future.delayed(Duration(seconds: 3));
      verify(modified.call()).called(1);
      other.deleteSync();
      await Future.delayed(Duration(seconds: 3));
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
}

class MockFunction extends Mock implements RealFunction {}

class RealFunction {
  int call() {
    print('file modified called');
    return 5;
  }
}
