import 'package:flutter/material.dart';
import 'package:print_feature_app/receipt_item.dart';

class ReceiptItemWidget extends StatelessWidget {
  final ReceiptItem item;

  const ReceiptItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item.name),
        Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
      ],
    );
  }
}
