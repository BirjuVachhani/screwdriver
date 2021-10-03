// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('next method test', () {
    expect(<int>[].iterator.next(), null);
    expect([1].iterator.next(), 1);
    expect(
        ('hello'.runes.iterator
              ..next()
              ..next())
            .previous(),
        'hello'.runes.first);
  });
}
