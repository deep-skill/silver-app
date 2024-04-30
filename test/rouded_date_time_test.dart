import 'package:flutter_test/flutter_test.dart';
import 'package:silverapp/roles/driver/helpers/datatime_rouded_string.dart';

void main() {
  group('Function roudedDateTimeToString', () {
    String value = roudedDateTimeToString();
    test('Data time now to string', () {
      expect(value, isNotEmpty);
      expect(value, isA<String>());
    });
  });
}
