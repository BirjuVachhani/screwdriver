// Author: Birju Vachhani
// Created Date: April 28, 2021

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('coerce extension tests', () {
    expect(5.coerceAtLeast(10), 10);
    expect(5.coerceAtLeast(3), 5);

    expect(15.coerceAtMost(10), 10);
    expect(15.coerceAtMost(20), 15);

    expect(15.coerceIn(10, 20), 15);
    expect(8.coerceIn(10, 20), 10);
    expect(22.coerceIn(10, 20), 20);
  });
}
