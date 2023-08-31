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
