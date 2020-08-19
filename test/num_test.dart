// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
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
}
