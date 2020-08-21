// Author: Birju Vachhani
// Created Date: August 21, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('pair test', () {
    final pair = Pair('age', 24);
    expect(pair.first, 'age');
    expect(pair.second, 24);
    expect(pair.toString(), '(age, 24)');
    expect(pair.copyWith(first: 'count').first, 'count');
    expect(pair.copyWith(first: 'count').second, 24);
    // objects containing same value must be the same to pass equality test
    expect(Pair(23, 48), Pair(23, 48));
    // hashcode must be the same for containing the same values.
    expect(Pair(23, 48).hashCode, Pair(23, 48).hashCode);
  });
}
