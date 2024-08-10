// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('hasExactMatch tests', () {
    expect(RegExp(r'\d+').hasExactMatch('123'), isTrue);
    expect(RegExp(r'\d+').hasExactMatch('123a'), isFalse);
    expect(RegExp(r'\d+').hasExactMatch('a123'), isFalse);
    expect(RegExp(r'\d+').hasMatch('a123'), isTrue);
  });

}
