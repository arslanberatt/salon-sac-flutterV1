import 'package:mobil/controllers/appointments/appointment_controller.dart';
import 'package:mobil/screens/common/appointment_loading_screen.dart';
import 'package:mobil/screens/customers/add_customer_screen.dart';
import 'package:mobil/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobil/utils/loaders/list_shimmer.dart';
import 'package:mobil/utils/loaders/loader_appointment.dart';
import 'package:mobil/utils/loaders/shimmer.dart';
import '../shared/stat_card.dart';
import '../shared/check_in_card.dart';

class BossHomeScreen extends StatelessWidget {
  const BossHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentController());

    final name = "Berat Arslan";
    final hello = "Merhaba,";
    final gridContainerTitle = "Randevular ve Özet";

    final mainColorLight = const Color.fromRGBO(71, 172, 211, 1);
    final mainColorNormal = const Color.fromRGBO(30, 142, 186, 1);
    final whiteColor = Colors.white;
    final blackColor = Colors.black;

    BoxDecoration generateCardTheme(Color startColor, Color endColor) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [startColor, endColor],
        ),
        borderRadius: BorderRadius.circular(ProjectSizes.md),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey[100],
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                "assets/images/logo.jpg",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: const Text(
            "SALON SAÇ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Domine',
            ),
          ),
        ),
      ),
      body: Obx(
        () {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: ProjectSizes.pagePadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: ProjectSizes.IconM),
                          Text(hello,
                              style: Theme.of(context).textTheme.headlineSmall),
                          Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Get.to(AddCustomerScreen()),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            "assets/images/employee.png",
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ProjectSizes.containerPaddingL),
                  Text(gridContainerTitle,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: ProjectSizes.containerPaddingS),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: "Randevu",
                          value: "${controller.appointments.length}",
                          isLoading: controller.loading.value,
                          cardTextColor: whiteColor,
                          icon: Iconsax.empty_wallet,
                          decoration: generateCardTheme(
                              mainColorNormal, mainColorLight),
                        ),
                      ),
                      const SizedBox(
                        width: ProjectSizes.s,
                      ),
                      Expanded(
                        child: StatCard(
                          title: "Çalışan",
                          value: "${controller.employees.length}",
                          isLoading: controller.loading.value,
                          cardTextColor: blackColor,
                          icon: Iconsax.calendar_search,
                          decoration: generateCardTheme(whiteColor, whiteColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: ProjectSizes.s,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: "Çalışan",
                          value: "9 Randevu",
                          cardTextColor: blackColor,
                          icon: Iconsax.calendar_edit,
                          decoration: generateCardTheme(whiteColor, whiteColor),
                        ),
                      ),
                      const SizedBox(
                        width: ProjectSizes.s,
                      ),
                      Expanded(
                        child: StatCard(
                          onTap: () => Get.to(AddCustomerScreen()),
                          title: "Müşteriler",
                          value: "Müşteri Ekle",
                          cardTextColor: blackColor,
                          icon: Iconsax.profile_add,
                          decoration: generateCardTheme(whiteColor, whiteColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ProjectSizes.containerPaddingM),
                  Text(
                    "Bugün Yapılanlar",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: ProjectSizes.containerPaddingS),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      if (controller.loading.value) LoaderAppointment(),
                      CheckInCard(
                        title: "Mert Ahmet Şahin",
                        customer: "Tuğba Demir",
                        checkIn: "08:00",
                        checkOut: "11:15",
                        duration: "3 saat 15 dk",
                      ),
                      const SizedBox(height: ProjectSizes.containerPaddingS),
                      CheckInCard(
                        title: "Furkan Şahin",
                        customer: "Kübranur Demir",
                        checkIn: "11:00",
                        checkOut: "12:30",
                        duration: "1 saat 30 dk",
                      ),
                      const SizedBox(height: ProjectSizes.containerPaddingS),
                      CheckInCard(
                        title: "Mert Ahmet Şahin",
                        customer: "Şevval Ümit",
                        checkIn: "14:00",
                        checkOut: "15:40",
                        duration: "1 saat 40 dk",
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
