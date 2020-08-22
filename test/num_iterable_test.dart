import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

// Author: Birju Vachhani
// Created Date: August 22, 2020

void main() {
  test('math extensions test', () {
    final list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    expect(list.sum(), 55);
    expect(list.average(), 5.5);
    expect(list.min(), 1);
    expect(list.max(), 10);
    expect(<int>[].min(), null);
    expect(<int>[].sum(), 0);
    expect(<int>[].average(), 0);
  });
}
