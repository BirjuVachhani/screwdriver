## 5.10.0 (Unreleased)

- New `Consumeable` api with `consume`, `consumeOnce` functions and `asConsumable`.
- New `tryCatch` and `tryCatchOnly` functions.
- New `tryCatch` extension on `Future`.
- [BREAKING] `<<` operator on `Map` now takes a record instead of a `MapEntry`.

## 5.9.0

- Add `isSameOrBeforeDate` and `isSameOrAfterDate` extensions for `DateTime`.
- [BREAKING] `Iterable.except` now takes items as params directly (max 6) instead of a list. Replace it with
  `Iterable.exceptAll` to take a list.
- [BREAKING] Remove deprecated `inDegrees` and `inRadians` extensions for `num` in favor of `degrees.inRadians` and
  `radians.inDegrees`.
- Add `take`, `takeLast` and `lastIndex` extensions for `String`.
- Add `buildString` and `randomString` helper methods.
- Add `space` and `newline` extensions for `StringBuffer`.
- Add `file` and `subdir` extensions for `Directory`.

## 5.8.0

- Add `takeAfter`, `takeAfterLast`, `takeBefore`, `takeBeforeLast`, and `takeBetween` extensions for `String`.
- Bump up minimum **Dart SDK** version to `3.3.0`.
- [DEPRECATED] Deprecate `inDegrees` and `inRadians` extensions for `num` in favor of `degrees.inRadians` and
  `radians.inDegrees`.
- [BREAKING] Rename `count` extension for `Iterable` to `countBy`.
- Add `count` extension for `Iterable` to count occurrences of an element.
- Add `Degrees`, 'Radians', and 'Turns' extension types for angle unit conversion.
- Add `degrees`, `radians`, and `turns` extensions for `num` to convert to angle units.

## 5.7.0

- Support WASM by removing `dart:html` dependency and replacing it with `web` and `dart:js_interop`.
- Add `reverseIf` extension for `List`.
- Add `completer` helper function to use `Completer` api in a more concise way.

## 5.6.0

- Add `byNameOrNull` extension on enum.
- Add `toFixedString` extension on int.
- [BREAKING] Fix `flatMap` extension to behaving correctly.
- Iterable extensions:
    - Add `flatMapNotNull` extension.
    - Add `mapNotNull` extension.
    - Add `mapNotNullIndexed` extension.
    - Add 'flattenedNotNull' extension.
- Add `<<` operator extension for List.
- `randomInt` function improvements:
    - add `seed` option.
    - Change default max value to max int value allowed by Random.
- Add `reversed`, `findByValue` and `findByValueOrNull` map extensions.
- Add `plus`, `minus`, `multiply`, `divide` and `mod` extensions for num.

## 5.5.0

- Add `hasExactMatch` extension for `Pattern` and `RegExp`.
- Add `matchesExactly` extension for `String`.
- Add `isBlank`, `isNotBlank`, and `toMap` extensions for `Iterable`.
- Add `prefix` and `suffix` extensions for `String`.
- Add `toBase64`, 'toUint8List', and `toUint16List` extensions for `Iterable<int>`.
- Add `toBytes`, `toUtf16Bytes`, and `toUnicodeBytes` extension for `String`.

## 5.4.0

- Add `isTruthy` and `isFalsy` extensions for generic nullable types.
- Add `immediateFirstRun` option for `DeBouncer` to run the first call immediately.
- Global `debouncer` instance and `debounce` function for easy access to the debouncer.
- DeBouncer now allows returning a value from the debounced function in form of a `Future<R>` where `R` is the return
  type.
- Fix `capitalized` extension not working properly for strings with emojis.

## 5.3.1

- Add `Map.where`, `Map.whereNot`, `Map.removeKeys`, and `Map.only` extensions.
- Add `double.roundToPrecision` extension.
- Allow `Iterable` for `Map.except` extension.
- Fix lint warnings.

## 5.3.0

- [BREAKING] Remove deprecated global `run` function.
- Add `num.inRadians` and `num.inDegrees` extensions for angle unit conversion.
- Add `num.clampAtLeast` and `num.clampAtMost` extensions for clamping a number to a minimum or maximum value
  respectively.

## 5.2.1

- Change return type of `tryJsonDecode` to dynamic.
- Add pub topics to package metadata.
- Upgrade dependencies.

## 5.2.0

- Fix `runCaching` function not caching exceptions properly.
- Improve `runCaching` function to have a `FutureOr<T?>` return type allowing either synchronous or asynchronous
  execution.
- Improve `runCaching` function to cache exceptions even on `onError` callback.
- Avail list of all the extensions and functions in the package in `EXTENSIONS.md` file.
- [BREAKING] Tighten the generic upperbound to `Object` for `apply`, `run`, `takeIf`, `takeUnless` and `tryCast`
  extensions for improved type safety. Use null-safe(?.) operator to fix.
- [DEPRECATED] Deprecate global `run` function.

## 5.0.1

- Add `T.tryCast()` extension on generics to cast an object to a type if possible.
- Add `records` extension for `Iterable`.
- Add `tryJsonDecode` function to safely decode JSON.
- Add `closeTo` extension on `double`.
- Add `max` and `min` extensions on `num`.
- Add replaceFirstWhere and replaceLastWhere extensions on `List`.
- Add `findBy`, `findByOrNull` and `findAllBy` extensions on `Iterable`.

## 5.0.0

- Add `splitMapJoinRegex` and `splitMap` extensions for `String`.
- Add `records` extension for `Map`.
- [BREAKING] Remove deprecated `Pair` class.
- [BREAKING] Remove deprecated `Triple` class.
- [BREAKING] Remove deprecated `to()` and `pairWith()` extensions on generic.
- [BREAKING] Remove deprecated `previous()` extension on `RuneIterator` in favor of `movePrevious`.

