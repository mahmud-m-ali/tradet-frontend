import 'package:flutter_test/flutter_test.dart';
import 'package:halalet_app/main.dart';

void main() {
  testWidgets('App launches and shows HalalEt branding', (WidgetTester tester) async {
    await tester.pumpWidget(const HalalEtApp());
    await tester.pump();

    // The app should show the HalalEt branding during splash
    expect(find.textContaining('ሃላልኢት'), findsAny);
  });
}
