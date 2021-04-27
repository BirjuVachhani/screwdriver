## 2.2.0 - Unpublished

- Added `IntRange` helper class.
- Added `rangeTo`, `until` and `downTo` extensions for `int` to create `IntRange`.

## 2.1.1

- Added **String** extensions `count`, `parseJsonArray`, `find`, `title`, `toggledCase`, `equalsIgnoreCase`.
- Added **Duration** extension `fromNow`.
- Used explicit dynamics where required for strong mode.

## 2.1.0

- Added back `isNullOrEmpty`, `isNotNullOrEmpty` extensions for `Iterable?`.
- Added back `isNullOrEmpty`, `isNotNullOrEmpty`, `isNullOrBlank` , `isNotNullOrBlank` extensions for `String?`.
- Added [collection](https://pub.dev/packages/collection) as a part of the package so it can now be used from screwdriver. No need to explicitly add it.

## 2.0.0

- Migrated to null safety.
- Removed following extensions either because they are redundant in favor of non-nullable types or they are already available in the null safe version of [collection](https://pub.dev/packages/collection) package of [dart.dev](dart.dev).
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
