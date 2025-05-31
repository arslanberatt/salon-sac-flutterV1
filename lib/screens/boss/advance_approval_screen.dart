import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobil/core/advance/controllers/advance_approval_controller.dart';
import 'package:mobil/utils/constants/colors.dart';
import 'package:mobil/utils/constants/sizes.dart';
import 'package:mobil/utils/loaders/loader_advance.dart';

class AdvanceApprovalScreen extends StatelessWidget {
  const AdvanceApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdvanceApprovalController());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Obx(() {
          if (controller.loading.value) {
            return const Center(child: LoaderAdvance());
          }

          return TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildList(controller.advanceList, controller),
              _buildList(
                controller.advanceList
                    .where((e) => e['status'] == 'beklemede')
                    .toList(),
                controller,
              ),
              _buildList(
                controller.advanceList
                    .where((e) => e['status'] == 'onaylandi')
                    .toList(),
                controller,
              ),
            ],
          );
        }),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "SALON SAÇ",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Teko',
          letterSpacing: 1.2,
          color: Colors.black87,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(24),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: "Tümü"),
                Tab(text: "Beklemede"),
                Tab(text: "Onaylanan"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(
      List<Map<String, dynamic>> list, AdvanceApprovalController controller) {
    if (list.isEmpty) {
      return const Center(child: Text("Bu kategori için talep yok."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(0),
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final employee = item['employee'];
        final isPending = item['status'] == 'beklemede';

        return Container(
          color: isPending ? const Color(0xFFF3F4F6) : Colors.transparent,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage:
                        AssetImage("assets/images/user_placeholder.png"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee['name'] ?? 'Bilinmeyen',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "₺${item['amount']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const TextSpan(
                                text: " tutarında avans talep etti.",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        if ((item['reason'] ?? '').toString().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              item['reason'],
                              style: TextStyle(color: Colors.grey.shade800),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(ProjectSizes.s),
                    decoration: BoxDecoration(
                      color: _getStatusColor(item['status']).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatDate(item['createdAt']),
                      style:
                          TextStyle(color: Colors.grey.shade800, fontSize: 12),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              if (isPending)
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          controller.updateStatus(item['id'], false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ProjectColors.whiteColor,
                        side: const BorderSide(color: ProjectColors.main2Color),
                      ),
                      child: const Text(
                        "Reddet",
                        style: TextStyle(color: ProjectColors.main2Color),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () =>
                          controller.updateStatus(item['id'], true),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text("Onayla"),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'onaylandi':
        return Colors.green;
      case 'reddedildi':
        return Colors.red;
      case 'beklemede':
        return const Color(0xFFF3F4F6);
      default:
        return Colors.transparent;
    }
  }

  String _formatDate(dynamic date) {
    DateTime? parsed;

    if (date == null) return 'Tarih yok';

    // Eğer int gibi gelirse (timestamp)
    if (date is int) {
      // Milisaniyeye göre hesapla
      parsed = DateTime.fromMillisecondsSinceEpoch(date);
    }
    // Eğer string ama sayıysa
    else if (date is String && RegExp(r'^\d+$').hasMatch(date)) {
      parsed = DateTime.fromMillisecondsSinceEpoch(int.tryParse(date) ?? 0);
    }
    // Eğer ISO formatlı string gelirse
    else {
      parsed = DateTime.tryParse(date.toString());
    }

    if (parsed == null) {
      print("⛔ Hatalı tarih geldi: $date");
      return 'Geçersiz';
    }

    return "${parsed.day.toString().padLeft(2, '0')}.${parsed.month.toString().padLeft(2, '0')}.${parsed.year}";
  }
}
