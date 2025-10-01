// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'dart:math';

import 'package:screwdriver/screwdriver.dart' hide DoubleScrewdriver;
import 'package:test/test.dart';

void main() {
  test('negative conversion test', () {
    expect(5.negative.isNegative, true);
    expect(5.0.negative.isNegative, true);
    expect((-20).negative.isNegative, true);
    expect((-20.0).negative.isNegative, true);
  });

  test('isBetween tests', () {
    expect(500.isBetween(100, 700), true);
    expect(500.isBetween(700, 300), true);
    expect(300.isBetween(700, 300, inclusive: true), true);
    expect(500.isBetween(400, 100), false);
    expect(500.isBetween(100, 400), false);
    expect(500.48.isBetween(500.0, 510.0), true);
    expect(500.00.isBetween(500.0, 510.0, inclusive: true), true);
  });

  test('roundToPrecision tests', () {
    expect(2.roundToPrecision(0), 2);
    expect(2.1234567890.roundToPrecision(0), 2.0);
    expect(2.1234567890.roundToPrecision(3), 2.123);

    expect(double.nan.roundToPrecision(2), isNaN);
    expect(double.infinity.roundToPrecision(2), double.infinity);
    expect(double.negativeInfinity.roundToPrecision(2), double.negativeInfinity);
  });

  test('nullable num tests', () {
    num? nullableNum;
    int? nullableInt;
    double? nullableDouble;
    expect(nullableNum.orOne, 1);
    expect(nullableInt.orOne, 1);
    expect(nullableDouble.orOne, 1);

    expect(nullableNum.orZero, 0);
    expect(nullableInt.orZero, 0);
    expect(nullableDouble.orZero, 0);

    expect(nullableNum.or(5), 5);
    expect(nullableInt.or(10), 10);
    expect(nullableDouble.or(25.5), 25.5);

    nullableNum = 5;
    nullableInt = 10;
    nullableDouble = 25.5;

    expect(nullableNum.orOne, 5);
    expect(nullableInt.orOne, 10);
    expect(nullableDouble.orOne, 25.5);

    expect(nullableNum.orZero, 5);
    expect(nullableInt.orZero, 10);
    expect(nullableDouble.orZero, 25.5);
  });

  test('max tests', () {
    expect(5.max(10), equals(5));
    expect(5.max(10), equals(5));
    expect(15.max(10, exclusive: true), equals(10));
  });

  test('min tests', () {
    expect(5.min(2), equals(5));
    expect(5.min(2), equals(5));
    expect(1.min(2, exclusive: true), equals(2));
  });

  test('clampAtLeast', () {
    expect(5.clampAtLeast(2), equals(5));
    expect(5.clampAtLeast(2), equals(5));
    expect(1.clampAtLeast(2), equals(2));
    expect(0.clampAtLeast(2), equals(2));
    expect((-10).clampAtLeast(0), equals(0));
  });

  test('clampAtMost', () {
    expect(5.clampAtMost(10), equals(5));
    expect(5.clampAtMost(10), equals(5));
    expect(15.clampAtMost(10), equals(10));
    expect(20.clampAtMost(10), equals(10));
    expect((-100).clampAtMost(0), equals(-100));
  });

  test('degrees tests', () {
    expect(180.degrees, equals(180));
    expect(180.degrees.inRadians, equals(pi));
    expect(180.degrees.inRadians.inDegrees, equals(180));
  });

  test('radians tests', () {
    expect(pi.radians, equals(pi));
    expect(pi.radians.inDegrees, equals(180));
    expect(pi.radians.inDegrees.inRadians, equals(pi));
  });

  test('turns tests', () {
    expect(0.5.turns, equals(0.5));
    expect(0.5.turns.inDegrees, equals(180));
    expect(0.5.turns.inRadians, equals(pi));
  });

  test('plus tests', () {
    expect(5.plus(4), equals(9));
    expect(5.plus(4), isA<int>());
    int? nullableInt;
    Future.delayed(Duration(seconds: 1), () {
      nullableInt = 5;
    });
    expect(nullableInt?.plus(4), isNull);

    expect(5.0.plus(4), equals(9.0));
    expect(5.0.plus(4), isA<double>());
    double? nullableDouble;
    Future.delayed(Duration(seconds: 1), () {
      nullableDouble = 5.0;
    });
    expect(nullableDouble?.plus(4), isNull);

    num numValue = 5;
    expect(numValue.plus(4), equals(9));
    expect(numValue.plus(4), isA<num>());
    num? nullableNum;
    Future.delayed(Duration(seconds: 1), () {
      nullableNum = 5;
    });
    expect(nullableNum?.plus(4), isNull);
  });

  test('minus tests', () {
    expect(5.minus(4), equals(1));
    expect(5.minus(4), isA<int>());
    int? nullableInt;
    Future.delayed(Duration(seconds: 1), () {
      nullableInt = 5;
    });
    expect(nullableInt?.minus(4), isNull);

    expect(5.0.minus(4), equals(1.0));
    expect(5.0.minus(4), isA<double>());
    double? nullableDouble;
    Future.delayed(Duration(seconds: 1), () {
      nullableDouble = 5.0;
    });
    expect(nullableDouble?.minus(4), isNull);

    num numValue = 5;
    expect(numValue.minus(4), equals(1));
    expect(numValue.minus(4), isA<num>());
    num? nullableNum;
    Future.delayed(Duration(seconds: 1), () {
      nullableNum = 5;
    });
    expect(nullableNum?.minus(4), isNull);
  });

  test('multiply tests', () {
    expect(5.multiply(4), equals(20));
    expect(5.multiply(4), isA<int>());
    int? nullableInt;
    Future.delayed(Duration(seconds: 1), () {
      nullableInt = 5;
    });
    expect(nullableInt?.multiply(4), isNull);

    expect(5.0.multiply(4), equals(20.0));
    expect(5.0.multiply(4), isA<double>());
    double? nullableDouble;
    Future.delayed(Duration(seconds: 1), () {
      nullableDouble = 5.0;
    });
    expect(nullableDouble?.multiply(4), isNull);

    num numValue = 5;
    expect(numValue.multiply(4), equals(20));
    expect(numValue.multiply(4), isA<num>());
    num? nullableNum;
    Future.delayed(Duration(seconds: 1), () {
      nullableNum = 5;
    });
    expect(nullableNum?.multiply(4), isNull);
  });

  test('divide tests', () {
    expect(20.divide(4), equals(5));
    expect(20.divide(4), isA<double>());
    int? nullableInt;
    Future.delayed(Duration(seconds: 1), () {
      nullableInt = 20;
    });
    expect(nullableInt?.divide(4), isNull);

    expect(20.0.divide(4), equals(5.0));
    expect(20.0.divide(4), isA<double>());
    double? nullableDouble;
    Future.delayed(Duration(seconds: 1), () {
      nullableDouble = 20.0;
    });
    expect(nullableDouble?.divide(4), isNull);

    num numValue = 20;
    expect(numValue.divide(4), equals(5));
    expect(numValue.divide(4), isA<num>());
    num? nullableNum;
    Future.delayed(Duration(seconds: 1), () {
      nullableNum = 20;
    });
    expect(nullableNum?.divide(4), isNull);
  });

  test('mod tests', () {
    expect(20.mod(4), equals(0));
    expect(20.mod(4), isA<int>());
    int? nullableInt;
    Future.delayed(Duration(seconds: 1), () {
      nullableInt = 20;
    });
    expect(nullableInt?.mod(4), isNull);

    expect(20.0.mod(4), equals(0.0));
    expect(20.0.mod(4), isA<double>());
    double? nullableDouble;
    Future.delayed(Duration(seconds: 1), () {
      nullableDouble = 20.0;
    });
    expect(nullableDouble?.mod(4), isNull);

    num numValue = 20;
    expect(numValue.mod(4), equals(0));
    expect(numValue.mod(4), isA<num>());
    num? nullableNum;
    Future.delayed(Duration(seconds: 1), () {
      nullableNum = 20;
    });
    expect(nullableNum?.mod(4), isNull);
  });
}
