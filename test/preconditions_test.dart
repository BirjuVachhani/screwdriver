// Author: Birju Vachhani
// Created Date: August 27, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('check && checkNotNull tests', () {
    expect(() => check(35.isEven), throwsA(isA<IllegalStateException>()));
    expect(() => check(35.isOdd), returnsNormally);
    expect(() => checkNotNull(null), throwsA(isA<IllegalStateException>()));
    expect(checkNotNull(5), 5);
    expect(IllegalStateException().toString(), 'IllegalStateException');
    expect(IllegalStateException('test error').toString(),
        'IllegalStateException: test error');
  });

  test('require && requireNotNull tests', () {
    expect(() => require(35.isEven), throwsA(isA<IllegalArgumentException>()));
    expect(() => require(35.isOdd), returnsNormally);
    expect(
        () => requireNotNull(null), throwsA(isA<IllegalArgumentException>()));
    expect(requireNotNull(5), 5);
    expect(IllegalArgumentException().toString(), 'IllegalArgumentException');
    expect(IllegalArgumentException('test error').toString(),
        'IllegalArgumentException: test error');
  });
}
