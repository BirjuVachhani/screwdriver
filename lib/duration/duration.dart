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
// Created Date: August 22, 2020

part of '../screwdriver.dart';

/// provides extensions for [Duration].
extension DurationScrewdriver on Duration {
  /// Returns [DateTime] that is before [this] duration.
  DateTime get ago => DateTime.now() - this;

  /// Returns [DateTime] that is before [this] duration.
  DateTime get after => DateTime.now() + this;

  /// Returns true if [this] duration equals to or more than a day.
  bool get isInDays => inDays > 0;

  /// Returns true if [this] duration equals to or more than an hour but
  /// is less than a day.
  bool get isInHours => inHours > 0 && !isInDays;

  /// Returns true if [this] duration equals to or more than a minute but
  /// is less than an hour.
  bool get isInMinutes => inMinutes > 0 && !isInHours;

  /// Returns true if [this] duration equals to or more than a second but
  /// is less than a minute.
  bool get isInSeconds => inSeconds > 0 && !isInMinutes;

  /// Returns true if [this] duration equals to or more than a millisecond but
  /// is less than a second.
  bool get isInMillis => inMilliseconds > 0 && !isInSeconds;

  /// Returns remaining minutes after deriving hours.
  int get absoluteMinutes => inMinutes % Duration.minutesPerHour;

  /// Returns remaining minutes after deriving days.
  int get absoluteHours => inHours % Duration.hoursPerDay;

  /// Returns remaining minutes after deriving minutes.
  int get absoluteSeconds => inSeconds % Duration.secondsPerMinute;
}
