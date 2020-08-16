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
// Created Date: August 16, 2020

part of '../screwdriver.dart';

/// Provides extensions for [DateTime] class.
extension DateTimeScrewdriver on DateTime {
  /// Returns an instance of [DateTime] without time related values.
  /// This is intended to remove hour, minute, second and millisecond
  /// information from [DateTime] instance which leaves only date information.
  /// Example:
  ///     final date = DateTime().now();   // 26-07-2020 16:54:23
  ///     date.dateOnly                    // 26-07-2020
  /// This is helpful in cases where comparison of only dates is required.
  DateTime get dateOnly => DateTime(year, month, day);

  /// Returns true if the date of [this] occurs before the date of [other].
  ///
  /// The comparison is independent of whether the time is in UTC or
  /// in the local time zone.
  bool isBeforeDate(DateTime other) => dateOnly.isBefore(other.dateOnly);

  /// Returns true if the date of [this] occurs after the date of [other].
  ///
  /// The comparison is independent of whether the time is in UTC or
  /// in the local time zone.
  bool isAfterDate(DateTime other) => dateOnly.isAfter(other.dateOnly);

  /// Returns true if the date of [this] occurs on the same day as
  /// the date of [other].
  ///
  /// The comparison is independent of whether the time is in UTC or
  /// in the local time zone.
  bool isSameDateAs(DateTime other) =>
      dateOnly.isAtSameMomentAs(other.dateOnly);

  /// Returns true if [this] is same as the date of today.
  /// This doesn't account for time.
  bool get isToday {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }

  /// Returns true if [this] occurs a day before today
  /// This doesn't account for time.
  bool get isYesterday {
    final now = DateTime.now();
    return day == now.day - 1 && month == now.month && year == now.year;
  }

  /// Returns true if [this] occurs a day after today
  /// This doesn't account for time.
  bool get isTomorrow {
    final now = DateTime.now();
    return day == now.day + 1 && month == now.month && year == now.year;
  }

  /// Returns true if [this] occurs in past
  /// This doesn't account for time.
  bool get isPast => isBefore(DateTime.now());

  /// Returns true if [this] occurs in future
  /// This doesn't account for time.
  bool get isFuture => isAfter(DateTime.now());

  /// Returns true if [this] occurs in previous month
  bool get isInPreviousMonth {
    final now = DateTime.now();
    return month == now.month - 1 && year == now.year;
  }

  /// Returns true if [this] occurs in previous month
  bool get isInNextMonth {
    final now = DateTime.now();
    return month == now.month + 1 && year == now.year;
  }

  /// Returns true if [this] occurs in previous year
  bool get isInPreviousYear => year == DateTime.now().year - 1;

  /// Returns true if [this] occurs in previous year
  bool get isInNextYear => year == DateTime.now().year + 1;

  /// Returns true if [this] occurs on Monday
  /// In accordance with ISO 8601, a week starts with Monday,
  /// which has the value 1.
  bool get isMonday => weekday == DateTime.monday;

  /// Returns true if [this] occurs on Tuesday
  /// In accordance with ISO 8601, a week starts with Monday,
  /// which has the value 1.
  bool get isTuesday => weekday == DateTime.tuesday;

  /// Returns true if [this] occurs on Wednesday
  /// In accordance with ISO 8601, a week starts with Monday,
  /// which has the value 1.
  bool get isWednesday => weekday == DateTime.wednesday;

  /// Returns true if [this] occurs on Thursday
  /// In accordance with ISO 8601, a week starts with Monday,
  /// which has the value 1.
  bool get isThursday => weekday == DateTime.thursday;

  /// Returns true if [this] occurs on Friday
  /// In accordance with ISO 8601, a week starts with Monday,
  /// which has the value 1.
  bool get isFriday => weekday == DateTime.friday;

  /// Returns true if [this] occurs on Saturday
  /// In accordance with ISO 8601, a week starts with Monday,
  /// which has the value 1.
  bool get isSaturday => weekday == DateTime.saturday;

  /// Returns true if [this] occurs on Sunday
  /// In accordance with ISO 8601, a week starts with Monday,
  /// which has the value 1.
  bool get isSunday => weekday == DateTime.sunday;

  /// Returns true if [this] falls in january
  bool get isInJanuary => month == DateTime.january;

  /// Returns true if [this] falls in february
  bool get isInFebruary => month == DateTime.february;

  /// Returns true if [this] falls in march
  bool get isInMarch => month == DateTime.march;

  /// Returns true if [this] falls in april
  bool get isInApril => month == DateTime.april;

  /// Returns true if [this] falls in may
  bool get isInMay => month == DateTime.may;

  /// Returns true if [this] falls in june
  bool get isInJune => month == DateTime.june;

  /// Returns true if [this] falls in july
  bool get isInJuly => month == DateTime.july;

  /// Returns true if [this] falls in august
  bool get isInAugust => month == DateTime.august;

  /// Returns true if [this] falls in september
  bool get isInSeptember => month == DateTime.september;

  /// Returns true if [this] falls in october
  bool get isInOctober => month == DateTime.october;

  /// Returns true if [this] falls in november
  bool get isInNovember => month == DateTime.november;

  /// Returns true if [this] falls in december
  bool get isInDecember => month == DateTime.december;

  /// Returns true if [this] occurs before [other].
  ///
  /// The comparison is independent of whether the time is in UTC or
  /// in the local time zone.
  bool operator <(DateTime other) => isBefore(other);

  /// Returns true if [this] occurs after [other].
  ///
  /// The comparison is independent of whether the time is in UTC or
  /// in the local time zone.
  bool operator >(DateTime other) => isAfter(other);

  /// Returns true if [this] occurs before or at the same moment as [other].
  ///
  /// The comparison is independent of whether the time is in UTC or
  /// in the local time zone.
  bool operator <=(DateTime other) =>
      isBefore(other) || isAtSameMomentAs(other);

  /// Returns true if [this] occurs after or at the same moment as [other].
  ///
  /// The comparison is independent of whether the time is in UTC or
  /// in the local time zone.
  bool operator >=(DateTime other) => isAfter(other) || isAtSameMomentAs(other);

  /// Returns [DateTime] with previous day
  DateTime get previousDay => subtract(Duration(days: 1));

  /// Returns [DateTime] with next day
  DateTime get nextDay => add(Duration(days: 1));

  /// Returns [DateTime] with previous year
  DateTime get previousYear => DateTime(
      year - 1, month, day, hour, minute, second, millisecond, microsecond);

  /// Returns [DateTime] with next year
  DateTime get nextYear => DateTime(
      year + 1, month, day, hour, minute, second, millisecond, microsecond);
}
