import 'package:screwdriver/src/helpers/consumable.dart';
import 'package:test/test.dart';

void main() {
  group('Top-level functions', () {
    test('consumeOnce creates a single-use consumable', () {
      final consumable = consumeOnce(42);
      expect(consumable, isA<SingleConsumable<int>>());
      expect(consumable.consume(), equals(42));
      expect(consumable.consume(), isNull);
    });

    test('consume creates a multi-use consumable', () {
      final consumable = consume(42, times: 2);
      expect(consumable, isA<MultiConsumable<int>>());
      expect(consumable.consume(), equals(42));
      expect(consumable.consume(), equals(42));
      expect(consumable.consume(), isNull);
    });

    test('consume defaults to single use when times not specified', () {
      final consumable = consume(42);
      expect(consumable.consume(), equals(42));
      expect(consumable.consume(), isNull);
    });

    test('consume throws ArgumentError when times is negative', () {
      expect(() => consume(42, times: -1), throwsA(isA<ArgumentError>()));
      expect(() => consume(consume(22)), throwsArgumentError);
      expect(() => consumeOnce(consume(22)), throwsArgumentError);
      expect(() => consumeOnce(consumeOnce(22)), throwsArgumentError);
      expect(() => consume(consumeOnce(22)), throwsArgumentError);
    });
  });

  group('Consumable', () {
    test('Consumable.single creates single-use consumable', () {
      final consumable = Consumable<int>.single(42);
      expect(consumable, isA<SingleConsumable<int>>());
      expect(consumable.consume(), equals(42));
      expect(consumable.consume(), isNull);
      expect(() => Consumable.single(Consumable.single(12)), throwsArgumentError);
      expect(() => Consumable.single(Consumable.multi(12)), throwsArgumentError);
    });

    test('Consumable.multi creates multi-use consumable', () {
      final consumable = Consumable<int>.multi(42, times: 2);
      expect(consumable, isA<MultiConsumable<int>>());
      expect(consumable.consume(), equals(42));
      expect(consumable.consume(), equals(42));
      expect(consumable.consume(), isNull);
      expect(() => Consumable.multi(Consumable.multi(12)), throwsArgumentError);
      expect(() => Consumable.multi(Consumable.single(12)), throwsArgumentError);
    });

    test('isConsumed returns correct state', () {
      final consumable = Consumable<int>.single(42);
      expect(consumable.isConsumed, isFalse);
      consumable.consume();
      expect(consumable.isConsumed, isTrue);
    });

    test('canConsume returns correct state', () {
      final consumable = Consumable<int>.single(42);
      expect(consumable.canConsume, isTrue);
      consumable.consume();
      expect(consumable.canConsume, isFalse);
    });

    test('markConsumed makes value unavailable', () {
      final consumable = Consumable<int>.single(42);
      expect(consumable.canConsume, isTrue);
      consumable.markConsumed();
      expect(consumable.canConsume, isFalse);
      expect(consumable.consume(), isNull);
    });
  });

  group('SingleConsumable', () {
    test('can only be consumed once', () {
      final consumable = SingleConsumable(42);
      expect(consumable.consume(), equals(42));
      expect(consumable.consume(), isNull);
      expect(() => SingleConsumable(SingleConsumable('Hello')), throwsArgumentError);
      expect(() => SingleConsumable(MultiConsumable('Hello')), throwsArgumentError);
    });

    test('becomes consumed after first use', () {
      final consumable = SingleConsumable(42);
      expect(consumable.isConsumed, isFalse);
      consumable.consume();
      expect(consumable.isConsumed, isTrue);
    });
  });

  group('MultiConsumable', () {
    test('can be consumed specified number of times', () {
      final consumable = MultiConsumable(42, times: 3);
      expect(consumable.count, equals(3));
      expect(consumable.consume(), equals(42));
      expect(consumable.consume(), equals(42));
      expect(consumable.consume(), equals(42));
      expect(consumable.consume(), isNull);
      expect(() => MultiConsumable(MultiConsumable('Hello')), throwsArgumentError);
      expect(() => MultiConsumable(SingleConsumable('Hello')), throwsArgumentError);
    });

    test('becomes consumed after all uses exhausted', () {
      final consumable = MultiConsumable(42, times: 2);
      expect(consumable.isConsumed, isFalse);
      consumable.consume();
      expect(consumable.isConsumed, isFalse);
      expect(consumable.remaining, equals(1));
      consumable.consume();
      expect(consumable.isConsumed, isTrue);
      expect(consumable.remaining, equals(0));
    });

    test('markConsumed exhausts all remaining uses', () {
      final consumable = MultiConsumable(42, times: 3);
      expect(consumable.canConsume, isTrue);
      consumable.markConsumed();
      expect(consumable.canConsume, isFalse);
      expect(consumable.consume(), isNull);
    });

    test('defaults to single use when times not specified', () {
      final consumable = MultiConsumable(42);
      expect(consumable.count, equals(1));
      expect(consumable.consume(), equals(42));
      expect(consumable.consume(), isNull);
    });
  });
}
