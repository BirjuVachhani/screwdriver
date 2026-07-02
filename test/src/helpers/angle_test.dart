// Author: Birju Vachhani
// Created Date: November 14, 2024

import 'dart:math';

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('Degrees test', () {
    expect(Degrees(180), equals(180));
    expect(Degrees(-120), equals(-120));
    expect(Degrees(30.5), equals(30.5));

    expect(Degrees(180).inRadians, equals(pi));
    expect(Degrees(-120).inRadians, equals(-2 * pi / 3));

    expect(Degrees(180).inTurns, equals(0.5));
    expect(Degrees(360).inTurns, equals(1));
    expect(Degrees(720).inTurns, equals(2));
    expect(Degrees(-120).inTurns, equals(-1 / 3));
  });

  test('Radians test', () {
    expect(Radians(pi), equals(pi));
    expect(Radians(-pi / 2), equals(-pi / 2));
    expect(Radians(0.5), equals(0.5));

    expect(Radians(pi).inDegrees, equals(180));
    expect(Radians(-pi / 2).inDegrees, equals(-90));

    expect(Radians(pi).inTurns, equals(0.5));
    expect(Radians(2 * pi).inTurns, equals(1));
    expect(Radians(-pi / 2).inTurns, equals(-0.25));
  });

  test('Turns test', () {
    expect(Turns(0.5), equals(0.5));
    expect(Turns(-0.25), equals(-0.25));
    expect(Turns(1), equals(1));

    expect(Turns(0.5).inDegrees, equals(180));
    expect(Turns(-0.25).inDegrees, equals(-90));

    expect(Turns(0.5).inRadians, equals(pi));
    expect(Turns(1).inRadians, equals(2 * pi));
    expect(Turns(-0.25).inRadians, equals(-pi / 2));
  });
}
