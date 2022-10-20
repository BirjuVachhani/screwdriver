## 3.1.1

- Fix `MAX_INT_VALUE` and `MIN_INT_VALUE` not compiling for JS.
- Upgrade dependencies.

## 3.1.0

- Added `StreamSubscriptionMixin` to manage stream subscriptions. Supports scoped subscriptions as well.
- Replace `BidirectionalIteratorScrewdriver` with `RuneIteratorScrewdriver` because of the deprecation of `BidirectionalIterator`.

## 3.0.0

- Added `IntRange` helper class.
- Added `rangeTo`, `until` and `downTo` extensions for `int` to create `IntRange`.
- Added `coerceAtLeast`, `coerceAtMost`, and `coerceIn` extensions for `Comparable`.
- Added `except` extension for `Map`.
- Added `except`, `containsAll`, `containsNone`, `lastIndex`, `elementAtOrNull`, and `hasOnlyOneElement` extensions for `Iterable`.
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
- Added [collection](https://pub.dev/packages/collection) as a part of the package, so it can now be used from screwdriver. No need to explicitly add it.

## 2.0.0

- Migrated to null safety.
- Removed following extensions either because they are redundant in favor of non-nullable types or they are already available in the null safe version of official dart package [collection](https://pub.dev/packages/collection).
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
