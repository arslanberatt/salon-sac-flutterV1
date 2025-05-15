import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mobil/utils/constants/colors.dart';
import '../../controllers/transactions/transaction_controller.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({super.key});
  final ScrollController _scrollController = ScrollController();

  final Color mainColor = Color.fromRGBO(30, 142, 186, 1);

  String formatDate(dynamic timestamp) {
    try {
      final dt = timestamp is int
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));

      return DateFormat.Hm().format(dt.toLocal());
    } catch (_) {
      return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionController());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          controller.visibleCount.value < controller.transactions.length) {
        controller.loadMore();
      }
    });
    return Obx(() {
      final items = controller.transactions;

      double totalIncome = items
          .where((e) => e['type'] == 'gelir' && !e['canceled'])
          .fold(0.0, (sum, e) => sum + (e['amount'] ?? 0.0));
      double totalExpense = items
          .where((e) => e['type'] != 'gelir' && !e['canceled'])
          .fold(0.0, (sum, e) => sum + (e['amount'] ?? 0.0));
      double balance = totalIncome - totalExpense;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            "Birikim Hedefi",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Görsel
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/images/kasa.png",
                  height: 120,
                  width: 120,
                ),
              ),

              const SizedBox(height: 12),

              // Bakiye
              Text(
                "${balance.toStringAsFixed(2)}₺",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),

              const SizedBox(height: 24),

              // Butonlar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton("Nakit Çek", Iconsax.wallet_minus,
                      Colors.grey.shade200, Colors.black),
                  _actionButton("Katkı Yap", Iconsax.add_circle,
                      mainColor.withOpacity(0.15), mainColor),
                ],
              ),

              const SizedBox(height: 24),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Geçmiş İşlemler",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final tx = items[index];
                    final isIncome = tx['type'] == 'gelir';
                    final isCanceled = tx['canceled'] == true;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCanceled
                              ? Colors.grey.shade300
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: isIncome
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            child: Icon(
                              isIncome
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
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
                                    fontSize: 16,
                                    decoration: isCanceled
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatDate(tx['createdAt']),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
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
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.cancel_outlined,
                                          size: 20, color: Colors.grey),
                                      tooltip: "İptal Et",
                                      onPressed: () {
                                        Get.dialog(
                                          Dialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                      Icons
                                                          .warning_amber_rounded,
                                                      size: 48,
                                                      color: Colors.red),
                                                  const SizedBox(height: 12),
                                                  const Text(
                                                    "İşlem İptali",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  const Text(
                                                    "Bu işlemi iptal etmek istediğine emin misin?",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black54),
                                                  ),
                                                  const SizedBox(height: 24),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Expanded(
                                                        child: OutlinedButton(
                                                          onPressed: () =>
                                                              Get.back(),
                                                          style: OutlinedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            side: BorderSide(
                                                              color: Colors.red,
                                                            ),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            "Vazgeç",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Get.back();
                                                            controller
                                                                .cancelTransaction(
                                                                    tx['id']);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color
                                                                    .fromRGBO(
                                                                    30,
                                                                    142,
                                                                    186,
                                                                    1),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                              "Evet"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _actionButton(
      String label, IconData icon, Color bgColor, Color textColor) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: textColor),
      label: Text(label, style: TextStyle(color: textColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