## 4.1.0

- Add `hasContent` and `orEmpty` extensions for `String?`.
- Add missing docs.
- Fix example not showing up in pub.dev.
- Remove unnecessary backslashes from email regex.
- Add `Debouncer.isRunning` getter to check if the debouncer is running.
- [DEPRECATED] Deprecate `Pair` class in favor of Records in Dart 3. Use `Record` instead of `Pair` in all the
  APIs. `Pair` will be removed in the next major release.
- [DEPRECATED] Deprecate `Triple` class in favor of Records in Dart 3. Use `Record` instead of `Triple` in all the
  APIs. `Triple` will be removed in the next major release.
- [DEPRECATED] Deprecate `pairWith` and `to` extensions on generic in favor of Records in Dart 3.
- [BREAKING] Refactor `associate` and `associateTo` extensions on `Iterable` to use Records instead of `Pair`.
- [BREAKING] Refactor `+` operator on `Map` to use Records instead of `Pair`.

## 4.0.0

- Bump up minimum **Dart** version to `3.0.0`.
- Upgrade dependencies.
- Add `DateTime.only` extension to duplicate `DateTime` with only specific fields.

## 3.1.1

- Fix `MAX_INT_VALUE` and `MIN_INT_VALUE` not compiling for JS.
- [BREAKING]: Remove `elementAtOrNull` since it is added in the `collections` package.
- Upgrade dependencies.

## 3.1.0

- Added `StreamSubscriptionMixin` to manage stream subscriptions. Supports scoped subscriptions as well.
- Replace `BidirectionalIteratorScrewdriver` with `RuneIteratorScrewdriver` because of the deprecation
  of `BidirectionalIterator`.

## 3.0.0

- Added `IntRange` helper class.
- Added `rangeTo`, `until` and `downTo` extensions for `int` to create `IntRange`.
- Added `coerceAtLeast`, `coerceAtMost`, and `coerceIn` extensions for `Comparable`.
- Added `except` extension for `Map`.
- Added `except`, `containsAll`, `containsNone`, `lastIndex`, `elementAtOrNull`, and `hasOnlyOneElement` extensions
  for `Iterable`.
- Added `readBytes` extension for `html.File`.
- Added `roundToPrecision` extension for `double` and `num`.
- Added `JsonMap`, `IntList`, `StringList`, `DoubleList`, `IntSet`, `StringSet` and `DoubleSet` typedefs.
- Added `SerializableMixin` mixin.
- Added `isNull` and `isNotNull` extensions for `Object?`.
- Added `orZero`, `orOne`, and `or` extensions for `num?`.
- Update hashcode implementation for `IntRange`, `Pair`, and `Triple`.

## 2.1.1

- Added **String** extensions `count`, `parseJsonArray`, `find`, `title`, `toggledCase`, `equalsIgnoreCase`.
- Added **Duration** extension `fromNow`.
- Used explicit dynamics where required for strong mode.

## 2.1.0

- Added back `isNullOrEmpty`, `isNotNullOrEmpty` extensions for `Iterable?`.
- Added back `isNullOrEmpty`, `isNotNullOrEmpty`, `isNullOrBlank` , `isNotNullOrBlank` extensions for `String?`.
- Added [collection](https://pub.dev/packages/collection) as a part of the package, so it can now be used from
  screwdriver. No need to explicitly add it.

## 2.0.0

- Migrated to null safety.
- Removed following extensions either because they are redundant in favor of non-nullable types or they are already
  available in the null safe version of official dart package [collection](https://pub.dev/packages/collection).
    - `Iterable.firstOrNull`
    - `Iterable.firstOrNullWhere`
    - `Iterable.lastOrNullWhere`
    - `Iterable.singleOrNullWhere`
    - `Iterable.isNullOrEmpty`
    - `Iterable.isNotNullOrEmpty`
    - `Iterable.none`
    - `Iterable.whereIndexed`
    - `Iterable.mapIndexed`
    - `Iterable.forEachIndexed`
    - `Iterable.foldIndexed`
    - `Iterable.foldIndexed`
    - `Iterable.sum`
    - `Iterable.average`
    - `Iterable.max`
    - `Iterable.min`
    - `String.isNullOrEmpty`
    - `String.isNotNullOrEmpty`
    - `String.isNullOrBlank`
    - `String.isNotNullOrBlank`
- Added some more extensions in favor of null safety:
    - `Iterable.randomOrNull`
    - `Iterable.maxByOrNull`
    - `Iterable.maxByLastOrNull`
    - `Iterable.minByOrNull`
    - `Iterable.minByLastOrNull`

## 1.2.2

- Fixed email extension & tests.
- upgraded test package dependency.

## 1.2.1

- Upgraded dependencies with specific version bounds.

## 1.2.0

- Add `isNullOrEmpty` and `isNotNullOrEmpty` extensions for collections.
- Add `isNullOrEmpty` and `isNotNullOrEmpty` extensions for string.
- Add `isNullOrBlank` and `isNotNullOrBlank` extensions for string.

## 1.1.1

- Add extensions `isInYears` and `inYears` for `Duration`.
- Add extension `fromNow()` for `DateTime`.
- Fix Issue: `DeBouncer` throwing null pointer exception when calling `cancel()`.

## 1.1.0

- Added extension format date using `DateFormat` from **intl** package.
- Added debouncer helper class that allows to debounce calls to a method for certain amount of time.
- Added extension `to` for generic to create pairs like it is done in Kotlin.

## 1.0.1

- Fix pub.dev warnings.

## 1.0.0

- Initial release. checkout documentation [here](https://pub.dev/documentation/screwdriver/1.0.0/).
