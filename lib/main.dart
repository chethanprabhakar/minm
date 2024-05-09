import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp(
    barcodeScanner: RealBarcodeScanner(),
    bookDetailsFetcher: RealBookDetailsFetcher(),
  ));
}

class MyApp extends StatelessWidget {
  final BarcodeScanner barcodeScanner;
  final BookDetailsFetcher bookDetailsFetcher;

  const MyApp(
      {super.key,
      required this.barcodeScanner,
      required this.bookDetailsFetcher});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
        barcodeScanner: barcodeScanner,
        bookDetailsFetcher: bookDetailsFetcher,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final BarcodeScanner barcodeScanner;
  final BookDetailsFetcher bookDetailsFetcher;

  const HomePage({
    Key? key,
    required this.barcodeScanner,
    required this.bookDetailsFetcher,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late BarcodeScanner barcodeScanner;
  late BookDetailsFetcher bookDetailsFetcher;
  String _bookDetails = 'No book scanned yet';

  @override
  void initState() {
    super.initState();
    barcodeScanner = widget.barcodeScanner;
    bookDetailsFetcher = widget.bookDetailsFetcher;
  }

  Future<void> scanBarcodeAndFetchBookDetails() async {
    String barcodeScanRes = await barcodeScanner.scanBarcode();

    if (!mounted) return;

    if (barcodeScanRes == '-1') {
      setState(() {
        _bookDetails = 'Scanning Cancelled';
      });
      return;
    }

    String bookDetails =
        await bookDetailsFetcher.fetchBookDetails(barcodeScanRes);

    setState(() {
      _bookDetails = bookDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_bookDetails),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanBarcodeAndFetchBookDetails,
              child: const Text('Scan Barcode and Fetch Details'),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class BarcodeScanner {
  Future<String> scanBarcode();
}

class RealBarcodeScanner implements BarcodeScanner {
  @override
  Future<String> scanBarcode() {
    return FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
  }
}

abstract class BookDetailsFetcher {
  Future<String> fetchBookDetails(String barcode);
}

class RealBookDetailsFetcher implements BookDetailsFetcher {
  @override
  Future<String> fetchBookDetails(String barcode) async {
    final String url =
        'https://openlibrary.org/api/books?bibkeys=ISBN:$barcode&format=json&jscmd=data';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return json.encode(data['ISBN:$barcode']);
    } else {
      return 'Failed to load book details';
    }
  }
}
