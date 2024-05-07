import 'package:flutter_test/flutter_test.dart';
import 'package:minm/main.dart';
import 'package:mockito/mockito.dart';

class MockBarcodeScanner extends Mock implements BarcodeScanner {}

class MockBookDetailsFetcher extends Mock implements BookDetailsFetcher {}

void main() {
  testWidgets('Book details test', (WidgetTester tester) async {
    // Create mock classes
    final mockBarcodeScanner = MockBarcodeScanner();
    final mockBookDetailsFetcher = MockBookDetailsFetcher();

    // Use when() to specify how the mock classes should behave
    when(mockBarcodeScanner.scanBarcode())
        .thenAnswer((_) async => '1234567890');
    when(mockBookDetailsFetcher.fetchBookDetails('1234567890'))
        .thenAnswer((_) async => 'Mock Book Details');

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      barcodeScanner: mockBarcodeScanner,
      bookDetailsFetcher: mockBookDetailsFetcher,
    ));

    // Verify that our book details start with 'No book scanned yet'.
    expect(find.text('No book scanned yet'), findsOneWidget);

    // Tap the 'Scan Barcode and Fetch Details' button and trigger a frame.
    await tester.tap(find.text('Scan Barcode and Fetch Details'));
    await tester.pump();

    // Verify that our book details have been updated.
    expect(find.text('No book scanned yet'), findsNothing);
    expect(find.text('Mock Book Details'), findsOneWidget);
  });
}
