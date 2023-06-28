// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart' hide DoubleScrewdriver;
import 'package:test/test.dart';

void main() {
  test('negative conversion test', () {
    expect(5.negative.isNegative, true);
    expect(5.0.negative.isNegative, true);
    expect((-20).negative.isNegative, true);
    expect((-20.0).negative.isNegative, true);
  });

  test('isBetween tests', () {
    expect(500.isBetween(100, 700), true);
    expect(500.isBetween(700, 300), true);
    expect(300.isBetween(700, 300, inclusive: true), true);
    expect(500.isBetween(400, 100), false);
    expect(500.isBetween(100, 400), false);
    expect(500.48.isBetween(500.0, 510.0), true);
    expect(500.00.isBetween(500.0, 510.0, inclusive: true), true);
  });

  test('roundToPrecision tests', () {
    expect(2.roundToPrecision(0), 2);
    expect(2.1234567890.roundToPrecision(0), 2.0);
    expect(2.1234567890.roundToPrecision(3), 2.123);

    expect(double.nan.roundToPrecision(2), isNaN);
    expect(double.infinity.roundToPrecision(2), double.infinity);
    expect(
        double.negativeInfinity.roundToPrecision(2), double.negativeInfinity);
  });

  test('nullable num tests', () {
    num? nullableNum;
    int? nullableInt;
    double? nullableDouble;
    expect(nullableNum.orOne, 1);
    expect(nullableInt.orOne, 1);
    expect(nullableDouble.orOne, 1);

    expect(nullableNum.orZero, 0);
    expect(nullableInt.orZero, 0);
    expect(nullableDouble.orZero, 0);

    expect(nullableNum.or(5), 5);
    expect(nullableInt.or(10), 10);
    expect(nullableDouble.or(25.5), 25.5);

    nullableNum = 5;
    nullableInt = 10;
    nullableDouble = 25.5;

    expect(nullableNum.orOne, 5);
    expect(nullableInt.orOne, 10);
    expect(nullableDouble.orOne, 25.5);

    expect(nullableNum.orZero, 5);
    expect(nullableInt.orZero, 10);
    expect(nullableDouble.orZero, 25.5);
  });

  test('max tests', () {
    expect(5.max(10), equals(5));
    expect(5.max(10), equals(5));
    expect(15.max(10, exclusive: true), equals(10));
  });

  test('min tests', () {
    expect(5.min(2), equals(5));
    expect(5.min(2), equals(5));
    expect(1.min(2, exclusive: true), equals(2));
  });
}
