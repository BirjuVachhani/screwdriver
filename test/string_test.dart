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
    assert('15.15'.isDouble);
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

    assert('845'.isDecimal);
    assert(!'r801001'.isDecimal);
    assert(!'1001.15'.isDecimal);
  });

  test('isEmail tests', () {
    assert('example@gmail.com'.isEmail);
    assert('a@a.com'.isEmail);
    assert('c+a@a.a'.isEmail);
    assert(!'mysite.ourearth.com'.isEmail);
    assert(!'@you.me.net'.isEmail);
    assert(!'mysite@.'.isEmail);
    assert(!'mysite()*@gmail.com'.isEmail);
  });

  test('reversed tests', () {
    assert('abcd'.reversed == 'dcba');
    assert(''.reversed == '');
    assert('Thanks👍'.reversed == '👍sknahT');
  });

  test('isURL tests', () {
    assert('https://google.com'.isURL);
    assert('http://google.com'.isURL);
    assert('example.com'.isURL);
    assert('www.example.com'.isURL);
    assert('https://www.example.com'.isURL);
    assert('https://www.example.com/sample/?test=2&test2=5'.isURL);
    assert('https://192.168.1.25:5050'.isURL);
    assert('https://192.168.1.25'.isURL);
    assert('ftp://192.168.1.25'.isURL);
    assert('mailto:example@abc.com'.isURL);
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
}
