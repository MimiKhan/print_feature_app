// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Print Receipt')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => printReceipt(context),
            child: const Text('Print Receipt'),
          ),
        ),
      ),
    );
  }
}

void printReceipt(BuildContext context) {
  final pdf = pw.Document();

  final doc = ReceiptTemplate(
    customerName: 'John Doe',
    items: [
      ReceiptItem(name: 'Item 1', price: 10.0, quantity: 2),
      ReceiptItem(name: 'Item 2', price: 5.0, quantity: 3),
      ReceiptItem(name: 'Item 3', price: 8.0, quantity: 1),
    ],
  );

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        ReceiptContentWidget(receipt: doc),
      ],
    ),
  );

  Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

class ReceiptContentWidget extends pw.StatelessWidget {
  final ReceiptTemplate receipt;

  ReceiptContentWidget({required this.receipt});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Receipt',
            style: pw.TextStyle(
              fontSize: 24.0,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16.0),
          pw.Text(
            'Customer: ${receipt.customerName}',
            style: const pw.TextStyle(fontSize: 16.0),
          ),
          pw.SizedBox(height: 8.0),
          pw.Divider(),
          pw.SizedBox(height: 8.0),
          pw.Text(
            'Items:',
            style: pw.TextStyle(fontSize: 16.0, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8.0),
          ...receipt.items.map((item) => ReceiptItemWidget(item: item)),
          pw.SizedBox(height: 16.0),
          pw.Divider(),
          pw.SizedBox(height: 8.0),
          pw.Text(
            'Total: \$${receipt.calculateTotal().toStringAsFixed(2)}',
            style: pw.TextStyle(fontSize: 18.0, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ReceiptTemplate {
  final String customerName;
  final List<ReceiptItem> items;

  ReceiptTemplate({required this.customerName, required this.items});

  double calculateTotal() {
    double total = 0.0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }
}

class ReceiptItem {
  final String name;
  final double price;
  final int quantity;

  ReceiptItem(
      {required this.name, required this.price, required this.quantity});
}

class ReceiptItemWidget extends pw.StatelessWidget {
  final ReceiptItem item;

  ReceiptItemWidget({required this.item});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(item.name),
        pw.Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
      ],
    );
  }
}
