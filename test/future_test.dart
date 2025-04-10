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
    expect(runCaching(() => int.parse('5')), 5);
    expect(runCaching(() => int.parse('5')), isNot(isA<Future<dynamic>>()));
    expect(await runCaching(() => int.parse('5')), 5);
    expect(() => runCaching(() => int.parse('abc')), isNot(throwsException));
    expect(runCaching(() async => int.parse('abc')), completes);
    expect(runCaching(() async => int.parse('abc')), completion(null));
    expect(
        runCaching(() => int.parse('abc'), onError: (_, __) => -1), equals(-1));
    expect(runCaching(() async => int.parse('abc'), onError: (_, __) => -1),
        completion(-1));
    expect(runCaching(() {}), isA<void>());
    expect(runCaching(() {}), isNot(throwsException));
    expect(runCaching(() => throw Exception()), isNot(throwsException));

    expect(
        runCaching(() => throw Exception(),
            onError: (_, __) => throw UnimplementedError()),
        isNot(throwsException));
    expect(
        await runCaching(() async => throw Exception(),
            onError: (_, __) => throw UnimplementedError()),
        isNot(throwsException));

    await expectLater(await runCaching(() => int.parse('5')), 5);
    await expectLater(await runCaching(() => int.parse('5a')), null);

    Object? exception;
    await runCaching(() => int.parse('5a'),
        onError: (dynamic error, _) => exception = error);
    expect(exception, isA<FormatException>());
  });

  Future<int> someFuture(int value) async {
    if (value < 0) throw ArgumentError('Value must be greater than zero');
    return Future.value(value);
  }

  test('tryCatch extension tests', () async {
    expect(() => someFuture(22).tryCatch(), returnsNormally);
    expect(() => someFuture(-1).tryCatch(), returnsNormally);
    expect(someFuture(20).tryCatch(), completion(equals((20, null))));
    expect(
        someFuture(-20).tryCatch(), completion(isA<(int?, TryCatchError)>()));

    final (data, error) = await someFuture(-54).tryCatch();
    expect(data, isNull);
    expect(error, isNotNull);
    expect(error?.error, isArgumentError);
    expect(error?.stacktrace, isNotNull);
  });
}
