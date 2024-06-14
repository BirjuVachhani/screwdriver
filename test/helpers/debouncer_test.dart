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
      debouncer.run(mockedFunction.call);
    }
    await Future<void>.delayed(Duration(milliseconds: 600));
    verify(mockedFunction.call()).called(1);

    for (final _ in [1, 2, 3]) {
      debouncer(mockedFunction.call);
    }

    await Future<void>.delayed(Duration(milliseconds: 600));
    verify(mockedFunction.call()).called(1);
  });

  test('de-bouncing test with immediateFirstRun', () async {
    DeBouncer debouncer = DeBouncer.immediate();
    final MockedDeBouncedFunction mockedFunction = MockedDeBouncedFunction();
    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction.call);
    }
    verify(mockedFunction.call()).called(1);
    await Future<void>.delayed(Duration(milliseconds: 600));

    verify(mockedFunction.call()).called(1);
    verifyNoMoreInteractions(mockedFunction);

    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction.call);
    }
    await Future<void>.delayed(Duration(milliseconds: 600));

    verify(mockedFunction.call()).called(2);
    verifyNoMoreInteractions(mockedFunction);

    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction.call, immediateFirstRun: false);
    }
    await Future<void>.delayed(Duration(milliseconds: 600));
    verify(mockedFunction.call()).called(1);
    verifyNoMoreInteractions(mockedFunction);

    debouncer = DeBouncer();
    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction.call, immediateFirstRun: true);
    }
    verify(mockedFunction.call()).called(1);
    await Future<void>.delayed(Duration(milliseconds: 300));
    verify(mockedFunction.call()).called(1);
    verifyNoMoreInteractions(mockedFunction);
  });

  test('de-bouncer cancel test', () async {
    final debouncer = DeBouncer();
    final mockedFunction = MockedDeBouncedFunction();
    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction.call);
    }
    debouncer.cancel();
    await Future<void>.delayed(Duration(milliseconds: 600));
    verifyNever(mockedFunction.call());
  });

  test('isRunning test', () async {
    final debouncer = DeBouncer();
    final mockedFunction = MockedDeBouncedFunction();
    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction.call);
    }
    expect(debouncer.isRunning, isTrue);
    await Future<void>.delayed(Duration(milliseconds: 600));
    verify(mockedFunction.call()).called(1);
    expect(debouncer.isRunning, isFalse);

    for (final _ in [1, 2, 3]) {
      debouncer(mockedFunction.call);
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
