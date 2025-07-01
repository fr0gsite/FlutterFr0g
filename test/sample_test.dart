import 'package:flutter_test/flutter_test.dart';
import 'package:fr0gsite/nameconverter.dart';

void main() {
  testWidgets('NameConverter converts back and forth', (tester) async {
    const name = 'helloworld1';
    final value = NameConverter.nameToUint64(name);
    final result = NameConverter.uint64ToName(value);
    expect(result, equals(name));
  });
}
