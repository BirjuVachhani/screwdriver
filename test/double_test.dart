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
}
