// Author: Birju Vachhani
// Created Date: April 26, 2021

import 'package:screwdriver/src/helpers/helpers.dart';
import 'package:test/test.dart';

void main() {
  test('IntRangeIterator test with step size 1', () {
    final iterator = IntRangeIterator(1, 5);
    expect(iterator.start, 1);
    expect(iterator.end, 5);
    expect(iterator.step, 1);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 1);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 2);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 3);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 4);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 5);

    expect(iterator.moveNext(), isFalse);
    expect(iterator.current, 5);
  });

  test('IntRangeIterator test with step size 2', () {
    final iterator = IntRangeIterator(1, 10, step: 2);
    expect(iterator.start, 1);
    expect(iterator.end, 10);
    expect(iterator.step, 2);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 1);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 3);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 5);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 7);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 9);

    expect(iterator.moveNext(), isFalse);
    expect(iterator.current, 9);
  });

  test('IntRangeIterator test with step size -1', () {
    final iterator = IntRangeIterator(5, 1, step: -1);
    expect(iterator.start, 5);
    expect(iterator.end, 1);
    expect(iterator.step, -1);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 5);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 4);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 3);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 2);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 1);

    expect(iterator.moveNext(), isFalse);
    expect(iterator.current, 1);
  });

  test('IntRangeIterator test with step size -2', () {
    final iterator = IntRangeIterator(10, 1, step: -2);
    expect(iterator.start, 10);
    expect(iterator.end, 1);
    expect(iterator.step, -2);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 10);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 8);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 6);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 4);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 2);

    expect(iterator.moveNext(), isFalse);
    expect(iterator.current, 2);
  });

  test('IntRange tests with step size 1', () {
    final range = IntRange(1, 5);
    expect(range.first, 1);
    expect(range.last, 5);
    expect(range.length, 5);
    expect(range.isEmpty, isFalse);
    expect(range.elementAt(2), 3);
    expect(range.toList(), equals([1, 2, 3, 4, 5]));
    expect(range.toString(), equals('1 rangeTo 5 step 1'));
  });

  test('IntRange tests with step size 2', () {
    final range = IntRange(1, 10, step: 2);
    expect(range.first, 1);
    expect(range.last, 9);
    expect(range.length, 5);
    expect(range.isEmpty, isFalse);
    expect(range.elementAt(2), 5);
    expect(range.toList(), equals([1, 3, 5, 7, 9]));
    expect(range.toString(), equals('1 rangeTo 10 step 2'));
  });

  test('IntRange tests with step size -1', () {
    final range = IntRange(25, 20, step: -1);
    expect(range.first, 25);
    expect(range.last, 20);
    expect(range.length, 6);
    expect(range.isEmpty, isFalse);
    expect(range.elementAt(2), 23);
    expect(range.toList(), equals([25, 24, 23, 22, 21, 20]));
    expect(range.toString(), equals('25 downTo 20 step -1'));
  });

  test('IntRange tests with step size -3', () {
    final range = IntRange(25, 15, step: -3);
    expect(range.first, 25);
    expect(range.last, 16);
    expect(range.length, 4);
    expect(range.isEmpty, isFalse);
    expect(range.elementAt(2), 19);
    expect(range.toList(), equals([25, 22, 19, 16]));
    expect(range.toString(), equals('25 downTo 15 step -3'));
  });

  test('IntRange Exception tests', () {
    expect(() => IntRange(1, 10, step: 0), throwsException);
    expect(() => IntRange(1, 10, step: MIN_INT_VALUE), throwsException);
    expect(() => IntRange(10, 1), throwsException);
    expect(() => IntRange(1, 10, step: -1), throwsException);
    expect(() => IntRange(10, 10), throwsException);
  });

  test('IntRangeIterator equality test', () {
    expect(IntRange(1, 15), IntRange(1, 15));
    expect(IntRange(1, 15, step: 2) == IntRange(1, 15), isFalse);
    expect({IntRange(25, 15, step: -1), IntRange(25, 15, step: -1)},
        equals({IntRange(25, 15, step: -1)}));
  });

  test('IntRangeIterator reversed test', () {
    expect(IntRange(25, 15, step: -3).toList(), equals([25, 22, 19, 16]));
    expect(IntRange(25, 15, step: -3).reversed().toList(),
        equals([16, 19, 22, 25]));
    expect(IntRange(25, 15, step: -3).reversed(), IntRange(16, 25, step: 3));
  });
}
