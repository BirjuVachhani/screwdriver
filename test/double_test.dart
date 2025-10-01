// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart' hide NumScrewdriver;
import 'package:test/test.dart';

void main() {
  test('isWhole tests', () {
    expect(2.0.isWhole, true);
    expect(2.5.isWhole, false);
    expect(double.infinity.isWhole, false);
  });

  test('random test', () {
    expect(randomDouble(), isA<double>());
    expect(randomDouble(), predicate<double>((value) => value < 1));
    expect(randomDouble(max: 50.0), predicate<double>((value) => value < 50));
    expect(randomDouble(max: 0.0), predicate<double>((value) => value == 0));
  });

  test('roundToPrecision tests', () {
    expect(2.1234567890.roundToPrecision(0), 2);
    expect(2.1234567890.roundToPrecision(1), 2.1);
    expect(2.1234567890.roundToPrecision(2), 2.12);
    expect(2.1234567890.roundToPrecision(3), 2.123);
    expect(2.1234567890.roundToPrecision(4), 2.1235);
    expect(2.1234567890.roundToPrecision(5), 2.12346);
    expect(2.1234567890.roundToPrecision(6), 2.123457);
    expect(2.1234567890.roundToPrecision(7), 2.1234568);
    expect(2.1234567890.roundToPrecision(8), 2.12345679);
    expect(2.1234567890.roundToPrecision(9), 2.123456789);

    expect(double.nan.roundToPrecision(2), isNaN);
    expect(double.infinity.roundToPrecision(2), double.infinity);
    expect(double.negativeInfinity.roundToPrecision(2), double.negativeInfinity);
  });

  test('isCloseTo test', () {
    expect(2.0.isCloseTo(2), true);
    expect(2.000000001.isCloseTo(2), true);
    expect(2.000000001.isCloseTo(2.000000004), true);
    expect(2.000000001.isCloseTo(2.00000004), false);
    expect(2.000000001.isCloseTo(2.00000123, precision: 0.0001), true);
    expect(2.000000001.isCloseTo(2.0004, precision: 0.0001), false);
  });
}
