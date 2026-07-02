import 'package:screwdriver/screwdriver.dart';
import 'package:test/test.dart';

void main() {
  test('Object tests', () {
    String? name;
    expect(name.isNull, isTrue);
    expect(name.isNotNull, isFalse);
    name = 'test';
    expect(name.isNull, isFalse);
    expect(name.isNotNull, isTrue);
  });
}
