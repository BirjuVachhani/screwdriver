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
    assert(''.capitalized == '');
    assert('a'.capitalized == 'A');
    assert('hello'.capitalized == 'Hello');
    assert('Hello'.capitalized == 'Hello');
    assert('hello world'.capitalized == 'Hello world');
  });

  test('toIntOrNull tests', () {
    assert('123'.toIntOrNull() == 123);
    assert('FF'.toIntOrNull(radix: 16) == 255);
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
    expect('hello'.wrap(''), 'hello');
    expect('hello'.wrap('', '#'), 'hello#');
  });

  test('unwrap method tests', () {
    expect('<html>'.unwrap('<', '>'), 'html');
    expect('*hello*'.unwrap('*'), 'hello');
    expect('hello'.unwrap(''), 'hello');
    expect('#hello#'.unwrap('', '#'), '#hello');
  });

  test('removePrefix and removeSuffix method tests', () {
    expect('hello-world'.removePrefix('hello'), '-world');
    expect('hello-world'.removePrefix('world'), 'hello-world');
    expect('xyz'.removePrefix('a'), 'xyz');
    expect(''.removePrefix('a'), '');
    expect('a'.removePrefix(''), 'a');
    expect(''.removePrefix(''), '');

    expect('hello-world'.removeSuffix('world'), 'hello-');
    expect('hello-world'.removeSuffix('hello'), 'hello-world');
    expect('xyz'.removeSuffix('a'), 'xyz');
    expect(''.removeSuffix('a'), '');
    expect('a'.removeSuffix(''), 'a');
    expect(''.removeSuffix(''), '');
  });

  test('radix tests', () {
    assert('01001'.isBinary);
    assert(!'401001'.isBinary);
    assert(!'f01001'.isBinary);

    assert('274'.isOctal);
    assert(!'801001'.isOctal);
    assert(!'f01001'.isOctal);

    assert('FF4433'.isHexadecimal);
    assert(!'r801001'.isHexadecimal);
    assert(!'ft01001'.isHexadecimal);
  });
}
