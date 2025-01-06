// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'dart:convert';
import 'dart:typed_data';

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('isNullOrEmpty tests', () {
    expect(''.isNullOrEmpty, true);
    expect(' '.isNullOrEmpty, false);
    String? str;
    expect(str.isNullOrEmpty, true);
    str = 'abc';
    expect(str.isNullOrEmpty, false);
  });

  test('isNotNullOrEmpty tests', () {
    expect(''.isNotNullOrEmpty, false);
    expect(' '.isNotNullOrEmpty, true);
    String? str;
    expect(str.isNotNullOrEmpty, false);
    str = 'abc';
    expect(str.isNotNullOrEmpty, true);
  });

  test('isNullOrBlank tests', () {
    expect(''.isNullOrBlank, true);
    expect(' '.isNullOrBlank, true);
    String? str;
    expect(str.isNullOrBlank, true);
    str = 'abc';
    expect(str.isNullOrBlank, false);
  });

  test('isNotNullOrBlank tests', () {
    expect(''.isNotNullOrBlank, false);
    expect(' '.isNotNullOrBlank, false);
    String? str;
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
    expect('hello world 😊'.capitalized, 'Hello world 😊');
    expect('😊hello world'.capitalized, '😊hello world');
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

  test('unwrap & strip method tests', () {
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

  test('parseJson tests', () {
    expect('{"name":"John"}'.parseJson(), equals({'name': 'John'}));
    expect('{}'.parseJson(), equals(<String, dynamic>{}));
    expect(() => 'random'.parseJson(), throwsFormatException);
  });

  test('parseJsonArray tests', () {
    expect(
        '[{"name":"John"},{"name":"Steve"}]'.parseJsonArray(),
        equals([
          {'name': 'John'},
          {'name': 'Steve'}
        ]));
    expect('[]'.parseJsonArray(), equals(<int>[]));
    expect(() => 'random'.parseJsonArray(), throwsFormatException);
  });

  test('toggledCase tests', () {
    expect('hello'.toggledCase, equals('HELLO'));
    expect('Hell0'.toggledCase, equals('hELL0'));
    expect('çå†'.toggledCase, equals('ÇÅ†'));
    expect('çå†'.toggledCase.toggledCase, equals('çå†'));
    expect('ß'.toggledCase, equals('ß'));
    expect('hello👌'.toggledCase, equals('HELLO👌'));
  });

  test('title tests', () {
    expect("He's an engineer, isn't he?".title(),
        equals("He's An Engineer, Isn't He?"));
    expect('My favorite number is 87😊.'.title(),
        equals('My Favorite Number Is 87😊.'));
  });

  test('equalsIgnoreCase tests', () {
    expect(
        "He's an engineer, isn't he?"
            .equalsIgnoreCase("He's an EnGineer, IsN't hE?"),
        isTrue);
    expect(
        'My favorite number is 87😊.'
            .equalsIgnoreCase('my Favorite NUMBER Is 87😊.'),
        isTrue);
    expect('çå†'.equalsIgnoreCase('ÇÅ†'), isTrue);
    expect('ß'.equalsIgnoreCase('ß'), isTrue);
  });

  test('count tests', () {
    expect('Hello'.count('l'), equals(2));
    expect('Hello🥶 World😬'.count('🥶'), equals(1));
    expect('Hello🥶 World😬'.count('😬'), equals(1));
    expect('Hello😬 World😬'.count('😬'), equals(2));
    expect('Hello😬 World😬'.count('🥶'), equals(0));
    expect('Hello'.count('L'), equals(0));
    expect('Hello'.count('L', caseSensitive: false), equals(2));
    expect('çå†'.count('å', caseSensitive: false), equals(1));
    expect('çå†'.count('å'), equals(1));
  });

  test('find tests', () {
    // No more tests are required as this is just an alias for [String.indexOf]
    expect('Hello'.find('l'), equals(2));
  });

  test('hasContent tests', () {
    expect(''.hasContent, false);
    expect(' '.hasContent, true);
    String? str;
    expect(str.hasContent, false);
    str = 'abc';
    expect(str.hasContent, true);
  });

  test('orEmpty tests', () {
    expect(''.orEmpty, '');
    expect(' '.orEmpty, ' ');
    String? str;
    expect(str.orEmpty, '');
    str = 'abc';
    expect(str.orEmpty, 'abc');
  });

  test('splitMapJoinRegex test', () {
    final regex = RegExp(r'\$\{(?<name>[a-zA-Z0-9_]+)\}');
    final result = r'Hello ${John}'.splitMapJoinRegex(
      regex,
      onMatch: (match) {
        final name = match.namedGroup('name')!;
        return name.toUpperCase();
      },
      onNonMatch: (text) => text.isNotEmpty ? '?' : '',
    );
    expect(result, equals('?JOHN'));
  });

  test('splitMap test', () {
    final regex = RegExp(r'\$\{(?<name>[a-zA-Z0-9_]+)\}');
    final List<int> result = r'Hello ${John} ${Doe}'.splitMap<int>(
      regex,
      onMatch: (match) {
        final name = match.namedGroup('name')!;
        return name.length;
      },
      onNonMatch: (text) => text.trim().isNotEmpty ? text.trim().length : null,
    );
    expect(result.length, equals(3));
    expect(result, containsAllInOrder([5, 4, 3]));
  });

  test('matchesExactly tests', () {
    expect('123'.matchesExactly(RegExp(r'\d+')), isTrue);
    expect('123a'.matchesExactly(RegExp(r'\d+')), isFalse);
    expect('123a'.contains(RegExp(r'\d+')), isTrue);
  });

  test('isRegex tests', () {
    expect('123'.isRegex, isTrue);
    expect(r'(\d+'.isRegex, isFalse);
    expect(r'\d+'.isRegex, isTrue);
  });

  test('prefix tests', () {
    expect('Save'.prefix('icon'), 'iconSave');
    expect('iconSave'.prefix('icon'), 'iconSave');
    expect('iconSave'.prefix('icon', force: true), 'iconiconSave');
  });

  test('suffix tests', () {
    expect('save'.suffix('Icon'), 'saveIcon');
    expect('saveIcon'.suffix('Icon'), 'saveIcon');
    expect('saveIcon'.suffix('Icon', force: true), 'saveIconIcon');
  });

  test('toBytes tests', () {
    expect('save'.toBytes(), equals([115, 97, 118, 101]));
    expect(utf8.decode([115, 97, 118, 101]), equals('save'));

    expect('save 🎉'.toBytes(),
        equals([115, 97, 118, 101, 32, 240, 159, 142, 137]));
    expect(utf8.decode([115, 97, 118, 101, 32, 240, 159, 142, 137]),
        equals('save 🎉'));

    expect(''.toBytes(), equals([]));
    expect(''.toBytes(), equals(Uint8List(0)));
  });

  test('toUtf16Bytes tests', () {
    expect('save 🎉'.toUtf16Bytes(),
        equals([115, 97, 118, 101, 32, 55356, 57225]));
    expect('save 🎉'.codeUnits, 'save 🎉'.toUtf16Bytes());
    expect(''.toUtf16Bytes(), equals([]));
    expect(''.toUtf16Bytes(), equals(Uint16List(0)));
  });

  test('toUnicodeBytes tests', () {
    expect('save'.toUnicodeBytes(), equals([115, 97, 118, 101]));
    expect('save'.runes, 'save'.toUnicodeBytes());

    expect('save 🎉'.toUnicodeBytes(), equals([115, 97, 118, 101, 32, 127881]));
    expect('save 🎉'.runes, 'save 🎉'.toUnicodeBytes());

    expect(''.toUnicodeBytes(), equals([]));
  });

  test('takeAfter tests', () {
    expect('Hello World'.takeAfter('Hello'), equals(' World'));
    expect('Hello World'.takeAfter('World'), isEmpty);
    expect('Hello World'.takeAfter(''), equals('Hello World'));
    expect('Hello John Wick'.takeAfter('John'), equals(' Wick'));
    expect('12345he321'.takeAfter(RegExp(r'[0-9]+')), equals('he321'));
    expect('Hello World'.takeAfter('Hello World'), isEmpty);
    expect('12345he321'.takeAfter(RegExp(r'[a-z]+')), equals('321'));
    expect('12345he321'.takeAfter(RegExp(r'[A-Z]+')), isEmpty);
  });

  test('takeBefore tests', () {
    expect('Hello World'.takeBefore(' World'), equals('Hello'));
    expect('Hello World'.takeBefore('Hello'), isEmpty);
    expect('Hello World'.takeBefore(''), isEmpty);
    expect('Hello John Wick'.takeBefore(' John'), equals('Hello'));
    expect('12345he3'.takeBefore(RegExp(r'[0-9]+')), isEmpty);
    expect('12345he3'.takeBefore(RegExp(r'[a-z]+')), equals('12345'));
    expect('12345he3'.takeBefore(RegExp(r'[A-Z]+')), isEmpty);
    expect('Hello World'.takeBefore('Hello World'), isEmpty);
  });

  test('takeBetween tests', () {
    expect('<p>Hello</p>'.takeBetween('<p>', '</p>'), equals('Hello'));
    expect('Hello John Wick'.takeBetween('Hello ', ' Wick'), equals('John'));
    expect('12345he3'.takeBetween(RegExp(r'[0-9]+'), RegExp(r'[0-9]+')),
        equals('he'));
    expect(
        '12345he3'.takeBetween(RegExp(r'[0-9]+'), RegExp(r'[a-z]+')), isEmpty);
    expect('12345he3'.takeBetween(RegExp(r'[0-9]+')), equals('he'));
    expect('*Hello*'.takeBetween('*'), equals('Hello'));
  });

  test('takeAfterLast tests', () {
    expect('Hello World'.takeAfterLast('Hello '), equals('World'));
    expect('Hello World'.takeAfterLast('World'), isEmpty);
    expect('Hello World'.takeAfterLast(''), isEmpty);
    expect('123she45he3'.takeAfterLast(RegExp(r'[a-z]+')), equals('3'));
  });

  test('takeBeforeLast tests', () {
    expect('Hello World'.takeBeforeLast(' World'), equals('Hello'));
    expect('Hello World Hello'.takeBeforeLast('Hello'), equals('Hello World '));
    expect('Hello World'.takeBeforeLast('Hello'), isEmpty);
    expect('123she45he3'.takeBeforeLast(RegExp(r'[a-z]+')), equals('123she45'));
    expect('123she45he3'.takeBeforeLast(RegExp(r'[a-z]{3}')), equals('123'));
  });

  test('take tests', () {
    expect('Hello World'.take(5), equals('Hello'));
    expect('Hello World'.take(20), equals('Hello World'));
    expect(''.take(5), equals(''));
    expect('❤️Hello'.take(1), equals('❤️'));
    expect('❤️Hello'.take(6), equals('❤️Hello'));
    expect('❤️Hello'.take(20), equals('❤️Hello'));
  });

  test('takeLast tests', () {
    expect('Hello World'.takeLast(5), equals('World'));
    expect('Hello World'.takeLast(20), equals('Hello World'));
    expect('Hello World'.takeLast(11), equals('Hello World'));
    expect(''.takeLast(5), equals(''));
    expect('Hello ❤️'.takeLast(1), equals('❤️'));
    expect('Hello ❤️'.takeLast(7), equals('Hello ❤️'));
    expect('Hello ❤️'.takeLast(20), equals('Hello ❤️'));
  });
}
