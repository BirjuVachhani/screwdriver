// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('<< operator test', () {
    expect([1, 2] << 3, equals([1, 2, 3]));
    expect(<int>[] << 3, equals([3]));
  });

  group('replaceFirstWhere', () {
    test('should replace the first matching item and return true', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.replaceFirstWhere(0, (item) => item == 3);
      expect(result, isTrue);
      expect(list, equals([1, 2, 0, 4, 5]));
    });

    test('should not modify the list and return false if no item matches', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.replaceFirstWhere(0, (item) => item == 6);
      expect(result, isFalse);
      expect(list, equals([1, 2, 3, 4, 5]));
    });

    test('should not modify the list and return false if the list is empty', () {
      final list = [];
      final result = list.replaceFirstWhere(0, (item) => item == 1);
      expect(result, isFalse);
      expect(list, isEmpty);
    });
  });

  group('replaceLastWhere', () {
    test('should replace the last matching item and return true', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.replaceLastWhere(0, (item) => item == 3);
      expect(result, isTrue);
      expect(list, equals([1, 2, 0, 4, 5]));
    });

    test('should not modify the list and return false if no item matches', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.replaceLastWhere(0, (item) => item == 6);
      expect(result, isFalse);
      expect(list, equals([1, 2, 3, 4, 5]));
    });

    test('should not modify the list and return false if the list is empty', () {
      final list = [];
      final result = list.replaceLastWhere(0, (item) => item == 1);
      expect(result, isFalse);
      expect(list, isEmpty);
    });
  });
}
