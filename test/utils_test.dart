// Author: Birju Vachhani
// Created Date: August 27, 2020

import 'dart:convert';

import 'package:screwdriver/screwdriver.dart';
import 'package:screwdriver/src/utils.dart';
import 'package:test/test.dart';

void main() {
  test('tryJsonDecode tests', () {
    expect(() => tryJsonDecode('{}'), isNot(throwsException));
    expect(() => jsonDecode('{a}'), throwsException);
    expect(() => tryJsonDecode('{a}'), isNot(throwsException));
    expect(() => tryJsonDecode('{"name": "John"}'), isNot(throwsException));
    expect(tryJsonDecode('{"name": "John"}'), contains('name'));
    expect(tryJsonDecode('{"name": "John"}'), containsValue('John'));
  });
}
