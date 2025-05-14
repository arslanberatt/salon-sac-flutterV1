import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/transactions/transaction_controller.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  String formatDate(String? iso) {
    if (iso == null) return "-";
    final dt = DateTime.tryParse(iso);
    if (dt == null) return "-";
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        title: const Text("İşlemlerim"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = controller.transactions;

        double totalIncome = items
            .where((e) => e['type'] == 'gelir' && !e['canceled'])
            .fold(0.0, (sum, e) => sum + (e['amount'] ?? 0.0));
        double totalExpense = items
            .where((e) => e['type'] != 'gelir' && !e['canceled'])
            .fold(0.0, (sum, e) => sum + (e['amount'] ?? 0.0));

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Bu Ayki Net Tutar",
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(
                        "₺${(totalIncome - totalExpense).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "İşlem Geçmişi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                ...items.map((tx) {
                  final isIncome = tx['type'] == 'gelir';
                  final isCanceled = tx['canceled'] == true;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCanceled
                            ? Colors.grey.shade300
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: isIncome
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          child: Icon(
                            isIncome ? Icons.trending_up : Icons.trending_down,
                            color: isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx['description'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  decoration: isCanceled
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatDate(tx['date']),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "${isIncome ? '+' : '-'}₺${tx['amount']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isIncome ? Colors.green : Colors.red,
                              ),
                            ),
                            if (!isCanceled)
                              IconButton(
                                icon: const Icon(Icons.cancel, size: 20),
                                onPressed: () =>
                                    controller.cancelTransaction(tx['id']),
                              ),
                            if (isCanceled)
                              const Text("İptal",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
