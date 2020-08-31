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


Checkout [documentation](https://pub.dev/documentation/screwdriver/latest/)