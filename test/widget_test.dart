import 'package:flutter_test/flutter_test.dart';

import 'package:artesia_aplikasi_art_gallery/main.dart';

void main() {
  testWidgets('shows login page first', (WidgetTester tester) async {
    await tester.pumpWidget(const ArtGalleryApp());

    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('LOG IN'), findsOneWidget);
  });
}
