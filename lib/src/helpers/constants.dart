/// A constant that is true if the application was compiled in release mode.
///
/// More specifically, this is a constant that is true if the application was
/// compiled in Dart with the '-Ddart.vm.product=true' flag.
///
/// Since this is a const value, it can be used to indicate to the compiler that
/// a particular block of code will not be executed in release mode, and hence
/// can be removed.
///
/// Generally it is better to use [kDebugMode] or `assert` to gate code, since
/// using [_kReleaseMode] will introduce differences between release and profile
/// builds, which makes performance testing less representative.
///
/// See also:
///
///  * [kDebugMode], which is true in debug builds.
///  * [kProfileMode], which is true in profile builds.
///
/// Note: This is kept private and is exposed through CompileMode to avoid
/// collisions with the Flutter framework's kReleaseMode constant.
const bool kReleaseMode = bool.fromEnvironment('dart.vm.product');

/// A constant that is true if the application was compiled in profile mode.
///
/// More specifically, this is a constant that is true if the application was
/// compiled in Dart with the '-Ddart.vm.profile=true' flag.
///
/// Since this is a const value, it can be used to indicate to the compiler that
/// a particular block of code will not be executed in profile mode, an hence
/// can be removed.
///
/// See also:
///
///  * [kDebugMode], which is true in debug builds.
///  * [kReleaseMode], which is true in release builds.
///
/// Note: This is kept private and is exposed through CompileMode to avoid
/// collisions with the Flutter framework's kProfileMode constant.
const bool kProfileMode = bool.fromEnvironment('dart.vm.profile');

/// A constant that is true if the application was compiled in debug mode.
///
/// More specifically, this is a constant that is true if the application was
/// not compiled with '-Ddart.vm.product=true' and '-Ddart.vm.profile=true'.
///
/// Since this is a const value, it can be used to indicate to the compiler that
/// a particular block of code will not be executed in debug mode, and hence
/// can be removed.
///
/// An alternative strategy is to use asserts, as in:
///
/// ```dart
/// assert(() {
///   // ...debug-only code here...
///   return true;
/// }());
/// ```
///
/// See also:
///
///  * [kReleaseMode], which is true in release builds.
///  * [kProfileMode], which is true in profile builds.
/// Note: This is kept private and is exposed through CompileMode to avoid
/// collisions with the Flutter framework's kDebugMode constant.
const bool kDebugMode = !kReleaseMode && !kProfileMode;