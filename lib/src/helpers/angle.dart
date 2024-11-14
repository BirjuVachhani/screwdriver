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
