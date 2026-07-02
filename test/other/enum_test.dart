// Author: Birju Vachhani
// Created Date: September 14, 2024

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

enum TestEnum { one, two, three }

void main() {
  test('enum iterable tests', () {
    expect(TestEnum.values.byNameOrNull('one'), TestEnum.one);
    expect(TestEnum.values.byNameOrNull('two'), TestEnum.two);
    expect(TestEnum.values.byNameOrNull('three'), TestEnum.three);
    expect(TestEnum.values.byNameOrNull('four'), isNull);
  });
}
