// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('negative conversion test', () {
    assert(5.negative.isNegative);
    assert(5.0.negative.isNegative);
    assert((-20).negative.isNegative);
    assert((-20.0).negative.isNegative);
  });
}
