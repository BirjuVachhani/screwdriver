// Author: Birju Vachhani
// Created Date: August 22, 2020

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('duration tests', () {
    expect(1.days.ago.truncateSeconds(), now().previousDay.truncateSeconds());
    expect(1.days.after.truncateSeconds(), now().nextDay.truncateSeconds());

    expect(1.days.isInDays, isTrue);
    expect(0.days.isInDays, isFalse);
    expect(23.hours.isInDays, isFalse);

    expect(12.hours.isInHours, isTrue);
    expect(1.days.isInHours, isFalse);
    expect(0.hours.isInHours, isFalse);

    expect(22.minutes.isInMinutes, isTrue);
    expect(0.minutes.isInMinutes, isFalse);
    expect(2.hours.isInMinutes, isFalse);

    expect(45.seconds.isInSeconds, isTrue);
    expect(0.seconds.isInSeconds, isFalse);
    expect(2.minutes.isInSeconds, isFalse);

    expect(400.milliseconds.isInMillis, isTrue);
    expect(0.milliseconds.isInMillis, isFalse);
    expect(10.seconds.isInMillis, isFalse);

    expect(Duration(hours: 1, minutes: 24).absoluteMinutes, 24);
    expect(Duration(hours: 1, minutes: 24, seconds: 45).absoluteSeconds, 45);
    expect(Duration(days: 2, hours: 13, minutes: 24).absoluteHours, 13);

    expect(400.days.isInYears, isTrue);
    expect(730.days.inYears, 2);
  });
}
