// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('isBlank & isNotBlank tests', () {
    assert(''.isBlank);
    assert(' '.isBlank);
    assert('      '.isBlank);
    assert(!'   g   '.isBlank);
    assert('    g   '.isNotBlank);
    assert(!' '.isNotBlank);
    assert(!''.isNotBlank);
  });

  test('capitalized tests', () {
    assert('hello'.capitalized == 'Hello');
    assert('Hello'.capitalized == 'Hello');
    assert('hello world'.capitalized == 'Hello world');
  });

  test('toIntOrNull tests', () {
    assert('123'.toIntOrNull() == 123);
    assert('abc123'.toIntOrNull() == null);
    assert(''.toIntOrNull() == null);
  });

  test('toDoubleOrNull tests', () {
    assert('123'.toDoubleOrNull() == 123.0);
    assert('123.12'.toDoubleOrNull() == 123.12);
    assert('abc123'.toIntOrNull() == null);
    assert(''.toIntOrNull() == null);
  });

  test('toBoolOrNull tests', () {
    assert('123'.toBoolOrNull());
    assert('123.12'.toBoolOrNull() == null);
    assert('abc123'.toBoolOrNull() == null);
    assert('true'.toBoolOrNull());
    assert('TRUE'.toBoolOrNull());
    assert('True'.toBoolOrNull());
    assert(!'False'.toBoolOrNull());
  });

  test('wrap method tests', () {
    expect('html'.wrap('<', '>'), '<html>');
    expect('hello'.wrap('-'), '-hello-');
  });
}
