/*
 *  Copyright (c) 2020, Birju Vachhani
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 *  1. Redistributions of source code must retain the above copyright notice,
 *     this list of conditions and the following disclaimer.
 *
 *  2. Redistributions in binary form must reproduce the above copyright notice,
 *     this list of conditions and the following disclaimer in the documentation
 *     and/or other materials provided with the distribution.
 *
 *  3. Neither the name of the copyright holder nor the names of its
 *     contributors may be used to endorse or promote products derived from
 *     this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 *  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 *  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *  POSSIBILITY OF SUCH DAMAGE.
 */

// Author: Birju Vachhani
// Created Date: August 20, 2020

import 'dart:typed_data';

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('isNullOrEmpty tests', () {
    expect(<int>[].isNullOrEmpty, true);
    expect([null].isNullOrEmpty, false);
    expect([1, 2, 3].isNullOrEmpty, false);
    List<int>? numbers;
    expect(numbers.isNullOrEmpty, true);
    numbers = [1, 2];
    expect(numbers.isNullOrEmpty, false);
  });

  test('isNotNullOrEmpty tests', () {
    expect(<double>[].isNotNullOrEmpty, false);
    expect([null].isNotNullOrEmpty, true);
    expect([1, 2, 3].isNotNullOrEmpty, true);
    List<int>? numbers;
    expect(numbers.isNotNullOrEmpty, false);
    numbers = [1, 2];
    expect(numbers.isNotNullOrEmpty, true);
  });

  test('isBlank tests', () {
    expect(<int>[].isBlank, isTrue);
    expect([null].isBlank, isFalse);
    expect([1, 2, 3].isBlank, isFalse);
    List<int>? numbers;
    expect(numbers.isBlank, isTrue);
    numbers = [1, 2];
    expect(numbers.isBlank, isFalse);
  });

  test('isNotBlank tests', () {
    expect(<double>[].isNotBlank, isFalse);
    expect([null].isNotBlank, isTrue);
    expect([1, 2, 3].isNotBlank, isTrue);
    List<int>? numbers;
    expect(numbers.isNotBlank, isFalse);
    numbers = [1, 2];
    expect(numbers.isNotBlank, isTrue);
  });

  test('getter tests', () {
    final list = [1, 2, 3];
    expect(list.secondOrNull, 2);
    expect(list.thirdOrNull, 3);
    expect(list.lastOrNull, 3);
    expect(<dynamic>[].secondOrNull, null);
    expect(<String>[].thirdOrNull, null);
  });

  test('actions tests', () {
    final list = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    // filter
    expect(list.filter((element) => element.isEven), equals([2, 4, 6, 8]));
    expect(<int>[].filter((element) => element.isEven), equals(<int>[]));

    // filterTo
    expect(list.filterTo([1, 3], (element) => element == 5).toList(), equals([1, 3, 5]));
    expect(<int>[].filterTo([1, 2], (element) => element.isEven), equals([1, 2]));

    // filterIndexed
    expect(list.filterIndexed((index, element) => index.isEven), equals([1, 3, 5, 7, 9]));

    // flatMap
    expect(
        [
          [1],
          [2]
        ].flatMap((element) => element.map((e) => e * 10)),
        equals([10, 20]));
    expect(<List<int>>[].flatMap((element) => element.map((e) => e * 10)), equals(<int>[]));

    // flatMapNotNull
    final List<List<int>?> nullableNestedList = [
      [1],
      null,
      [2]
    ];
    expect(nullableNestedList.flatMapNotNull((element) => element?.map((e) => e * 10)), equals(<int>[10, 20]));

    // mapNotNull
    final List<double?> nullableList = [1.0, null, 2.0];
    expect(nullableList.mapNotNull((element) => element?.multiply(10)), equals([10.0, 20.0]));
    expect([].mapNotNull((element) => element?.multiply(10)), isEmpty);

    // mapNotNullIndexed
    expect(list.mapNotNullIndexed((index, element) => index.isEven ? element : null), equals([1, 3, 5, 7, 9]));
    expect(nullableList.mapNotNullIndexed((index, element) => element), equals([1.0, 2.0]));

    // drop
    expect(list.drop(7), equals([8, 9]));
    expect(list.drop(10), equals(<int>[]));

    // takeLast
    expect(list.takeLast(3), equals([7, 8, 9]));
    expect(<int>[].takeLast(3), equals(<int>[]));
    expect([1, 2].takeLast(3), equals([1, 2]));

    // dropWhile
    expect(list.dropWhile((element) => element != 7), equals([7, 8, 9]));
    expect(<int>[].dropWhile((element) => element != 7), equals(<int>[]));

    // dropLast
    expect(list.dropLast(7), equals([1, 2]));
    expect(<int>[].takeLast(3), equals(<int>[]));
    expect([1, 2].dropLast(3), equals(<int>[]));

    // all
    expect(list.all((element) => element < 10), true);
    expect(list.all((element) => element < 8), false);
    expect(<int>[].all((element) => element < 10), true);

    // associate
    expect([DateTime(2015), DateTime(2020)].associate((element) => (element.year, element.isLeapYear)),
        equals({2015: false, 2020: true}));

    // toMap
    expect([DateTime(2015), DateTime(2020)].toMap((element) => (element.year, element.isLeapYear)),
        equals({2015: false, 2020: true}));

    // associateBy
    expect([DateTime(2015), DateTime(2020)].associateBy((element) => element.year),
        equals({2015: DateTime(2015), 2020: DateTime(2020)}));

    // associateWith
    expect([DateTime(2015), DateTime(2020)].associateWith((element) => element.isLeapYear),
        equals({DateTime(2015): false, DateTime(2020): true}));

    // groupBy
    expect(
        list.groupBy((element) => element.isEven ? 'even' : 'odd'),
        equals({
          'even': [2, 4, 6, 8],
          'odd': [1, 3, 5, 7, 9],
        }));

    // distinct
    expect([1, 1, 2, 2, 2, 3, 4, 4, 5, 5, 5].distinct(), [1, 2, 3, 4, 5]);

    // distinctBy
    expect([1, 1, 2, 2, 2, 3, 4, 4, 5, 5, 5, 6].distinctBy((element) => element % 3), [1, 2, 3]);

    // intersect
    expect([1, 2, 3].intersect([2, 3, 4, 5]), equals([2, 3]));

    // subtract
    expect([1, 2, 3].subtract([2, 3, 4, 5]), equals([1]));

    // union
    expect([1, 2].union([2, 4, 5]), equals([1, 2, 4, 5]));

    // countBy
    expect(list.countBy((element) => element.isOdd), 5);
    expect(<int>[].countBy((element) => element.isOdd), 0);

    // count
    expect([1, 1, 2, 3, 4, 5, 7, 1, 5, 1].count(1), 4);
    expect([1, 1, 2, 3, 4, 5, 7, 1, 5, 1].count(22), 0);
    expect(<int>[].count(5), 0);

    // foldRight
    expect([1, 2, 3].foldRight<int>(0, (previousValue, element) => previousValue * 2 + element), 17);

    // foldRightIndexed
    expect(
        [1, 2, 3].foldRightIndexed<int>(0, (index, previousValue, element) => previousValue + index * 2 + element), 12);

    // except tests
    expect([1, 2, 3].except(2), containsAllInOrder(<int>[1, 3]));
    expect([1, 2, 3].except(1, 5), containsAllInOrder(<int>[2, 3]));
    expect([1, 2, 3, 4, 5, 6].except(1, 2, 3, 4, 5, 6), isEmpty);
    expect([4, 5, 6].except(1, 2, 3, 4, 5, 6), isEmpty);
    expect([1, 2, 3, 'Hello', 5, 6].except(1, 2, 3, 'Hello'), containsAllInOrder(<int>[5, 6]));

    // exceptAll tests
    expect([1, 2, 3].exceptAll([2]), containsAllInOrder(<int>[1, 3]));
    expect([1, 2, 3].exceptAll([1, 5]), containsAllInOrder(<int>[2, 3]));
    expect([1, 2, 3].exceptAll([]), containsAllInOrder(<int>[1, 2, 3]));

    // containsAll tests
    expect([1, 2, 3].containsAll([1, 2]), isTrue);
    expect([1, 2, 3].containsAll([1, 2, 3, 4]), isFalse);

    // containsNone tests
    expect([1, 2, 3].containsNone([1, 2]), isFalse);
    expect([1, 2, 3].containsNone([4, 5]), isTrue);

    // lastIndex tests
    expect([1, 2, 3].lastIndex, equals(2));
    expect(<int>[].lastIndex, equals(0));

    // hasOnlyOneElement tests
    expect([1, 2, 3].hasOnlyOneElement, isFalse);
    expect([1].hasOnlyOneElement, isTrue);

    expect(list.contains(list.random()), isTrue);
    expect(list.randomOrNull(), isNotNull);
    expect([5].randomOrNull(), 5);
    expect(<int>[].randomOrNull(), null);

    // onEach
    expect(
      [
        {'name': 'Birju'}
      ].onEach((element) => element['name'] = 'John'),
      equals([
        {'name': 'John'}
      ]),
    );

    // flattened
    expect(
        [
          [1, 2],
          [3, 4],
          [5, 6],
          null,
        ].flattenedNotNull,
        equals([1, 2, 3, 4, 5, 6]));
    expect(<List<String>>[].flattenedNotNull, isEmpty);
    final List<Set<String>>? nullList = null;
    expect(nullList.flattenedNotNull, isEmpty);
  });

  test('math tests', () {
    final list1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    final list2 = <(int, double)>[
      (1, 2.5),
      (2, 3.5),
      (3, 1.5),
      (4, 2.0),
      (3, 3.5),
      (1, 1.5),
    ];
    (1, 2.0) == (2, 1.0);
    expect(<int>[].maxByOrNull((element) => element), null);
    expect(list1.maxByOrNull((element) => element), 10);
    expect(list1.maxBy((element) => element), 10);
    expect(list2.maxBy((element) => element.$1), (4, 2.0));
    expect(list2.maxBy((element) => element.$2), (2, 3.5));
    expect(list2.maxByLast((element) => element.$2), (3, 3.5));
    expect(<(int, int)>[].maxByLastOrNull((element) => element.$2), null);
    expect(list2.maxByLastOrNull((element) => element.$2), (3, 3.5));
    expect(<int>[].minByOrNull((element) => element), null);
    expect(list1.minByOrNull((element) => element), 1);
    expect(list1.minBy((element) => element), 1);
    expect(list2.minBy((element) => element.$1), (1, 2.5));
    expect(<(int, int)>[].minByLastOrNull((element) => element.$1), null);
    expect(list2.minByLastOrNull((element) => element.$1), (1, 1.5));
    expect(list2.minByLast((element) => element.$1), (1, 1.5));
    expect(list2.minBy((element) => element.$2), (3, 1.5));
    expect(list2.sumBy((element) => element.$1), 14);
    expect(list2.sumBy((element) => element.$2), 14.5);
    expect(list2.averageBy((element) => element.$1), 14 / list2.length);
    expect(list2.averageBy((element) => element.$2), 14.5 / list2.length);
  });

  test('records test', () {
    final List<String> list = ['a', 'b', 'c'];
    expect(list.records, equals([(0, 'a'), (1, 'b'), (2, 'c')]));

    for (final (index, item) in list.records) {
      expect(list[index], equals(item));
    }
  });

  test('toBase64 tests', () {
    expect([1, 2, 3].toBase64(), 'AQID');
    expect(<int>[].toBase64(), '');
  });

  test('toUint8List tests', () {
    final List<int> list = [1, 2, 3];
    expect(list.toUint8List(), equals(Uint8List.fromList(list)));
    expect(<int>[].toUint8List(), equals(Uint8List(0)));
  });

  test('toUint16List tests', () {
    final List<int> list = [1, 2, 3];
    expect(list.toUint16List(), equals(Uint16List.fromList(list)));
    expect(<int>[].toUint16List(), equals(Uint16List(0)));
  });

  group('findBy tests', () {
    test('findBy should return the correct element when found', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.findBy(3, (item) => item);
      expect(result, equals(3));
    });

    test('findBy should throw StateError when no element is found', () {
      final list = [1, 2, 3, 4, 5];
      expect(() => list.findBy(6, (item) => item), throwsStateError);
    });

    test('findBy should work with custom object and selector', () {
      final list = [
        Person(name: 'Alice', age: 25),
        Person(name: 'Bob', age: 30),
        Person(name: 'Charlie', age: 35),
      ];
      final result = list.findBy('Bob', (person) => person.name);
      expect(result, equals(Person(name: 'Bob', age: 30)));
    });
  });

  group('findByOrNull', () {
    test('should return the correct element when found', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.findByOrNull(3, (item) => item);
      expect(result, equals(3));
    });

    test('should return null when no element is found', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.findByOrNull(6, (item) => item);
      expect(result, isNull);
    });

    test('should work with custom object and selector', () {
      final list = [
        Person(name: 'Alice', age: 25),
        Person(name: 'Bob', age: 30),
        Person(name: 'Charlie', age: 35),
      ];
      final result = list.findByOrNull('Bob', (person) => person.name);
      expect(result, equals(Person(name: 'Bob', age: 30)));
    });
  });

  group('findAllBy', () {
    test('should return a collection with matching elements when found', () {
      final list = [1, 2, 3, 2, 4, 2, 5];
      final result = list.findAllBy(2, (item) => item);
      expect(result, containsAll([2, 2, 2]));
    });

    test('should return an empty collection when no element is found', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.findAllBy(6, (item) => item);
      expect(result, isEmpty);
    });

    test('should work with custom object and selector', () {
      final list = [
        Person(name: 'Alice', age: 25),
        Person(name: 'Bob', age: 30),
        Person(name: 'Charlie', age: 35),
        Person(name: 'Alice', age: 40),
      ];
      final result = list.findAllBy('Alice', (person) => person.name);
      expect(
          result,
          containsAll([
            Person(name: 'Alice', age: 25),
            Person(name: 'Alice', age: 40),
          ]));
    });
  });
}

class Person {
  final String name;
  final int age;

  Person({required this.name, required this.age});

  @override
  bool operator ==(other) {
    return other is Person && other.name == name && other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}
