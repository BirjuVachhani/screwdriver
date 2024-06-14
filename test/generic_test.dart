// Author: Birju Vachhani
// Created Date: August 27, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('scope functions tests', () {
    expect(<int>[].apply((obj) => obj << 5), equals([5]));
    expect(5.run((obj) => (obj + 5).toString()), '10');
  });

  test('takeIf tests', () {
    expect(5.takeIf((obj) => obj.isEven), null);
    expect(5.takeIf((obj) => obj.isOdd), 5);
  });

  test('takeUnless tests', () {
    expect(45.takeUnless((obj) => obj.isEven), 45);
    expect(45.takeUnless((obj) => obj.isOdd), null);
  });

  test('TODO tests', () {
    expect(() => TODO('unimplemented test'), throwsUnimplementedError);
  });

  test('tryCast tests', () {
    expect('2'.tryCast<int>(), null);
    expect('2'.tryCast<String>(), '2');

    const double value = 2.5;
    expect(value.tryCast<int>(), null);
    expect(value.tryCast<double>(), 2.5);
    expect(value.tryCast<num>(), 2.5);
  });

  test('isTruthy tests', () {
    expect(null.isTruthy, isFalse);
    expect(false.isTruthy, isFalse);
    expect(true.isTruthy, isTrue);
    expect(5.isTruthy, isTrue);
    expect(0.isTruthy, isFalse);
    expect(0.0.isTruthy, isFalse);
    expect(0.1.isTruthy, isTrue);
    expect(''.isTruthy, isFalse);
    expect('hello'.isTruthy, isTrue);
    expect([].isTruthy, isFalse);
    expect([1].isTruthy, isTrue);
    expect([1, 2.5, true, 'hello'].isTruthy, isTrue);
    expect(<String, int>{}.isTruthy, isFalse);
    expect({'name': 'John', 'age': 25, 'isStudent': false}.isTruthy, isTrue);
  });

  test('isFalsy tests', () {
    expect(null.isFalsy, isTrue);
    expect(false.isFalsy, isTrue);
    expect(true.isFalsy, isFalse);
    expect(5.isFalsy, isFalse);
    expect(0.isFalsy, isTrue);
    expect(0.0.isFalsy, isTrue);
    expect(0.1.isFalsy, isFalse);
    expect(''.isFalsy, isTrue);
    expect('hello'.isFalsy, isFalse);
    expect([].isFalsy, isTrue);
    expect([1].isFalsy, isFalse);
    expect([1, 2.5, true, 'hello'].isFalsy, isFalse);
    expect(<String, int>{}.isFalsy, isTrue);
    expect({'name': 'John', 'age': 25, 'isStudent': false}.isFalsy, isFalse);
  });
}
