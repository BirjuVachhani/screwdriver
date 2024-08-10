![banner](https://github.com/BirjuVachhani/screwdriver/blob/main/.github/banner.png?raw=true)



# Screwdriver

A dart package aiming to provide useful extensions and helper functions to ease and speed up development.

[![Tests](https://github.com/BirjuVachhani/screwdriver/workflows/Tests%20%26%20Coverage/badge.svg?branch=main)](https://github.com/BirjuVachhani/screwdriver/actions) [![Code Quality](https://github.com/BirjuVachhani/screwdriver/workflows/Code%20Quality/badge.svg?branch=main)](https://github.com/BirjuVachhani/screwdriver/actions) [![Codecov](https://img.shields.io/codecov/c/github/birjuvachhani/screwdriver.svg)](https://codecov.io/gh/birjuvachhani/screwdriver) ![Pub Version](https://img.shields.io/pub/v/screwdriver) [![Docs](https://img.shields.io/badge/Docs-dart%20docs-brightgreen)](https://pub.dev/documentation/screwdriver/latest/)


- 📋  Well Documented
- ⚔️ Fully Tested
- 👌 Follows Code Quality Guidelines
- 🦾 Production Ready
- [collection](https://pub.dev/packages/collection) included for extra extensions.

## Stats
Check out [EXTENSIONS.md](EXTENSIONS.md) for a complete list of all the available extensions.
<!---stats_start-->
```yaml  
Extensions:                    248
Helper Classes:                5
Helper Functions & Getters:    21
Typedefs:                      8
Mixins:                        2
```

> *Last Updated: Sat, Aug 10, 2024 - 06:05 AM*

<!---stats_end-->

*Stats auto generated using [Github Workflow](https://github.com/BirjuVachhani/screwdriver/blob/main/.github/workflows/stats.yaml).*


<br/>

To checkout all the available extensions, helper functions & classes, see [documentation][docs].


## Installation

1. Add as a dependency in your project's `pub spec.yaml`.

```yaml
dependencies:
  screwdriver: <latest_version>
```

> Note: Screwdriver exports `collection` package as well. So, you don't need to add `collection` as a dependency in your project.

2. Import library into your code.

```dart
import 'package:screwdriver/screwdriver.dart';
```

3. Use this import for using IO extensions.

```dart
import 'package:screwdriver/screwdriver_io.dart';
```



A Glimpse of Screwdriver

#### String

```dart
'hello'.capitalized; // Hello
'   '.isBlankl // true;
'45'.toIntOrNull(); // 45
'html'.wrap('<','>'); // <html>
'1010111010001'.isBinary; // true
'test@example.com'.isEmail; // true
'abcd'.reversed; // dcba
'This is a test'.words; // ['this', 'is', 'a', 'test']
'{"name":"John"}'.parseJson(); // map: {name:John}
'#hello'.removePrefix('#'); // hello
```

#### Map

```dart
final Map<String, dynamic> map = {
  'name': 'John',
  'age': 24,
};

for(final (key, value) in map.records) {
  print('$key: $value');
}
```

#### Int

```dart
20.isDivisibleBy(5); // true
0.asBool; // false
6.twoDigits; // '06'
2020.isLeapYear; // true
10.repeat((count) => print(count));
```



#### DateTime & Duration

```dart
now().isMonday;
final DateTime fiveDaysAgo = 5.daysAgo;
final Duration nineMinutes = 9.minutes;
45.minutes.isInHours; // false
15.daysAgo < 5.days.ago; // true
20.minutes.ago >= 50.minutes.ago; // true
now().previousDay; // yesterday
10.days.ago.isBetween(15.days.ago, now()); // true
```



#### Double and Bool

```dart
randomDouble(max: 50); // random double value between 0 and 50
56.0.isWhole; // true
true.toggled; // false
false.toInt(); // 0

```



#### Scope Functions

```dart
final User user = User(name: 'John').apply((user){
  user.age = 24;
  user.email = 'john@doe.com';
});
final String age = user.run((u)=> (u.age + 20).toString());
```



#### Collections

```dart
users << User(name: 'John'); // appends user to users list
users.firstOrNull;
users.drop(5);
users.takeLast(3);
user.all((u) => u.age > 18); // returns bool
cars.groupBy((car) => car.color);
cars.count((car) => car.isPorsche);
cars.random();
cars.maxBy((car) => car.price);
cars.intersect(otherCars);
{'name': 'John'} << Pair('email','john@doe.com');
```



#### Future

```dart
postDelayed(2000,(){
  print('after 2 seconds');
});
```



#### IO

```dart
file.onModified(() => print('file modified'));
file.clear(); // flushes all the data of file
file.isEmpty;
file.appendString('hello');
file << 'some text';
file1 + file2; // appends file2 content at the end of file1
```



#### Some More

```dart
check(divider != 0);
runCaching((){
  count / 0;
});
TODO('find a way to implement this properly'); // throws UnimplementedError on invocation
Triple(45,true, 'Hello World');
user.takeIf((u) => u.age > 18)?.allowAccess();
person.takeUnless((p) => p > 18)?.areTeenagers();
final DateTime date = tomorrow;
yesterday.isInDecember;
```



Check out [EXTENSIONS.md](EXTENSIONS.md) for a complete list of all the available extensions.

Checkout [documentation][docs] for more details.


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/BirjuVachhani/screwdriver/issues
[docs]: https://pub.dev/documentation/screwdriver/latest/



#### Liked Screwdriver?

Show some love and support by starring the [repository](https://github.com/birjuvachhani/screwdriver).

Or You can

<a href="https://www.buymeacoffee.com/birjuvachhani" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-blue.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>



## License

```
Copyright (c) 2020, Birju Vachhani
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
