// Author: Birju Vachhani
// Created Date: October 27, 2024

import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('complete test', () {
    final Future<int> result = complete<int>((completer) {
      completer.complete(42);
    });
    expect(result, completion(42));

    final Future<int> errorResult = complete<int>((completer) {
      completer.completeError('error');
    });

    expect(errorResult, throwsA('error'));

    final Future<int> asyncResult = complete<int>((completer) {
      Future.delayed(Duration(milliseconds: 100), () {
        completer.complete(42);
      });
    });

    expect(asyncResult, completion(42));

    final Future<int> asyncErrorResult = complete<int>((completer) {
      Future.delayed(Duration(milliseconds: 100), () {
        completer.completeError('error');
      });
    });

    expect(asyncErrorResult, throwsA('error'));
  });
}
