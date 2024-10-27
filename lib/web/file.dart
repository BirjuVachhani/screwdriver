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

part of '../screwdriver_web.dart';

/// provides extensions for [File]
extension FileScrewdriver on File {
  /// Reads the [File] and returns the content as bytes.
  Future<Uint8List> readAsBytes() async {
    final Completer<Uint8List> completer = Completer<Uint8List>();
    final FileReader reader = FileReader();
    // final ProgressEvent event =
    //     await EventStreamProviders.loadEvent.forTarget(reader).first;

    void changeEventListener(Event e) async {
      final ByteBuffer byteBuffer = (reader.result as JSArrayBuffer).toDart;
      completer.complete(byteBuffer.asUint8List());
    }

    reader.addEventListener('load', changeEventListener.toJS);
    reader.readAsArrayBuffer(this);

    return completer.future;
  }

  /// Reads the [File] and returns the content as a string.
  Future<String> readAsString() async {
    final Completer<String> completer = Completer<String>();
    final FileReader reader = FileReader();

    void changeEventListener(Event e) async {
      final String text = (reader.result as JSString).toDart;
      completer.complete(text);
    }

    reader.addEventListener('load', changeEventListener.toJS);
    reader.readAsText(this);

    return completer.future;
  }
}
