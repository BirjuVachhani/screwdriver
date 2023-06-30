// Author: Birju Vachhani
// Created Date: August 27, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('scope functions tests', () {
    expect(<int>[].apply((obj) => obj << 5), equals([5]));
    expect(5.run((obj) => (obj + 5).toString()), '10');
  });

  test('takeIf tests', () {
    expect(5.takeIf((obj) => obj.isEven), null);
    expect(5.takeIf((obj) => obj.isOdd), 5);
  });

  test('takeUnless tests', () {
    expect(45.takeUnless((obj) => obj.isEven), 45);
    expect(45.takeUnless((obj) => obj.isOdd), null);
  });

  test('TODO tests', () {
    expect(() => TODO('unimplemented test'), throwsUnimplementedError);
  });

  test('tryCast tests', () {
    expect('2'.tryCast<int>(), null);
    expect('2'.tryCast<String>(), '2');

    const double value = 2.5;
    expect(value.tryCast<int>(), null);
    expect(value.tryCast<double>(), 2.5);
    expect(value.tryCast<num>(), 2.5);
  });
}
