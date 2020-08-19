// Author: Birju Vachhani
// Created Date: August 16, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('dateOnly test', () {
    expect(DateTime.now().dateOnly.hour, 0);
    expect(DateTime.now().dateOnly.minute, 0);
    expect(DateTime.now().dateOnly.second, 0);
    expect(DateTime.now().dateOnly.millisecond, 0);
  });

  test('isBeforeDate test', () {
    expect(
        DateTime.now()
            .subtract(Duration(seconds: 10))
            .isBeforeDate(DateTime.now()),
        false);
    expect(
        DateTime.now()
            .subtract(Duration(hours: 24))
            .isBeforeDate(DateTime.now()),
        true);
  });

  test('isAfterDate test', () {
    expect(
        DateTime.now().add(Duration(seconds: 10)).isAfterDate(DateTime.now()),
        false);
    expect(DateTime.now().add(Duration(hours: 24)).isAfterDate(DateTime.now()),
        true);
  });

  test('isSameDateAs test', () {
    expect(
        DateTime.now().add(Duration(seconds: 10)).isSameDateAs(DateTime.now()),
        true);
    expect(
        !DateTime.now().add(Duration(hours: 24)).isSameDateAs(DateTime.now()),
        true);
  });

  test('operator test', () {
    expect(DateTime.now().subtract(Duration(hours: 1)) < DateTime.now(), true);
    expect(DateTime.now().subtract(Duration(hours: 1)) <= DateTime.now(), true);
    expect(DateTime.now() > DateTime.now().subtract(Duration(hours: 1)), true);
    expect(DateTime.now() >= DateTime.now().subtract(Duration(hours: 1)), true);
    final dateTime = DateTime.now();
    expect(dateTime >= dateTime, true);
    expect(dateTime <= dateTime, true);
  });

  test('isToday test', () {
    expect(DateTime.now().isToday, true);
    expect(DateTime.now().add(Duration(hours: 24)).isToday, false);
    expect(DateTime.now().subtract(Duration(hours: 24)).isToday, false);
    expect(DateTime(2000).isToday, false);
  });

  test('isYesterday test', () {
    expect(DateTime.now().isYesterday, false);
    expect(DateTime.now().add(Duration(hours: 24)).isYesterday, false);
    expect(DateTime.now().subtract(Duration(hours: 24)).isYesterday, true);
    expect(DateTime(2000).isYesterday, false);
  });

  test('isTomorrow test', () {
    expect(DateTime.now().isTomorrow, false);
    expect(DateTime.now().add(Duration(hours: 24)).isTomorrow, true);
    expect(DateTime.now().subtract(Duration(hours: 24)).isTomorrow, false);
    expect(DateTime(DateTime.now().year + 100).isTomorrow, false);
  });

  test('isPast test', () {
    expect(DateTime.now().add(Duration(hours: 24)).isPast, false);
    expect(DateTime.now().subtract(Duration(hours: 24)).isPast, true);
    expect(DateTime(2000).isPast, true);
    expect(DateTime(DateTime.now().year + 100).isPast, false);
  });

  test('isFuture test', () {
    expect(DateTime.now().add(Duration(hours: 24)).isFuture, true);
    expect(DateTime.now().subtract(Duration(hours: 24)).isFuture, false);
    expect(DateTime(2000).isFuture, false);
    expect(DateTime(DateTime.now().year + 100).isFuture, true);
  });

  test('weekday test', () {
    // calender verified date that is Monday
    final monday = DateTime(2020, 8, 17);
    expect(monday.isMonday, true);
    expect(monday.add(Duration(hours: 24)).isMonday, false);
    expect(monday.add(Duration(hours: 24 * 1)).isTuesday, true);
    expect(monday.add(Duration(hours: 24 * 2)).isWednesday, true);
    expect(monday.add(Duration(hours: 24 * 3)).isThursday, true);
    expect(monday.add(Duration(hours: 24 * 4)).isFriday, true);
    expect(monday.add(Duration(hours: 24 * 5)).isSaturday, true);
    expect(monday.add(Duration(hours: 24 * 6)).isSunday, true);
    expect(DateTime.now().nextDay.isTomorrow, true);
    expect(DateTime.now().previousDay.isTomorrow, false);
    expect(DateTime.now().previousDay.isYesterday, true);
    expect(DateTime.now().nextDay.isYesterday, false);
  });

  test('month test', () {
    final january = DateTime(2020, 1, 10);
    expect(january.isInJanuary, true);
    expect(january.add(Duration(days: 30)).isInJanuary, false);
    expect(january.add(Duration(days: 30 * 1)).isInFebruary, true);
    expect(january.add(Duration(days: 30 * 2)).isInMarch, true);
    expect(january.add(Duration(days: 30 * 3)).isInApril, true);
    expect(january.add(Duration(days: 30 * 4)).isInMay, true);
    expect(january.add(Duration(days: 30 * 5)).isInJune, true);
    expect(january.add(Duration(days: 30 * 6)).isInJuly, true);
    expect(january.add(Duration(days: 30 * 7)).isInAugust, true);
    expect(january.add(Duration(days: 30 * 8)).isInSeptember, true);
    expect(january.add(Duration(days: 30 * 9)).isInOctober, true);
    expect(january.add(Duration(days: 30 * 10)).isInNovember, true);
    expect(january.add(Duration(days: 30 * 11)).isInDecember, true);
    final now = DateTime.now();
    expect(DateTime(now.year, now.month - 1, now.day).isInPreviousMonth, true);
    expect(DateTime(now.year, now.month + 1, now.day).isInPreviousMonth, false);
    expect(now.isInPreviousMonth, false);
    expect(DateTime(now.year, now.month + 1, now.day).isInNextMonth, true);
    expect(DateTime(now.year, now.month - 1, now.day).isInNextMonth, false);
    expect(now.isInNextMonth, false);
  });

  test('year test', () {
    final now = DateTime.now();
    expect(DateTime(now.year - 1, now.month, now.day).isInPreviousYear, true);
    expect(DateTime(now.year + 1, now.month, now.day).isInPreviousYear, false);
    expect(DateTime.now().isInPreviousYear, false);
    expect(DateTime(now.year + 1, now.month, now.day).isInNextYear, true);
    expect(DateTime(now.year - 1, now.month, now.day).isInNextYear, false);
    expect(DateTime.now().isInNextYear, false);
    expect(DateTime(2020).nextYear, DateTime(2021));
    expect(DateTime(2020).previousYear, DateTime(2019));
  });

  test('leap year test', () {
    expect(DateTime(1992).isLeapYear, true);
    expect(DateTime(2020).isLeapYear, true);
    expect(DateTime(2000).isLeapYear, true);
    expect(!DateTime(2100).isLeapYear, true);
  });

  test('+ & - operator tests', () {
    expect((DateTime.now() + 1.days).isTomorrow, true);
    expect((DateTime.now() - 1.days).isYesterday, true);
    final someDate = DateTime(2020, 4, 10);
    final otherDate = DateTime(2020, 4, 15);
    final anotherDate = DateTime(2020, 4, 2);
    expect((someDate + 5.days).isSameDateAs(otherDate), true);
    expect((someDate - 8.days).isSameDateAs(anotherDate), true);
  });

  test('isBetween extension tests', () {
    expect(
        DateTime.now()
            .isBetween(DateTime.now() - 2.days, DateTime.now() + 2.days),
        true);
    expect(DateTime(2020).isBetween(DateTime(2019), DateTime(2021)), true);
    expect(DateTime(2020).isBetween(DateTime(2025), DateTime(2015)), true);
  });
}
