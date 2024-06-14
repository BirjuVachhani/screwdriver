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

/// de-bounces [run] method calls and runs it only once in given [milliseconds]
final class DeBouncer {
  /// de-bounce period
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
  }
}
