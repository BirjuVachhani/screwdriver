// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('dateOnly test', () {
    assert(DateTime.now().dateOnly.hour == 0);
    assert(DateTime.now().dateOnly.minute == 0);
    assert(DateTime.now().dateOnly.second == 0);
    assert(DateTime.now().dateOnly.millisecond == 0);
  });

  test('isBeforeDate test', () {
    assert(!DateTime.now()
        .subtract(Duration(seconds: 10))
        .isBeforeDate(DateTime.now()));
    assert(DateTime.now()
        .subtract(Duration(hours: 24))
        .isBeforeDate(DateTime.now()));
  });

  test('isAfterDate test', () {
    assert(
        !DateTime.now().add(Duration(seconds: 10)).isAfterDate(DateTime.now()));
    assert(DateTime.now().add(Duration(hours: 24)).isAfterDate(DateTime.now()));
  });

  test('isSameDateAs test', () {
    assert(
        DateTime.now().add(Duration(seconds: 10)).isSameDateAs(DateTime.now()));
    assert(
        !DateTime.now().add(Duration(hours: 24)).isSameDateAs(DateTime.now()));
  });

  test('operator test', () {
    assert(DateTime.now().subtract(Duration(hours: 1)) < DateTime.now());
    assert(DateTime.now().subtract(Duration(hours: 1)) <= DateTime.now());
    assert(DateTime.now() > DateTime.now().subtract(Duration(hours: 1)));
    assert(DateTime.now() >= DateTime.now().subtract(Duration(hours: 1)));
    final dateTime = DateTime.now();
    assert(dateTime >= dateTime);
    assert(dateTime <= dateTime);
  });

  test('isToday test', () {
    assert(DateTime.now().isToday);
    assert(!DateTime.now().add(Duration(hours: 24)).isToday);
    assert(!DateTime.now().subtract(Duration(hours: 24)).isToday);
    assert(!DateTime(2000).isToday);
  });

  test('isYesterday test', () {
    assert(!DateTime.now().isYesterday);
    assert(!DateTime.now().add(Duration(hours: 24)).isYesterday);
    assert(DateTime.now().subtract(Duration(hours: 24)).isYesterday);
    assert(!DateTime(2000).isYesterday);
  });

  test('isTomorrow test', () {
    assert(!DateTime.now().isTomorrow);
    assert(DateTime.now().add(Duration(hours: 24)).isTomorrow);
    assert(!DateTime.now().subtract(Duration(hours: 24)).isTomorrow);
    assert(!DateTime(DateTime.now().year + 100).isTomorrow);
  });

  test('isPast test', () {
    assert(!DateTime.now().add(Duration(hours: 24)).isPast);
    assert(DateTime.now().subtract(Duration(hours: 24)).isPast);
    assert(DateTime(2000).isPast);
    assert(!DateTime(DateTime.now().year + 100).isPast);
  });

  test('isFuture test', () {
    assert(DateTime.now().add(Duration(hours: 24)).isFuture);
    assert(!DateTime.now().subtract(Duration(hours: 24)).isFuture);
    assert(!DateTime(2000).isFuture);
    assert(DateTime(DateTime.now().year + 100).isFuture);
  });

  test('weekday test', () {
    // calender verified date that is Monday
    final monday = DateTime(2020, 8, 17);
    assert(monday.isMonday);
    assert(!monday.add(Duration(hours: 24)).isMonday);
    assert(monday.add(Duration(hours: 24 * 1)).isTuesday);
    assert(monday.add(Duration(hours: 24 * 2)).isWednesday);
    assert(monday.add(Duration(hours: 24 * 3)).isThursday);
    assert(monday.add(Duration(hours: 24 * 4)).isFriday);
    assert(monday.add(Duration(hours: 24 * 5)).isSaturday);
    assert(monday.add(Duration(hours: 24 * 6)).isSunday);
    assert(DateTime.now().nextDay.isTomorrow);
    assert(!DateTime.now().previousDay.isTomorrow);
    assert(DateTime.now().previousDay.isYesterday);
    assert(!DateTime.now().nextDay.isYesterday);
  });

  test('month test', () {
    final january = DateTime(2020, 1, 10);
    assert(january.isInJanuary);
    assert(!january.add(Duration(days: 30)).isInJanuary);
    assert(january.add(Duration(days: 30 * 1)).isInFebruary);
    assert(january.add(Duration(days: 30 * 2)).isInMarch);
    assert(january.add(Duration(days: 30 * 3)).isInApril);
    assert(january.add(Duration(days: 30 * 4)).isInMay);
    assert(january.add(Duration(days: 30 * 5)).isInJune);
    assert(january.add(Duration(days: 30 * 6)).isInJuly);
    assert(january.add(Duration(days: 30 * 7)).isInAugust);
    assert(january.add(Duration(days: 30 * 8)).isInSeptember);
    assert(january.add(Duration(days: 30 * 9)).isInOctober);
    assert(january.add(Duration(days: 30 * 10)).isInNovember);
    assert(january.add(Duration(days: 30 * 11)).isInDecember);
    final now = DateTime.now();
    assert(DateTime(now.year, now.month - 1, now.day).isInPreviousMonth);
    assert(!DateTime(now.year, now.month + 1, now.day).isInPreviousMonth);
    assert(!now.isInPreviousMonth);
    assert(DateTime(now.year, now.month + 1, now.day).isInNextMonth);
    assert(!DateTime(now.year, now.month - 1, now.day).isInNextMonth);
    assert(!now.isInNextMonth);
  });

  test('year test', () {
    final now = DateTime.now();
    assert(DateTime(now.year - 1, now.month, now.day).isInPreviousYear);
    assert(!DateTime(now.year + 1, now.month, now.day).isInPreviousYear);
    assert(!DateTime.now().isInPreviousYear);
    assert(DateTime(now.year + 1, now.month, now.day).isInNextYear);
    assert(!DateTime(now.year - 1, now.month, now.day).isInNextYear);
    assert(!DateTime.now().isInNextYear);
  });

  test('leap year test', () {
    assert(DateTime(1992).isLeapYear);
    assert(DateTime(2020).isLeapYear);
    assert(DateTime(2000).isLeapYear);
    assert(!DateTime(2100).isLeapYear);
  });

  test('+ & - operator tests', () {
    assert((DateTime.now() + 1.days).isTomorrow);
    assert((DateTime.now() - 1.days).isYesterday);
    final someDate = DateTime(2020, 4, 10);
    final otherDate = DateTime(2020, 4, 15);
    final anotherDate = DateTime(2020, 4, 2);
    assert((someDate + 5.days).isSameDateAs(otherDate));
    assert((someDate - 8.days).isSameDateAs(anotherDate));
  });

  test('isBetween extension tests', () {
    assert(DateTime.now()
        .isBetween(DateTime.now() - 2.days, DateTime.now() + 2.days));
    assert(DateTime(2020).isBetween(DateTime(2019), DateTime(2021)));
    assert(DateTime(2020).isBetween(DateTime(2025), DateTime(2015)));
  });
}
