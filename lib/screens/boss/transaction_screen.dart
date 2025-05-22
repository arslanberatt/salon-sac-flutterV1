import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/screens/boss/home/widgets/boss_app_bar.dart';
import 'package:mobil/screens/boss/transaction_widgets/transaction_action_buttons.dart';
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

      print(balance);

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: BossAppBar(),
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
              TransactionActionButtons(
                mainColor: mainColor,
                onWithdraw: () =>
                    showTransactionDialog(context, 'gider', controller),
                onContribute: () =>
                    showTransactionDialog(context, 'gelir', controller),
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
}
