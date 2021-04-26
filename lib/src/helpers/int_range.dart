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
// Created Date: April 26, 2021

import 'package:meta/meta.dart';

import '../../screwdriver.dart';
import 'constants.dart';

/// A progression of values of type [int].
/// An iterable that can iterate between [start] and [end] value with step size
/// of [step].
///
/// [start]
@immutable
class IntRange extends Iterable<int> {
  /// The lower bound of for the range.
  /// It will always be the first element.
  final int start;

  /// The upper bound of for the range. This might be or might not
  /// be the last element which is totally based on the [start] and [step].
  /// Example:
  /// 1. IntRangeIterator(1, 10, step: 2)
  ///    It is a range of odd numbers which won't include 10 as the last
  ///    element despite 10 being the upper bound.
  ///
  /// 2. IntRangeIterator(2, 10, step: 2)
  ///    It is a range of even numbers which will include 10 as the last
  ///    element.
  final int end;

  /// The number by which the value is incremented on each step.
  final int step;

  /// Default constructor to create an int range.
  IntRange(this.start, this.end, {this.step = 1}) {
    require(step != 0, 'Step must be non-zero.');
    require(start != end, 'start and end value must not be equal.');
    require(
        step != MIN_INT_VALUE,
        'Step must be greater than MIN_INT_VALUE to avoid overflow '
        'on negation.');
    if (step > 0) {
      require(
          start < end,
          'The end value must be greater than the start value when the step '
          'is greater than 0.');
    } else {
      require(
          start > end,
          'The end value must be less than the start value when the step '
          'is less than 0.');
    }
  }

  @override
  Iterator<int> get iterator => IntRangeIterator(start, end, step: step);

  @override
  bool get isEmpty => step > 0 ? first > last : first < last;

  @override
  int get hashCode => 31 * (31 * first + last) + step;

  @override
  bool operator ==(Object other) {
    return other is IntRange &&
        first == other.first &&
        last == other.last &&
        step == other.step;
  }

  @override
  String toString() => step > 0
      ? '$start rangeTo $end step $step'
      : '$start downTo $end step $step';
}

/// An iterator over a progression of values of type [int].
/// Iterable that gives items between [start] and [end] with step size [step].
/// It iterates through given range with step size [step].
/// Default value of [step] is 1.
/// This implementation is end inclusive, meaning that the [end] value is also
/// a part of the range.
/// For Example,
///       IntRangeIterator(1, 5) would give elements 1,2,3,4,5
///       IntRangeIterator(1, 10, step: 2) would give elements 1,3.5.7.9
class IntRangeIterator extends Iterator<int> {
  /// The lower bound of for the range.
  /// It will always be the first element.
  final int start;

  /// The upper bound of for the range. This might be or might not
  /// be the last element which is totally based on the [start] and [step].
  /// Example:
  /// 1. IntRangeIterator(1, 10, step: 2)
  ///    It is a range of odd numbers which won't include 10 as the last
  ///    element despite 10 being the upper bound.
  ///
  /// 2. IntRangeIterator(2, 10, step: 2)
  ///    It is a range of even numbers which will include 10 as the last
  ///    element.
  final int end;

  /// The number by which the value is incremented on each step.
  final int step;

  int? _current;

  /// Default constructor for this iterator
  IntRangeIterator(this.start, this.end, {this.step = 1});

  @override
  int get current => _current!;

  @override
  bool moveNext() {
    var currentElement = _current;
    if (currentElement == null) {
      _current = start;
      return true;
    }
    if (step > 0) {
      if (currentElement >= end) {
        return false;
      }
      var _next = currentElement + step;
      if (_next > end) {
        return false;
      } else {
        _current = _next;
      }
      return true;
    } else {
      if (currentElement <= end) {
        return false;
      }
      var _next = currentElement + step;
      if (_next < end) {
        return false;
      } else {
        _current = _next;
      }
      return true;
    }
  }
}
