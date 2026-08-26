import 'constants.dart';

/// Represents the compilation mode this code was compiled to.
///
/// This is equiv
@pragma("vm:platform-const")
CompileMode get compileMode {
  if (kDebugMode) return CompileMode.debug;
  if (kProfileMode) return CompileMode.profile;
  if (kReleaseMode) return CompileMode.release;
  throw Exception('Unknown compilation mode');
}

/// Represents compilation modes for compiled dart code.
enum CompileMode {
  /// Represents the debug mode compilation of the dart code.
  debug,

  /// Represents the profile mode compilation of the dart code.
  profile,

  /// Represents the release mode compilation of the dart code.
  release;

  const CompileMode();

  /// True if the application was compiled in debug mode.
  bool get isDebug => this == CompileMode.debug;

  /// True if the application was compiled in profile mode.
  bool get isProfile => this == CompileMode.profile;

  /// True if the application was compiled in release mode.
  bool get isRelease => this == CompileMode.release;

  /// True if the application was not compiled in debug mode.
  bool get isNotDebug => this != CompileMode.debug;

  /// True if the application was not compiled in profile mode.
  bool get isNotProfile => this != CompileMode.profile;

  /// True if the application was not compiled in release mode.
  bool get isNotRelease => this != CompileMode.release;
}
