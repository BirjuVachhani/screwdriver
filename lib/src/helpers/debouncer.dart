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

import 'dart:async';

/// typedef for action function for [DeBouncer]
typedef DeBounceAction = void Function();

/// de-bounces [run] method calls and runs it only once in given [duration].
/// It will ignore any calls to [run] until [duration] has passed since the
/// last call to [run].
/// It can be used to de-bounce any method calls like search, filter, etc.
final class DeBouncer {
  /// de-bounce period. Default is 300 milliseconds.
  /// It will ignore any calls to [run] until [duration] has passed since the
  /// last call to [run].
  final Duration duration;

  /// Allows to run the first call immediately. Default is false.
  /// If set to true, the first call to [run] will be executed immediately
  /// calling the [action] and then it will wait for [duration] to run the next
  /// call if there's any.
  ///
  /// If set to false, any call to [run] will be ignored until [duration] has
  /// passed since the last call to [run] and then it will run the [action].
  final bool immediateFirstRun;

  Timer? _timer;

  /// Returns true if timer is running and a call is scheduled to run in future
  /// else returns false.
  bool get isRunning => _timer?.isActive ?? false;

  /// Allows to create an instance with optional [Duration] with
  /// immediateFirstRun set to false. See [immediateFirstRun] for more details.
  DeBouncer([Duration? duration])
      : duration = duration ?? Duration(milliseconds: 300),
        immediateFirstRun = false;

  /// Allows to create an instance with optional [Duration] with
  /// immediateFirstRun set to true. See [immediateFirstRun] for more details.
  DeBouncer.immediate([Duration? duration])
      : duration = duration ?? Duration(milliseconds: 300),
        immediateFirstRun = true;

  /// Runs [action] after debounced interval.
  /// If [immediateFirstRun] is set to true, it will run the [action]
  /// immediately for the first call and then it will wait for [duration] to
  /// run the next call if there's any.
  ///
  /// This [immediateFirstRun] will override the instance level setting. If
  /// not provided, it will use the instance level setting.
  void run(DeBounceAction action, {bool? immediateFirstRun}) {
    immediateFirstRun ??= this.immediateFirstRun;
    if (immediateFirstRun && !isRunning) {
      _timer?.cancel();
      action();
      // fake timer to prevent immediate call on next run.
      _timer = Timer(duration, () {});
      return;
    }
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// alias for [run]
  void call(DeBounceAction action) => run(action);

  /// Allows to cancel current timer.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}

/// global instance of [DeBouncer] to be used for debouncing actions. It can be
/// used to debounce actions across the application. Use [debounce] function to
/// debounce actions using this instance.
///
/// CAUTION:
/// This instance will be shared across the application. If you want to have
/// different debounce settings for different actions, you should create an
/// instance of [DeBouncer] and use it for debouncing actions.
///
/// Also, it is recommended to use this instance only for simple use cases where
/// you don't need to debounce 2 different actions at the same time! Otherwise,
/// it will cause conflicts between the actions and you may not get the desired
/// results. If you need to debounce multiple actions, you should create an
/// instance of [DeBouncer] for each action.
///
/// See [debounce] function for more details.
final DeBouncer debouncer = DeBouncer();

/// Helper function to debounce [action] calls using global [deBouncer] instance.
/// If [immediateFirstRun] is set to true, it will run the [action] immediately
/// for the first call and then it will wait for [duration] to run the next call
/// if there's any.
///
/// This is helpful when you want to debounce a method call without creating an
/// instance of [DeBouncer] class. However, you can create an instance of
/// [DeBouncer] and use it for debouncing actions as well.
///
/// CAUTION:
/// This function will use the global instance of [DeBouncer] and it will be
/// shared across the application. If you want to have different debounce
/// settings for different actions, you should create an instance of
/// [DeBouncer] and use it for debouncing actions.
///
/// Also, it is recommended to
/// use this function only for simple use cases where you don't need to
/// debounce 2 different actions at the same time! Otherwise, it will cause
/// conflicts between the actions and you may not get the desired results.
/// If you need to debounce multiple actions, you should create an instance
/// of [DeBouncer] for each action.
///
/// To cancel the current timer, you can call [DeBouncer.cancel] method on
/// the global instance of [deBouncer].
///
/// e.g.
/// ```dart
/// // Using global instance of deBouncer to debounce actions.
/// debounce(() {
///  // your action here
///  print('debounced action');
///  });
/// ```
///
/// ```dart
/// debouncer.cancel(); // cancels the current action on global instance.
/// ```
///
/// This will run the action immediately for the first call and then it will
/// wait for 300 milliseconds to run the next call if there's any.
void debounce(DeBounceAction action, {bool immediateFirstRun = false}) =>
    debouncer.run(action, immediateFirstRun: immediateFirstRun);
