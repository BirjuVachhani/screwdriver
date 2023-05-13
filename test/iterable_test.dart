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
    expect(list.filterTo([1, 3], (element) => element == 5).toList(),
        equals([1, 3, 5]));
    expect(
        <int>[].filterTo([1, 2], (element) => element.isEven), equals([1, 2]));

    // filterIndexed
    expect(list.filterIndexed((index, element) => index.isEven),
        equals([1, 3, 5, 7, 9]));

    // flatMap
    expect([1, 2].flatMap((element) => element * 10), equals([10, 20]));
    expect(<int>[].flatMap((element) => element * 10), equals(<int>[]));

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
    expect(
        [DateTime(2015), DateTime(2020)]
            .associate((element) => (element.year, element.isLeapYear)),
        equals({2015: false, 2020: true}));

    // associateBy
    expect(
        [DateTime(2015), DateTime(2020)].associateBy((element) => element.year),
        equals({2015: DateTime(2015), 2020: DateTime(2020)}));

    // associateWith
    expect(
        [DateTime(2015), DateTime(2020)]
            .associateWith((element) => element.isLeapYear),
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
    expect(
        [1, 1, 2, 2, 2, 3, 4, 4, 5, 5, 5, 6]
            .distinctBy((element) => element % 3),
        [1, 2, 3]);

    // intersect
    expect([1, 2, 3].intersect([2, 3, 4, 5]), equals([2, 3]));

    // subtract
    expect([1, 2, 3].subtract([2, 3, 4, 5]), equals([1]));

    // union
    expect([1, 2].union([2, 4, 5]), equals([1, 2, 4, 5]));

    // count
    expect(list.count((element) => element.isOdd), 5);
    expect(<int>[].count((element) => element.isOdd), 0);

    // foldRight
    expect(
        [1, 2, 3].foldRight<int>(
            0, (previousValue, element) => previousValue * 2 + element),
        17);

    // foldRightIndexed
    expect(
        [1, 2, 3].foldRightIndexed<int>(
            0,
            (index, previousValue, element) =>
                previousValue + index * 2 + element),
        12);

    // except tests
    expect([1, 2, 3].except([2]), containsAllInOrder(<int>[1, 3]));
    expect([1, 2, 3].except([1, 5]), containsAllInOrder(<int>[2, 3]));

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
}
