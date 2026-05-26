import 'package:flutter_test/flutter_test.dart';
import 'package:wtf_flutter_test/main.dart';

void main() {
  testWidgets('App starts with RoleSelectionView smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that RoleSelectionView is shown.
    expect(find.text('Training & Mentorship'), findsOneWidget);
    expect(find.text('Guru App (Client)'), findsOneWidget);
    expect(find.text('Trainer App (Coach)'), findsOneWidget);
  });
}
