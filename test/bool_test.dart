// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('toggled & int tests', () {
    expect(true.toggled, false);
    expect(false.toggled, true);
    expect(true.toInt(), 1);
    expect(false.toInt(), 0);
  });
}
