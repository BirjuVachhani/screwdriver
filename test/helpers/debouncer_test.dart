// Author: Birju Vachhani
// Created Date: September 14, 2020

// ignore: import_of_legacy_library_into_null_safe
import 'package:mockito/mockito.dart';
import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('instantiation test', () {
    final debouncer = DeBouncer();
    expect(debouncer.duration, Duration(milliseconds: 300));
  });

  test('de-bouncing test', () async {
    final debouncer = DeBouncer();
    final mockedFunction = MockedDeBouncedFunction();
    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction);
    }
    await Future<void>.delayed(Duration(milliseconds: 600));
    verify(mockedFunction.call()).called(1);

    for (final _ in [1, 2, 3]) {
      debouncer(mockedFunction);
    }

    await Future<void>.delayed(Duration(milliseconds: 600));
    verify(mockedFunction.call()).called(1);
  });

  test('de-bouncer cancel test', () async {
    final debouncer = DeBouncer();
    final mockedFunction = MockedDeBouncedFunction();
    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction);
    }
    debouncer.cancel();
    await Future<void>.delayed(Duration(milliseconds: 600));
    verifyNever(mockedFunction.call());
  });

  test('isRunning test', () async {
    final debouncer = DeBouncer();
    final mockedFunction = MockedDeBouncedFunction();
    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction);
    }
    expect(debouncer.isRunning, isTrue);
    await Future<void>.delayed(Duration(milliseconds: 600));
    verify(mockedFunction.call()).called(1);
    expect(debouncer.isRunning, isFalse);

    for (final _ in [1, 2, 3]) {
      debouncer(mockedFunction);
    }

    expect(debouncer.isRunning, isTrue);
    await Future<void>.delayed(Duration(milliseconds: 600));
    verify(mockedFunction.call()).called(1);
    expect(debouncer.isRunning, isFalse);
  });
}

class MockedDeBouncedFunction extends Mock implements DeBouncedFunction {}

class DeBouncedFunction {
  void call() {
    print('Function called');
  }
}
