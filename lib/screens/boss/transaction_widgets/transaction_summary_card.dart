import 'package:flutter/material.dart';

class TransactionSummaryCard extends StatelessWidget {
  final double income;
  final double expense;
  final double balance;
  final Color mainColor;

  const TransactionSummaryCard({
    super.key,
    required this.income,
    required this.expense,
    required this.balance,
    required this.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${balance.toStringAsFixed(2)}₺",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: mainColor,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
