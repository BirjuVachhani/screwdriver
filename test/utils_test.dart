// Author: Birju Vachhani
// Created Date: August 27, 2020

import 'dart:convert';

import 'package:screwdriver/screwdriver.dart';
import 'package:screwdriver/src/utils.dart';
import 'package:test/test.dart';

void main() {
  test('tryJsonDecode tests', () {
    expect(() => tryJsonDecode('{}'), isNot(throwsException));
    expect(() => jsonDecode('{a}'), throwsException);
    expect(() => tryJsonDecode('{a}'), isNot(throwsException));
    expect(() => tryJsonDecode('{"name": "John"}'), isNot(throwsException));
    expect(tryJsonDecode('{"name": "John"}'), contains('name'));
    expect(tryJsonDecode('{"name": "John"}'), containsValue('John'));
  });

  group('isExactType', () {
    test('returns true for identical types', () {
      expect(isExactType<int, int>(), isTrue);
      expect(isExactType<String, String>(), isTrue);
      expect(isExactType<double, double>(), isTrue);
      expect(isExactType<bool, bool>(), isTrue);
      expect(isExactType<List<int>, List<int>>(), isTrue);
      expect(isExactType<Map<String, int>, Map<String, int>>(), isTrue);
    });

    test('returns false for different types', () {
      expect(isExactType<int, double>(), isFalse);
      expect(isExactType<int, num>(), isFalse);
      expect(isExactType<String, Object>(), isFalse);
      expect(isExactType<List<int>, List<double>>(), isFalse);
    });

    test('returns false for subtype/supertype pairs', () {
      expect(isExactType<int, num>(), isFalse);
      expect(isExactType<num, int>(), isFalse);
      expect(isExactType<String, Object>(), isFalse);
      expect(isExactType<Object, String>(), isFalse);
    });
  });

  group('isSubType', () {
    test('returns true when Sub is a subtype of Parent', () {
      expect(isSubType<int, num>(), isTrue);
      expect(isSubType<double, num>(), isTrue);
      expect(isSubType<String, Object>(), isTrue);
      expect(isSubType<int, Object>(), isTrue);
      expect(isSubType<List<int>, List<num>>(), isTrue);
    });

    test('returns true when types are the same', () {
      expect(isSubType<int, int>(), isTrue);
      expect(isSubType<String, String>(), isTrue);
    });

    test('returns false when Sub is not a subtype of Parent', () {
      expect(isSubType<num, int>(), isFalse);
      expect(isSubType<Object, String>(), isFalse);
      expect(isSubType<String, int>(), isFalse);
      expect(isSubType<List<num>, List<int>>(), isFalse);
    });
  });
}
