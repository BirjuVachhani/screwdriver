// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('isNullOrEmpty tests', () {
    expect(''.isNullOrEmpty, true);
    expect(' '.isNullOrEmpty, false);
    String str;
    expect(str.isNullOrEmpty, true);
    str = 'abc';
    expect(str.isNullOrEmpty, false);
  });

  test('isNotNullOrEmpty tests', () {
    expect(''.isNotNullOrEmpty, false);
    expect(' '.isNotNullOrEmpty, true);
    String str;
    expect(str.isNotNullOrEmpty, false);
    str = 'abc';
    expect(str.isNotNullOrEmpty, true);
  });

  test('isNullOrBlank tests', () {
    expect(''.isNullOrBlank, true);
    expect(' '.isNullOrBlank, true);
    String str;
    expect(str.isNullOrBlank, true);
    str = 'abc';
    expect(str.isNullOrBlank, false);
  });

  test('isNotNullOrBlank tests', () {
    expect(''.isNotNullOrBlank, false);
    expect(' '.isNotNullOrBlank, false);
    String str;
    expect(str.isNotNullOrBlank, false);
    str = 'abc';
    expect(str.isNotNullOrBlank, true);
  });

  test('isBlank & isNotBlank tests', () {
    expect(''.isBlank, true);
    expect(' '.isBlank, true);
    expect('      '.isBlank, true);
    expect('   g   '.isBlank, false);
    expect('    g   '.isNotBlank, true);
    expect(' '.isNotBlank, false);
    expect(''.isNotBlank, false);
  });

  test('capitalized tests', () {
    expect(''.capitalized, '');
    expect('a'.capitalized, 'A');
    expect('hello'.capitalized, 'Hello');
    expect('Hello'.capitalized, 'Hello');
    expect('hello world'.capitalized, 'Hello world');
  });

  test('toIntOrNull tests', () {
    expect('123'.toIntOrNull(), 123);
    expect('FF'.toIntOrNull(radix: 16), 255);
    expect('abc123'.toIntOrNull(), null);
    expect(''.toIntOrNull(), null);
  });

  test('toDoubleOrNull tests', () {
    expect('123'.toDoubleOrNull(), 123.0);
    expect('123.12'.toDoubleOrNull(), 123.12);
    expect('abc123'.toIntOrNull(), null);
    expect(''.toIntOrNull(), null);
    expect('15.15'.isDouble, true);
  });

  test('toBoolOrNull tests', () {
    expect('123'.toBoolOrNull(), true);
    expect('123.12'.toBoolOrNull(), null);
    expect('abc123'.toBoolOrNull(), null);
    expect('true'.toBoolOrNull(), true);
    expect('TRUE'.toBoolOrNull(), true);
    expect('True'.toBoolOrNull(), true);
    expect('False'.toBoolOrNull(), false);
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
    expect('#hello#'.unwrap('<', '#'), '#hello');
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
    expect('01001'.isBinary, true);
    expect('401001'.isBinary, false);
    expect('f01001'.isBinary, false);

    expect('274'.isOctal, true);
    expect('801001'.isOctal, false);
    expect('f01001'.isOctal, false);

    expect('FF4433'.isHexadecimal, true);
    expect('r801001'.isHexadecimal, false);
    expect('ft01001'.isHexadecimal, false);

    expect('845'.isDecimal, true);
    expect('r801001'.isDecimal, false);
    expect('1001.15'.isDecimal, false);
  });

  test('isEmail tests', () {
    expect('example@gmail.com'.isEmail, true);
    expect('Example@Gmail.com'.isEmail, true);
    expect('a@a.com'.isEmail, true);
    expect('c+a@a.a'.isEmail, true);
    expect('C+A@A.A'.isEmail, true);
    expect('mysite.ourearth.com'.isEmail, false);
    expect('@you.me.net'.isEmail, false);
    expect('mysite@.'.isEmail, false);
    expect('mysite()*@gmail.com'.isEmail, false);
  });

  test('reversed tests', () {
    expect('abcd'.reversed, 'dcba');
    expect(''.reversed, '');
    expect('Thanks👍'.reversed, '👍sknahT');
  });

  test('toDateTimeOrNull tests', () {
    expect('2020-04-24 15:30:00.000000'.toDateTimeOrNull(),
        DateTime(2020, 4, 24, 15, 30));
    expect('2020-04-24'.toDateTimeOrNull(), DateTime(2020, 4, 24));
  });

  test('words tests', () {
    expect('There are four words'.words.length, 4);
    expect(''.words.length, 0);
    expect('     '.words.length, 0);
  });

  test('toJson tests', () {
    expect('{"name":"John"}'.parseJson(), equals({'name': 'John'}));
    expect('{}'.parseJson(), equals({}));
    expect(() => 'random'.parseJson(), throwsFormatException);
  });
}
