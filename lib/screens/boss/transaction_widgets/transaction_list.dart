import 'package:flutter/material.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(String) onCancel;

  const TransactionList({
    super.key,
    required this.items,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return TransactionItem(tx: items[index], onCancel: onCancel);
      },
    );
  }
}
