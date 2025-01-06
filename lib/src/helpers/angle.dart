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
// Created Date: November 14, 2024

import 'dart:math';

/// Represents an angle in degrees.
/// This extension type is zero-cost wrapper for double value representing
/// an angle in degrees making the code more readable and safe.
extension type Degrees(double _value) implements double {
  /// Returns the value of this angle in radians with [Radians]
  /// extension type.
  Radians get inRadians => Radians(_value * (pi / 180));

  /// Returns the value of this angle in turns with [Turns]
  /// extension type.
  Turns get inTurns => Turns(_value / 360);
}

/// Represents an angle in radians.
/// This extension type is zero-cost wrapper for double value representing
/// an angle in radians making the code more readable and safe.
extension type Radians(double _value) implements double {
  /// Returns the value of this angle in degrees with [Degrees]
  /// extension type.
  Degrees get inDegrees => Degrees(_value * (180 / pi));

  /// Returns the value of this angle in turns with [Turns]
  /// extension type.
  Turns get inTurns => Turns(_value / (2 * pi));
}

/// Represents an angle in turns.
/// This extension type is zero-cost wrapper for double value representing
/// an angle in turns making the code more readable and safe.
extension type Turns(double _value) implements double {
  /// Returns the value of this angle in degrees with [Degrees]
  /// extension type.
  Degrees get inDegrees => Degrees(_value * 360);

  /// Returns the value of this angle in radians with [Radians]
  /// extension type.
  Radians get inRadians => Radians(_value * (2 * pi));
}
