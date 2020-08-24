// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('isWhole tests', () {
    expect(2.0.isWhole, true);
    expect(2.5.isWhole, false);
    expect(double.infinity.isWhole, false);
  });

  test('random test', () {
    expect(randomDouble(), isA<double>());
    expect(randomDouble(), predicate((value) => value < 1));
    expect(randomDouble(max: 50.0), predicate((value) => value < 50));
    expect(randomDouble(max: 0.0), predicate((value) => value == 0));
  });
}
