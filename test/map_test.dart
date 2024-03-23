// Author: Birju Vachhani
// Created Date: August 24, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('+ operator test', () {
    final emptyMap = <String, String>{};
    emptyMap + ('name', 'John');
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

  test('where test', () {
    expect({'a': 1, 'b': 2, 'c': 3}.where((key, value) => value > 2),
        equals({'c': 3}));
    expect({'a': 1, 'b': 2, 'c': 3}.where((key, value) => key != 'a'),
        equals({'b': 2, 'c': 3}));
  });

  test('whereNot test', () {
    expect({'a': 1, 'b': 2, 'c': 3}.whereNot((key, value) => value <= 2),
        equals({'c': 3}));
    expect({'a': 1, 'b': 2, 'c': 3}.whereNot((key, value) => key == 'a'),
        equals({'b': 2, 'c': 3}));
  });

  test('only test', () {
    expect({'a': 1, 'b': 2, 'c': 3}.only(['c']),
        equals({'c': 3}));
    expect({'a': 1, 'b': 2, 'c': 3}.only(['b', 'c']),
        equals({'b': 2, 'c': 3}));
  });

  test('records test', () {
    final Map<String, dynamic> map = {
      'name': 'John',
      'age': 25,
    };
    expect(map.records, equals([('name', 'John'), ('age', 25)]));

    for (final (key, value) in map.records) {
      expect(map[key], equals(value));
    }
  });
}
