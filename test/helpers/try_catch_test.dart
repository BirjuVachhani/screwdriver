import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  Future<int> someFuture(int value) async {
    if (value < 0) throw ArgumentError('Value must be greater than zero');
    return Future.value(value);
  }

  test('tryCatch function test', () async {
    expect(() => tryCatch(someFuture(22)), returnsNormally);
    expect(() => tryCatch(someFuture(-1)), returnsNormally);
    expect(tryCatch(someFuture(20)), completion(equals((20, null))));
    expect(tryCatch(someFuture(-20)), completion(isA<(int?, TryCatchError)>()));
  });

  test('tryCatch function test', () async {
    expect(() => tryCatchOnly<int, FormatException>(someFuture(-1)),
        throwsArgumentError);

    expect(() => tryCatchOnly<int, ArgumentError>(someFuture(-1)),
        returnsNormally);

    expect(tryCatchOnly<int, ArgumentError>(someFuture(20)),
        completion(equals((20, null))));
    expect(tryCatchOnly<int, ArgumentError>(someFuture(-20)),
        completion(isA<(int?, TryCatchError<ArgumentError>)>()));
  });
}
