import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/screens/boss/transaction_widgets/transaction_list.dart';
import 'package:mobil/screens/boss/transaction_widgets/transaction_summary_card.dart';
import '../../core/transactions/transaction_controller.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({super.key});

  final Color mainColor = const Color.fromRGBO(30, 142, 186, 1);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionController());

    return Obx(() {
      final items = controller.transactions.toList();
      final totalIncome = controller.totalIncome;
      final totalExpense = controller.totalExpense;
      final balance = totalIncome - totalExpense;

      return Scaffold(
        backgroundColor: const Color.fromARGB(249, 255, 255, 255),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "SALON SAÇ",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontFamily: 'Teko',
              color: Colors.black87,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset("assets/images/kasa.png",
                    height: 120, width: 120),
              ),
              const SizedBox(height: 12),

              /// Özet Kart
              TransactionSummaryCard(
                income: totalIncome,
                expense: totalExpense,
                balance: balance,
                mainColor: mainColor,
              ),

              const SizedBox(height: 24),

              /// Aksiyon Butonları
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => showTransactionDialog(
                      context,
                      'gelir',
                      controller,
                      label: 'Gelir Ekle',
                    ),
                    icon: const Icon(Icons.add_circle),
                    label: const Text("Gelir Ekle"),
                    style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => showTransactionDialog(
                      context,
                      'gider',
                      controller,
                      label: 'Ödeme Yap',
                    ),
                    icon: const Icon(Icons.remove_circle),
                    label: const Text("Ödeme Yap"),
                    style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Geçmiş İşlemler",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),

              /// İşlem Listesi
              Expanded(
                child: TransactionList(
                  items: items,
                  onCancel: controller.cancelTransaction,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void showTransactionDialog(
      BuildContext context, String type, TransactionController controller,
      {required String label}) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(label),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tutar'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Açıklama'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0;
              final desc = descController.text.trim();
              if (amount > 0 && desc.isNotEmpty) {
                controller.addTransaction(
                  type: type,
                  amount: amount,
                  description: desc,
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Kaydet"),
          ),
        ],
      ),
    );
  }
}
