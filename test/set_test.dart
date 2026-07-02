import 'dart:math';

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  group('SetScrewdriver random tests', () {
    test('randomOrNull returns null for empty set', () {
      expect(<int>{}.randomOrNull(), isNull);
    });

    test('random throws StateError for empty set', () {
      expect(() => <int>{}.random(), throwsStateError);
    });

    test('single element set returns the only element', () {
      final set = {42};

      expect(set.randomOrNull(), 42);
      expect(set.random(), 42);
    });

    test('randomOrNull returns an element from the set', () {
      final set = {1, 2, 3, 4, 5};

      final result = set.randomOrNull(Random(42));

      expect(set, contains(result));
    });

    test('randomOrNull returns an element from the set with internal random', () {
      final set = {1, 2, 3, 4, 5};

      final result = set.randomOrNull();

      expect(set, contains(result));
    });

    test('random returns an element from the set', () {
      final set = {1, 2, 3, 4, 5};

      final result = set.random(Random(42));

      expect(set, contains(result));
    });

    test('random returns an element from the set with internal random', () {
      final set = {1, 2, 3, 4, 5};

      final result = set.random();

      expect(set, contains(result));
    });

    test('random works with nullable element type', () {
      final set = <String?>{null};

      expect(set.randomOrNull(), isNull);
      expect(set.random(), isNull);
    });

    test('uses provided Random', () {
      final random = Random(42);
      final set = {1, 2, 3, 4, 5};

      final first = set.random(random);
      final second = set.random(random);

      expect(set, contains(first));
      expect(set, contains(second));
    });
  });
}
