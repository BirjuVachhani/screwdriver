// Author: Birju Vachhani
// Created Date: February 15, 2026

import 'dart:async';

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  group('StreamScrewdriver', () {
    test('waitFor returns the item when stream emits it', () async {
      final controller = StreamController<int>();
      final future = controller.stream.waitFor(3);

      controller.add(1);
      controller.add(2);
      controller.add(3);

      expect(await future, equals(3));
      await controller.close();
    });

    test('waitFor returns the first matching item', () async {
      final controller = StreamController<int>();
      final future = controller.stream.waitFor(5);

      controller.add(5);
      controller.add(5);

      expect(await future, equals(5));
      await controller.close();
    });

    test('waitFor works with string streams', () async {
      final controller = StreamController<String>();
      final future = controller.stream.waitFor('hello');

      controller.add('world');
      controller.add('hello');

      expect(await future, equals('hello'));
      await controller.close();
    });

    test('waitFor throws StateError when stream closes without match', () {
      final controller = StreamController<int>();
      final future = controller.stream.waitFor(99);

      controller.add(1);
      controller.add(2);
      controller.close();

      expect(future, throwsA(isA<StateError>()));
    });

    test('waitFor works with broadcast streams', () async {
      final controller = StreamController<int>.broadcast();
      final future = controller.stream.waitFor(7);

      controller.add(7);

      expect(await future, equals(7));
      await controller.close();
    });

    test('whereType filters', () {
      final stream = Stream.fromIterable([1, 2.0, 'Hello', true]);

      final typed = stream.whereType<String>();
      expect(typed, isA<Stream<String>>());
      expect(typed, emitsInAnyOrder(['Hello']));
      expect(typed, neverEmits([1, 2.0, true]));
    });

    test('whereType filter on nullable stream', () {
      final stream = Stream.fromIterable([null, 1, 2.0, 'Hello', true]);

      final typed = stream.whereType<int>();
      expect(typed, isA<Stream<int>>());
      expect(typed, emitsInOrder([1]));
      expect(typed, neverEmits([null, 'Hello', 2.0, true]));
    });
  });

  group('NullableStreamScrewdriver', () {
    test('nonNulls test', () {
      final stream = Stream.fromIterable([null, 1, 2.0, 'Hello', true]);
      final nonNullStream = stream.nonNulls;

      expect(nonNullStream, isA<Stream<Object>>());
      expect(nonNullStream, neverEmits(null));
      expect(nonNullStream, emitsInOrder([1, 2.0, 'Hello', true]));
    });
  });
}
