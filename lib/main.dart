import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String _bookDetails = 'No book scanned yet';

  Future<void> scanBarcodeAndFetchBookDetails() async {
    // Step 1: Scan the barcode
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);

    if (!mounted) return;

    if (barcodeScanRes == '-1') {
      setState(() {
        _bookDetails = 'Scanning Cancelled';
      });
      return;
    }

    // Step 2: Fetch book details
    final String url =
        'https://openlibrary.org/api/books?bibkeys=ISBN:$barcodeScanRes&format=json&jscmd=data';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _bookDetails = json.encode(
            data['ISBN:$barcodeScanRes']); // Simple string representation
      });
    } else {
      setState(() {
        _bookDetails = 'Failed to load book details';
      });
    }
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
