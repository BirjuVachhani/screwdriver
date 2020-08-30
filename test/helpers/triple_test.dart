// Author: Birju Vachhani
// Created Date: August 29, 2020

import 'package:screwdriver/src/helpers/triple.dart';
import 'package:test/test.dart';

void main() {
  test('triple test', () {
    final triplet = Triple(25, 48.4, 'Hello');
    expect(triplet.first, 25);
    expect(triplet.second, 48.4);
    expect(triplet.third, 'Hello');
    expect(triplet, Triple(25, 48.4, 'Hello'));
    // objects containing same value must be the same to pass equality test
    expect(triplet.copyWith(first: 12), Triple(12, 48.4, 'Hello'));
    // hashcode must be the same for containing the same values.
    expect(triplet.hashCode, Triple(25, 48.4, 'Hello').hashCode);
    expect(triplet.toString(), '(25, 48.4, Hello)');
  });
}
