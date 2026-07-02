// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('space tests', () {
    final StringBuffer buffer = StringBuffer();
    buffer.space();
    expect(buffer.toString(), equals(' '));
    buffer
      ..space()
      ..space();
    expect(buffer.toString(), equals('   '));

    buffer.space(3);
    expect(buffer.toString(), equals('      '));
    buffer.space(0);
    expect(buffer.toString(), equals('      '));
    buffer.space(-1);
    expect(buffer.toString(), equals('      '));
  });

  test('newline tests', () {
    final StringBuffer buffer = StringBuffer();
    buffer.newline();
    expect(buffer.toString(), equals('\n'));
    buffer
      ..newline()
      ..newline();
    expect(buffer.toString(), equals('\n\n\n'));

    buffer.newline(3);
    expect(buffer.toString(), equals('\n\n\n\n\n\n'));
    buffer.newline(0);
    expect(buffer.toString(), equals('\n\n\n\n\n\n'));
    buffer.newline(-1);
    expect(buffer.toString(), equals('\n\n\n\n\n\n'));
  });
}
