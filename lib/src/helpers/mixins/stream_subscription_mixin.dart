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
// Created Date: May 27, 2022

import 'dart:async';

/// A mixin that manages stream subscriptions.
mixin StreamSubscriptionMixin {
  late final Map<String, List<StreamSubscription<dynamic>>> _scopes = {};

  /// Default scope to add subscriptions to. This is used when no scope is
  /// provided.
  static const String defaultScope = 'default';

  /// Listens to the given [stream] and adds the subscription to the
  /// given [scope]. If the scope is not provided, the subscription is added
  /// to the default scope [StreamSubscriptionMixin.defaultScope]. Which means
  /// when [cancelSubscriptions] is called, all the subscriptions in the default
  /// scope are cancelled.
  ///
  /// If you want to micro-manage the subscriptions, you can create a custom
  /// scope and add the subscriptions to it. Specify [scope] parameter to
  /// add the subscription to the given scope. After that, you can call
  /// [cancelScopedSubscriptions] to only cancel subscriptions in the given
  /// scope.
  ///
  /// [onData], [onError], [onDone] and [cancelOnError] are identical to
  /// [Stream.listen] parameters and behave the same.
  StreamSubscription<T> listenTo<T>(
    Stream<T> stream,
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
    String scope = defaultScope,
  }) {
    final subscription = stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
    _scopes.update(scope, (list) => list..add(subscription),
        ifAbsent: () => [subscription]);
    return subscription;
  }

  /// Only cancels the subscriptions in the given [scope].
  void cancelScopedSubscriptions(String scope) {
    _scopes[scope]?.forEach((subscription) => subscription.cancel());
    _scopes.remove(scope);
  }

  /// Cancels all the subscriptions in the all scopes. This is suitable to be
  /// called when disposing the object.
  void cancelSubscriptions() {
    for (final scope in _scopes.entries) {
      for (final subscription in scope.value) {
        subscription.cancel();
      }
    }
    _scopes.clear();
  }
}
