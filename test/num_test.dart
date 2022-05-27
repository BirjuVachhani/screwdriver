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
}
