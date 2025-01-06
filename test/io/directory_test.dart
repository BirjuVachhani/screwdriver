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
  });
}
