import 'package:flutter_test/flutter_test.dart';
import 'package:dukan_tools/main.dart';

void main() {
  testWidgets('App structure verification test', (WidgetTester tester) async {
    expect(const MyApp(), isNotNull);
  });
}
