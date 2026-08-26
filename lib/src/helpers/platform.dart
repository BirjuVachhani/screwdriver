import 'package:meta/meta.dart';
import 'package:universal_io/io.dart' as uni;

import 'constants.dart';

/// An enum that represents the different platform types
/// that a system can be running on.
///
/// This mimics the `Platform` class in `dart:io`, but is available in all
/// platforms via an enum that can be used in switch statements and enumerated.
enum Platform {
  /// The platform is Android.
  ///
  /// This is equivalent to `Platform.isAndroid` in `dart:io`.
  android('Android'),

  /// The platform is iOS.
  ///
  /// This is equivalent to `Platform.isIOS` in `dart:io`.
  ios('iOS'),

  /// The platform is macOS.
  ///
  /// This is equivalent to `Platform.isMacOS` in `dart:io`.
  macos('macOS'),

  /// The platform is Linux.
  ///
  /// This is equivalent to `Platform.isLinux` in `dart:io`.
  linux('Linux'),

  /// The platform is Windows.
  ///
  /// This is equivalent to `Platform.isWindows` in `dart:io`.
  windows('Windows'),

  /// The platform is Web.
  ///
  /// This is equivalent to `kIsWeb` in `flutter/foundation.dart`.
  web('Web'),

  /// The platform is Fuchsia.
  ///
  /// This is equivalent to `Platform.isFuchsia` in `dart:io`.
  fuchsia('Fuchsia');

  const Platform(this.label);

  /// A human-readable label for the platform
  final String label;

  /// Returns the platform type of the current system.
  /// This is equivalent to Platform.* getters that dart:io provides,
  /// but it is available in all platforms via an enum that can be
  /// used in switch statements and enumerated.
  ///
  /// This can be tree-shaken just like Platform.* getters.
  ///
  /// Throws an [UnsupportedError] if the platform is not supported.
  /// This should not happen in practice, but it is a safeguard against future
  /// platforms that may be added to dart:io.
  @pragma("vm:platform-const")
  @useResult
  static final Platform current = (() {
    if (kIsWeb) return Platform.web;
    if (uni.Platform.isAndroid) return Platform.android;
    if (uni.Platform.isIOS) return Platform.ios;
    if (uni.Platform.isMacOS) return Platform.macos;
    if (uni.Platform.isLinux) return Platform.linux;
    if (uni.Platform.isWindows) return Platform.windows;
    if (uni.Platform.isFuchsia) return Platform.fuchsia;
    throw UnsupportedError('Unsupported platform: ${uni.Platform.operatingSystem}');
  })();

  // ----------------------------- IO Platform START -----------------------------

  /// The number of individual execution units of the machine.
  static final numberOfProcessors = uni.Platform.numberOfProcessors;

  /// The path separator used by the operating system to separate
  /// components in file paths.
  @pragma("vm:platform-const")
  static final pathSeparator = uni.Platform.pathSeparator;

  /// A string representing the operating system or platform.
  ///
  /// Possible values include:
  /// * "android"
  /// * "fuchsia"
  /// * "ios"
  /// * "linux"
  /// * "macos"
  /// * "windows"
  ///
  /// Note that this list may change over time so platform-specific logic
  /// should be guarded by the appropriate Boolean getter e.g. [isMacOS].
  @pragma("vm:platform-const")
  @pragma("vm:shared")
  static final operatingSystem = uni.Platform.operatingSystem;

  /// A string representing the version of the operating system or platform.
  ///
  /// The format of this string will vary by operating system, platform and
  /// version and is not suitable for parsing. For example:
  ///   "Linux 5.11.0-1018-gcp #20~20.04.2-Ubuntu SMP Fri Sep 3 01:01:37 UTC 2021"
  ///   "Version 14.5 (Build 18E182)"
  ///   '"Windows 10 Pro" 10.0 (Build 19043)'
  @pragma("vm:shared")
  static final operatingSystemVersion = uni.Platform.operatingSystemVersion;

  /// The local hostname for the system.
  ///
  /// For example:
  ///   "mycomputer.corp.example.com"
  ///   "mycomputer"
  ///
  /// Uses the platform
  /// [`gethostname`](https://pubs.opengroup.org/onlinepubs/9699919799/functions/gethostname.html)
  /// implementation.
  @pragma("vm:shared")
  static final localHostname = uni.Platform.localHostname;

  /// The version of the current Dart runtime.
  ///
  /// The value is a [semantic versioning](http://semver.org)
  /// string representing the version of the current Dart runtime,
  /// possibly followed by whitespace and other version and
  /// build details.
  @pragma("vm:shared")
  static final version = uni.Platform.version;

  /// Get the name of the current locale.
  ///
  /// The result usually consists of
  ///  - a language (e.g., "en"), or
  ///  - a language and country code (e.g. "en_US", "de_AT"), or
  ///  - a language, country code and character set (e.g. "en_US.UTF-8").
  ///
  /// On macOS and iOS, the locale is taken from CFLocaleGetIdentifier.
  ///
  /// On Linux and Fuchsia, the locale is taken from the "LANG" environment
  /// variable, which may be set to any value. For example:
  /// ```shell
  /// LANG=kitten dart myfile.dart  # localeName is "kitten"
  /// ```
  ///
  /// On Android, the value will not change while the application is running,
  /// even if the user adjusts their language settings.
  ///
  /// See https://en.wikipedia.org/wiki/Locale_(computer_software)
  static String get localeName => uni.Platform.localeName;

