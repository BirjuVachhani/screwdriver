// Author: Birju Vachhani
// Created Date: August 24, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('+ operator test', () {
    final emptyMap = <String, String>{};
    emptyMap + Pair('name', 'John');
    expect(emptyMap, equals({'name': 'John'}));
  });

  test('<< operator test', () {
    final emptyMap = <String, String>{};
    emptyMap << MapEntry('name', 'John');
    expect(emptyMap, equals({'name': 'John'}));
  });

  test('toJson test', () {
    expect({'name': 'John'}.toJson(), equals('{"name":"John"}'));
    expect(<String, dynamic>{}.toJson(), equals('{}'));
  });

  test('except test', () {
    expect({'a': 1, 'b': 2, 'c': 3}.except(['a', 'b']), equals({'c': 3}));
    expect(
        {'a': 1, 'b': 2, 'c': 3}.except(['a', 'd']), equals({'b': 2, 'c': 3}));
  });
}
