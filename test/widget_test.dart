import 'package:flutter_test/flutter_test.dart';
import 'package:minm/main.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart';

void main() {
  late MockBarcodeScanner mockBarcodeScanner;
  late MockBookDetailsFetcher mockBookDetailsFetcher;

  setUp(() {
    mockBarcodeScanner = MockBarcodeScanner();
    mockBookDetailsFetcher = MockBookDetailsFetcher();
  });

  group('Book details test', () {
    testWidgets('Initial state', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp(
        barcodeScanner: mockBarcodeScanner,
        bookDetailsFetcher: mockBookDetailsFetcher,
      ));

      // Verify that our book details start with 'No book scanned yet'.
      expect(find.text('No book scanned yet'), findsOneWidget,
          reason: 'Initial state should show "No book scanned yet"');
    });

    testWidgets('After scanning barcode', (WidgetTester tester) async {
      when(mockBarcodeScanner.scanBarcode())
          .thenAnswer((_) => Future.value('1234567890'));
      when(mockBookDetailsFetcher.fetchBookDetails('1234567890'))
          .thenAnswer((_) async => 'Mock Book Details');

      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp(
        barcodeScanner: mockBarcodeScanner,
        bookDetailsFetcher: mockBookDetailsFetcher,
      ));

      // Tap the 'Scan Barcode and Fetch Details' button and trigger a frame.
      await tester.tap(find.text('Scan Barcode and Fetch Details'));
      await tester.pump();

      // Verify that our book details have been updated.
      expect(find.text('No book scanned yet'), findsNothing,
          reason:
              'After scanning, "No book scanned yet" should not be visible');
      expect(find.text('Mock Book Details'), findsOneWidget,
          reason: 'After scanning, book details should be updated');
    });
  });
}