  /// Whether the operating system is a version of
  /// [Linux](https://en.wikipedia.org/wiki/Linux).
  ///
  /// This value is `false` if the operating system is a specialized
  /// version of Linux that identifies itself by a different name,
  /// for example Android (see [isAndroid]).
  @pragma("vm:platform-const")
  @pragma("vm:shared")
  static final bool isLinux = current == Platform.linux;

  /// Whether the operating system is a version of
  /// [macOS](https://en.wikipedia.org/wiki/MacOS).
  @pragma("vm:platform-const")
  @pragma("vm:shared")
  static final bool isMacOS = current == Platform.macos;

  /// Whether the operating system is a version of
  /// [Microsoft Windows](https://en.wikipedia.org/wiki/Microsoft_Windows).
  @pragma("vm:platform-const")
  @pragma("vm:shared")
  static bool isWindows = current == Platform.windows;

  /// Whether the operating system is a version of
  /// [Android](https://en.wikipedia.org/wiki/Android_%28operating_system%29).
  @pragma("vm:platform-const")
  @pragma("vm:shared")
  static final bool isAndroid = current == Platform.android;

  /// Whether the operating system is a version of
  /// [iOS](https://en.wikipedia.org/wiki/IOS).
  @pragma("vm:platform-const")
  @pragma("vm:shared")
  static final bool isIOS = current == Platform.ios;

  /// Whether the operating system is a version of
  /// [Fuchsia](https://en.wikipedia.org/wiki/Google_Fuchsia).
  @pragma("vm:platform-const")
  @pragma("vm:shared")
  static final bool isFuchsia = current == Platform.fuchsia;

  /// The environment for this process as a map from string key to string value.
  ///
  /// The map is unmodifiable,
  /// and its content is retrieved from the operating system on its first use.
  ///
  /// Environment variables on Windows are case-insensitive,
  /// so on Windows the map is case-insensitive and will convert
  /// all keys to upper case.
  /// On other platforms, keys can be distinguished by case.
  static Map<String, String> get environment => uni.Platform.environment;

  /// The path of the executable used to run the script in this isolate.
  /// Usually `dart` when running on the Dart VM or the
  /// compiled script name (`script_name.exe`).
  ///
  /// The literal path used to identify the executable.
  /// This path might be relative or just be a name from which the executable
  /// was found by searching the system path.
  ///
  /// Use [resolvedExecutable] to get an absolute path to the executable.
  static String get executable => uni.Platform.executable;

  /// The path of the executable used to run the script in this
  /// isolate after it has been resolved by the OS.
  ///
  /// This is the absolute path, with all symlinks resolved, to the
  /// executable used to run the script.
  ///
  /// See [executable] for the unresolved version.
  static String get resolvedExecutable => uni.Platform.resolvedExecutable;

  /// The absolute URI of the script being run in this isolate.
  ///
  /// If the script argument on the command line is relative,
  /// it is resolved to an absolute URI before fetching the script, and
  /// that absolute URI is returned.
  ///
  /// URI resolution only does string manipulation on the script path, and this
  /// may be different from the file system's path resolution behavior. For
  /// example, a symbolic link immediately followed by '..' will not be
  /// looked up.
  ///
  /// If a compiled Dart script is being executed the URI to the compiled
  /// script is returned, for example, `file:///full/path/to/script_name.exe`.
  ///
  /// If running on the Dart VM the URI to the running Dart script is returned,
  /// for example, `file:///full/path/to/script_name.dart`.
  ///
  /// If the executable environment does not support [script],
  /// the URI is empty.
  static Uri get script => uni.Platform.script;

  /// The flags passed to the executable used to run the script in this isolate.
  ///
  /// These are the command-line flags to the executable that precedes
  /// the script name.
  /// Provides a new list every time the value is read.
  static List<String> get executableArguments => uni.Platform.executableArguments;

  /// The `--packages` flag passed to the executable used to run the script
  /// in this isolate.
  ///
  /// If present, it specifies a file describing how Dart packages are looked up.
  ///
  /// Is `null` if there is no `--packages` flag.
  static String? get packageConfig => uni.Platform.packageConfig;

  /// The current operating system's default line terminator.
  ///
  /// The default character sequence that the operating system
  /// uses to separate or terminate text lines.
  ///
  /// The line terminator is currently the single line-feed character,
  /// U+000A or `"\n"`, on all supported operating systems except Windows,
  /// which uses the carriage-return + line-feed sequence, U+000D U+000A or
  /// `"\r\n"`
  @pragma("vm:platform-const")
  static String get lineTerminator => isWindows ? '\r\n' : '\n';

  // ----------------------------- IO Platform END -----------------------------

  /// Returns true if the platform is a web platform.
  @pragma("vm:platform-const")
  @pragma("vm:shared")
  @useResult
  static final bool isWeb = kIsWeb;

  /// Returns true if the platform is a WebAssembly platform.
  @pragma("vm:platform-const")
  @pragma("vm:shared")
  @useResult
  static final bool isWasm = kIsWasm;

  /// Returns true if the platform is a mobile platform (Android or iOS).
  @pragma("vm:platform-const")
  @pragma("vm:shared")
  @useResult
  static final bool isMobile = isAndroid || isIOS;

  /// Returns true if the platform is a desktop platform (macOS, Linux, or Windows).
  @pragma("vm:platform-const")
  @pragma("vm:shared")
  @useResult
  static final bool isDesktop = isMacOS || isLinux || isWindows;
}
