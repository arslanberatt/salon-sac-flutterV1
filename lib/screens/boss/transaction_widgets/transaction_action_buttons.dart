import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobil/core/transactions/transaction_controller.dart';
import 'package:mobil/utils/theme/widget_themes/custom_snackbar.dart';

class TransactionActionButtons extends StatelessWidget {
  final Color mainColor;
  final VoidCallback onWithdraw;
  final VoidCallback onContribute;

  const TransactionActionButtons(
      {super.key,
      required this.mainColor,
      required this.onWithdraw,
      required this.onContribute});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _actionButton("Nakit Çek", Iconsax.wallet_minus, Colors.grey.shade200,
            Colors.black, onWithdraw),
        _actionButton("Katkı Yap", Iconsax.add_circle,
            mainColor.withOpacity(0.15), mainColor, onContribute),
      ],
    );
  }

  Widget _actionButton(String label, IconData icon, Color bgColor,
      Color textColor, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
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

void showTransactionDialog(
    BuildContext context, String type, TransactionController controller) {
  final amountController = TextEditingController();
  final descController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(type == 'gider' ? 'Nakit Çek' : 'Katkı Yap'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Tutar (₺)"),
          ),
          TextField(
            controller: descController,
            decoration: const InputDecoration(labelText: "Açıklama"),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Vazgeç"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text("Kaydet"),
          onPressed: () {
            final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
            final desc = descController.text.trim();

            if (amount > 0 && desc.isNotEmpty) {
              controller.addTransaction(
                  type: type, amount: amount, description: desc);
              Navigator.pop(context);
            } else {
              CustomSnackBar.errorSnackBar(
                  title: "Hata",
                  message: "Lütfen geçerli bir tutar ve açıklama girin.");
            }
          },
        ),
      ],
    ),
  );
}
