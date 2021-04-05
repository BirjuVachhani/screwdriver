// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('<< operator test', () {
    expect([1, 2] << 3, equals([1, 2, 3]));
    expect(<int>[] << 3, equals([3]));
  });
}
