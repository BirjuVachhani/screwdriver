// Author: Birju Vachhani
// Created Date: September 14, 2020

// ignore: import_of_legacy_library_into_null_safe
import 'package:mockito/mockito.dart';
import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('instantiation test', () {
    DeBouncer debouncer = DeBouncer();
    expect(debouncer.duration, Duration(milliseconds: 300));

    debouncer = DeBouncer(Duration(milliseconds: 100));
    expect(debouncer.duration, Duration(milliseconds: 100));

    debouncer = DeBouncer.immediate();
    expect(debouncer.duration, Duration(milliseconds: 300));

    debouncer = DeBouncer.immediate(Duration(milliseconds: 100));
    expect(debouncer.duration, Duration(milliseconds: 100));
  });

  test('de-bouncing test', () async {
    final debouncer = DeBouncer(Duration(milliseconds: 100));
    final mockedFunction = MockedDeBouncedFunction();
    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction.call);
    }
    await Future<void>.delayed(Duration(milliseconds: 200));
    verify(mockedFunction.call()).called(1);

    for (final _ in [1, 2, 3]) {
      debouncer(mockedFunction.call);
    }

    await Future<void>.delayed(Duration(milliseconds: 200));
    verify(mockedFunction.call()).called(1);
  });

  test('de-bouncing test with returns', () async {
    final debouncer = DeBouncer(Duration(milliseconds: 100));
    int mockedFunction(int value) => value + 1;
    late Future<int> result;
    for (final value in [1, 2, 3, 4, 5]) {
      result = debouncer.run(() => mockedFunction(value));
    }

    await expectLater(result, completes);
    await expectLater(result, completion(6));

    Future<int> mockedAsyncFunction(int value) async {
      await Future.delayed(Duration(milliseconds: 100));
      return value + 2;
    }

    late Future<int> asyncResult;
    for (final value in [1, 2, 3, 4, 5]) {
      asyncResult = debouncer.run(() => mockedAsyncFunction(value));
    }

    await expectLater(asyncResult, completes);
    await expectLater(asyncResult, completion(7));
  });

  test('de-bouncing test with immediateFirstRun', () async {
    DeBouncer debouncer = DeBouncer.immediate(Duration(milliseconds: 100));
    final MockedDeBouncedFunction mockedFunction = MockedDeBouncedFunction();
    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction.call);
    }
    verify(mockedFunction.call()).called(1);
    await Future<void>.delayed(Duration(milliseconds: 200));

    verify(mockedFunction.call()).called(1);
    verifyNoMoreInteractions(mockedFunction);

    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction.call);
    }
    await Future<void>.delayed(Duration(milliseconds: 200));

    verify(mockedFunction.call()).called(2);
    verifyNoMoreInteractions(mockedFunction);

    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction.call, immediateFirstRun: false);
    }
    await Future<void>.delayed(Duration(milliseconds: 200));
    verify(mockedFunction.call()).called(1);
    verifyNoMoreInteractions(mockedFunction);

    debouncer = DeBouncer(Duration(milliseconds: 100));
    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction.call, immediateFirstRun: true);
    }
    verify(mockedFunction.call()).called(1);
    await Future<void>.delayed(Duration(milliseconds: 100));
    verify(mockedFunction.call()).called(1);
    verifyNoMoreInteractions(mockedFunction);
  });

  test('de-bouncer cancel test', () async {
    final debouncer = DeBouncer(Duration(milliseconds: 100));
    final mockedFunction = MockedDeBouncedFunction();
    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction.call);
    }
    debouncer.cancel();
    await Future<void>.delayed(Duration(milliseconds: 200));
    verifyNever(mockedFunction.call());
  });

  test('isRunning test', () async {
    final debouncer = DeBouncer(Duration(milliseconds: 100));
    final mockedFunction = MockedDeBouncedFunction();
    for (final _ in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction.call);
    }
    expect(debouncer.isRunning, isTrue);
    await Future<void>.delayed(Duration(milliseconds: 200));
    verify(mockedFunction.call()).called(1);
    expect(debouncer.isRunning, isFalse);

    for (final _ in [1, 2, 3]) {
      debouncer(mockedFunction.call);
    }

    expect(debouncer.isRunning, isTrue);
    await Future<void>.delayed(Duration(milliseconds: 200));
    verify(mockedFunction.call()).called(1);
    expect(debouncer.isRunning, isFalse);
  });

  test('Global de-bouncing test', () async {
    final mockedFunction = MockedDeBouncedFunction();
    for (final _ in [1, 2, 3, 4, 5]) {
      debounce(mockedFunction.call);
    }
    await Future<void>.delayed(Duration(milliseconds: 600));
    verify(mockedFunction.call()).called(1);

    for (final _ in [1, 2, 3]) {
      debounce(mockedFunction.call);
    }

    await Future<void>.delayed(Duration(milliseconds: 600));
    verify(mockedFunction.call()).called(1);
  });

  test('Global de-bouncer cancel test', () async {
    final mockedFunction = MockedDeBouncedFunction();
    for (final _ in [1, 2, 3, 4, 5]) {
      debounce(mockedFunction.call);
    }
    debouncer.cancel();
    await Future<void>.delayed(Duration(milliseconds: 600));
    verifyNever(mockedFunction.call());
  });
}

class MockedDeBouncedFunction extends Mock implements DeBouncedFunction {}

class MockedReturningDeBouncedFunction<R> extends Mock
    implements ReturningDeBouncedFunction<R> {}

class MockedReturningDeBouncedAsyncFunction<R> extends Mock
    implements ReturningDeBouncedAsyncFunction<R> {}

class DeBouncedFunction {
  void call() {
    print('Function called');
  }
}

class ReturningDeBouncedFunction<R> {
  R call(R value) {
    print('Function called');
    return value;
  }
}

class ReturningDeBouncedAsyncFunction<R> {
  Future<R> call(R value) async {
    print('Function called');
    await Future.delayed(Duration(milliseconds: 100));
    return value;
  }
}
