import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

class StreamSubscriptionMixinTest with StreamSubscriptionMixin {}

class MockFunction extends Mock implements RealFunction {}

class RealFunction {
  void call(dynamic value) {
    print('function called');
  }
}

void main() {
  group('Stream Subscription tests', () {
    late StreamController<int> controller;
    late StreamSubscriptionMixinTest mixin;
    late MockFunction onData;

    setUp(() {
      controller = StreamController<int>.broadcast();
      mixin = StreamSubscriptionMixinTest();
      onData = MockFunction();
    });

    tearDown(() {
      mixin.cancelSubscriptions();
      controller.close();
    });

    test('default scope tests', () async {
      mixin.listenTo(controller.stream, onData);
      controller.add(5);

      // delay to let stream emit.
      await Future<dynamic>.delayed(Duration(milliseconds: 100));
      verify(onData.call(5)).called(1);

      mixin.cancelSubscriptions();
      controller.add(10);

      await Future<dynamic>.delayed(Duration(milliseconds: 100));
      verifyNoMoreInteractions(onData);
    });

    test('custom scope tests', () async {
      mixin.listenTo(controller.stream, onData);
      final scopedOnData = MockFunction();

      // custom scope
      mixin.listenTo(controller.stream, scopedOnData, scope: 'abc');
      controller.add(5);

      // delay to let stream emit.
      await Future<dynamic>.delayed(Duration(milliseconds: 100));
      verify(onData.call(any)).called(1);
      verify(scopedOnData.call(any)).called(1);

      mixin.cancelScopedSubscriptions('abc');
      controller.add(10);

      await Future<dynamic>.delayed(Duration(milliseconds: 100));
      verifyNoMoreInteractions(scopedOnData);
      verify(onData.call(any)).called(1);

      mixin.listenTo(controller.stream, scopedOnData, scope: 'abc');

      controller.add(15);
      await Future<dynamic>.delayed(Duration(milliseconds: 100));

      verify(onData.call(any)).called(1);
      verify(scopedOnData.call(any)).called(1);

      mixin.cancelSubscriptions();
      controller.add(20);

      await Future<dynamic>.delayed(Duration(milliseconds: 100));
      verifyNoMoreInteractions(onData);
      verifyNoMoreInteractions(scopedOnData);
    });
  });
}
