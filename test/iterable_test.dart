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
  test('getter tests', () {
    final list = [1, 2, 3];
    expect(list.firstOrNull, 1);
    expect(list.secondOrNull, 2);
    expect(list.thirdOrNull, 3);
    expect(list.lastOrNull, 3);
    expect([].firstOrNull, null);
    expect([].secondOrNull, null);
    expect([].thirdOrNull, null);
    expect([].lastOrNull, null);

    expect(list.firstOrNullWhere((e) => e == 1), 1);
    expect(list.firstOrNullWhere((e) => e == 5), null);
    expect([].firstOrNullWhere((e) => e == 1), null);

    expect(list.lastOrNullWhere((e) => e == 3), 3);
    expect(list.lastOrNullWhere((e) => e == 5), null);
    expect([].lastOrNullWhere((e) => e == 3), null);

    expect(list.singleOrNullWhere((e) => e == 2), 2);
    expect([].singleOrNullWhere((e) => e == 1), null);
    expect(() => [1, 2, 2, 3].singleOrNullWhere((e) => e == 2),
        throwsA(TypeMatcher<StateError>()));
  });

  test('actions tests', () {
    final list = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    // filter
    expect(list.filter((element) => element.isEven), equals([2, 4, 6, 8]));
    expect([].filter((element) => element.isEven), equals([]));

    // filterTo
    expect(list.filterTo([1, 3], (element) => element == 5).toList(),
        equals([1, 3, 5]));
    expect([].filterTo([1, 2], (element) => element.isEven), equals([1, 2]));

    // filterIndexed
    expect(list.filterIndexed((index, element) => index.isEven),
        equals([1, 3, 5, 7, 9]));

    // flatMap
    expect([1, 2].flatMap((element) => element * 10), equals([10, 20]));
    expect([].flatMap((element) => element * 10), equals([]));

    // drop
    expect(list.drop(7), equals([8, 9]));
    expect(list.drop(10), equals([]));

    // takeLast
    expect(list.takeLast(3), equals([7, 8, 9]));
    expect([].takeLast(3), equals([]));
    expect([1, 2].takeLast(3), equals([1, 2]));

    // dropWhile
    expect(list.dropWhile((element) => element != 7), equals([7, 8, 9]));
    expect([].dropWhile((element) => element != 7), equals([]));

    // dropLast
    expect(list.dropLast(7), equals([1, 2]));
    expect([].takeLast(3), equals([]));
    expect([1, 2].dropLast(3), equals([]));

    // all
    expect(list.all((element) => element < 10), true);
    expect(list.all((element) => element < 8), false);
    expect([].all((element) => element < 10), true);

    // none
    expect(list.none((element) => element > 10), true);
    expect(list.none((element) => element < 2), false);
    expect([].none((element) => element < 2), true);

    // whereIndexed
    expect(list.whereIndexed((index, element) => index.isEven),
        equals([1, 3, 5, 7, 9]));
    expect([].whereIndexed((index, element) => index.isEven), equals([]));

    // mapIndexed
    expect([1, 2, 3].mapIndexed((index, element) => element * index),
        equals([0, 2, 6]));
    expect([].mapIndexed((index, element) => element * index), equals([]));

    // forEachIndexed
    expect(
      [
        {'name': 'Birju'}
      ]..forEachIndexed((index, element) => element['name'] = 'John'),
      equals([
        {'name': 'John'}
      ]),
    );

    // associate
    expect(
        [DateTime(2015), DateTime(2020)]
            .associate((element) => Pair(element.year, element.isLeapYear)),
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
    expect([].count((element) => element.isOdd), 0);

    // foldIndexed
    expect(
        [1, 2, 3].foldIndexed(0,
            (index, previousValue, element) => previousValue + element * index),
        8);

    // foldRight
    expect(
        [
          1,
          2,
          3
        ].foldRight(0, (previousValue, element) => previousValue * 2 + element),
        17);

    // foldRightIndexed
    expect(
        [1, 2, 3].foldRightIndexed(
            0,
            (index, previousValue, element) =>
                previousValue + index * 2 + element),
        12);

    expect(list.indexOf(list.random()) != -1, isTrue);

    // onEach
    expect(
      [
        {'name': 'Birju'}
      ].onEach((element) => element['name'] = 'John'),
      equals([
        {'name': 'John'}
      ]),
    );

    // reduceIndexed
    expect(
        [1, 2, 3]
            .reduceIndexed((index, value, element) => index * element + value),
        9);
  });
}
