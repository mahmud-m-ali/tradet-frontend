import 'package:flutter_test/flutter_test.dart';
import 'package:tradet_app/main.dart';

void main() {
  testWidgets('App launches and shows TradEt branding', (WidgetTester tester) async {
    await tester.pumpWidget(const TradEtApp());
    await tester.pump();

    // The app should show the TradEt branding during splash
    expect(find.textContaining('ትሬድኢት'), findsAny);
  });
}
