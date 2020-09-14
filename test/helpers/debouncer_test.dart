// Author: Birju Vachhani
// Created Date: September 14, 2020

import 'package:mockito/mockito.dart';
import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('instantiation test', () {
    final debouncer = DeBouncer();
    expect(debouncer.duration, Duration(milliseconds: 300));
  });

  test('de-bouncing test', () async{
    final debouncer = DeBouncer();
    final mockedFunction = MockedDeBouncedFunction();
    for (final index in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction);
    }
    await Future.delayed(Duration(milliseconds: 600));
    verify(mockedFunction.call()).called(1);

    for (final index in [1, 2, 3]) {
      debouncer(mockedFunction);
    }

    await Future.delayed(Duration(milliseconds: 600));
    verify(mockedFunction.call()).called(1);
  });

  test('de-bouncer cancel test', () async{
    final debouncer = DeBouncer();
    final mockedFunction = MockedDeBouncedFunction();
    for (final index in [1, 2, 3, 4, 5]) {
      debouncer.run(mockedFunction);
    }
    debouncer.cancel();
    await Future.delayed(Duration(milliseconds: 600));
    verifyNever(mockedFunction.call());
  });
}

class MockedDeBouncedFunction extends Mock implements DeBouncedFunction {}

class DeBouncedFunction {
  int call() {
    print('Function called');
  }
}
