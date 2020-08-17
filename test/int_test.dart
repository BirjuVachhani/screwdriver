// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('Leap year test', () {
    assert(1992.isLeapYear);
    assert(2020.isLeapYear);
    assert(2000.isLeapYear);
    assert(2100.isLeapYear);
  });

  test('Duration conversion tests', () {
    assert(5.days == Duration(days: 5));
    assert(5.hours == Duration(hours: 5));
    assert(5.minutes == Duration(minutes: 5));
    assert(5.seconds == Duration(seconds: 5));
    assert(5.milliseconds == Duration(milliseconds: 5));
    assert(5.microseconds == Duration(microseconds: 5));
  });

  test('repeat method tests', () {
    assert(5.repeat((count) => count).length == 5);
    assert(5.repeat((count) => count)[0] == 1);
    assert((-5).repeat((count) => count)[0] == 1);
  });
}
