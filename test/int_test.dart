// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('Leap year test', () {
    expect(1992.isLeapYear, true);
    expect(2020.isLeapYear, true);
    expect(2000.isLeapYear, true);
    expect(2100.isLeapYear, false);
  });

  test('Duration conversion tests', () {
    expect(2.weeks, Duration(days: 14));
    expect(5.days, Duration(days: 5));
    expect(5.hours, Duration(hours: 5));
    expect(5.minutes, Duration(minutes: 5));
    expect(5.seconds, Duration(seconds: 5));
    expect(5.milliseconds, Duration(milliseconds: 5));
    expect(5.microseconds, Duration(microseconds: 5));
  });

  test('repeat method tests', () {
    expect(5.repeat((count) => count).length, 5);
    expect(5.repeat((count) => count)[0], 1);
    expect((-5).repeat((count) => count)[0], 1);
  });

  test('length and digits test', () {
    expect(5.length, 1);
    expect(265.length, 3);
    expect(5.digits[0], 5);
    expect(5646.digits[2], 4);
  });

  test('divisibleBy tests', () {
    expect(500.isDivisibleBy(5), true);
    expect(500.isDivisibleByAll([2, 5, 100]), true);
    expect(500.isDivisibleByAll([2, 3, 100]), false);
  });

  test('asBool tests', () {
    expect(500.asBool, true);
    expect(1.asBool, true);
    expect(0.asBool, false);
  });
}
