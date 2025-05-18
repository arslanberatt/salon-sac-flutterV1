import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionItem extends StatelessWidget {
  final Map<String, dynamic> tx;
  final Function(String) onCancel;

  const TransactionItem({super.key, required this.tx, required this.onCancel});

  String formatDate(dynamic timestamp) {
    try {
      final dt = timestamp is int
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = tx['type'] == 'gelir';
    final isCanceled = tx['canceled'] == true;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCanceled ? Colors.grey.shade300 : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor:
                isIncome ? Colors.green.shade100 : Colors.red.shade100,
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${tx['createdBy']?['name'] ?? 'Bilinmiyor'}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    decoration: isCanceled
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(tx['createdAt']),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  tx['description'],
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 2),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${isIncome ? '+' : '-'}${tx['amount']}₺",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 4),
              isCanceled
                  ? const Text(
                      "İptal edildi",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic),
                    )
                  : IconButton(
                      icon: const Icon(Icons.cancel_outlined,
                          size: 20, color: Colors.grey),
                      tooltip: "İptal Et",
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text("İşlem İptali"),
                            content: const Text(
                                "Bu işlemi iptal etmek istediğinize emin misiniz?"),
                            actions: [
                              TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text("Vazgeç")),
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                  onCancel(tx['id']);
                                },
                                child: const Text("Evet"),
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
