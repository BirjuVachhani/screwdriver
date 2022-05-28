// Author: Birju Vachhani
// Created Date: August 27, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('future tests', () {
    expectLater(post(() => 5), completes);
    expectLater(post(() => 5), completion(equals(5)));
    expectLater(postDelayed(500, () => 5), completes);
    expectLater(postDelayed(300, () => 5), completion(equals(5)));
  });

  test('runCaching tests', () async {
    await expectLater(runCaching(() async => int.parse('5')), completion(5));
    await expectLater(
        runCaching(() async => int.parse('abc')), throwsException);
    expect(runCaching(() => int.parse('5')), 5);
    expect(runCaching(() => int.parse('5a')), null);
    Object? exception;
    runCaching(() => int.parse('5a'),
        onError: (dynamic error, _) => exception = error);
    expect(exception, isA<FormatException>());
  });
}
