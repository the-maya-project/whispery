import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart';

void main() {
  testWidgets('app should work', (tester) async {
    await tester.pumpWidget(new App());
    expect(find.text('Splash Screen'), findsNothing);
  });
}