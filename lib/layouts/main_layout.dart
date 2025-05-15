import 'package:mobil/controllers/core/user_session_controller.dart';
import 'package:mobil/screens/appointments/appointment_screen.dart';
import 'package:mobil/screens/boss/boss_home_screen.dart';
import 'package:mobil/screens/boss/employees_screen.dart'; // yeni sayfa
import 'package:mobil/screens/common/settings_screen.dart';
import 'package:mobil/screens/employee/performance_screen.dart';
import 'package:mobil/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final session = Get.find<UserSessionController>();

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  static final List<Widget> _screens = [
    const BossHomeScreen(),
    const AppointmentScreen(),
    const EmployeesScreen(),
    const PerformanceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavBarItem(Iconsax.main_component, 'Anasayfa', 0),
            buildNavBarItem(Iconsax.calendar_1, 'Randevu', 1),
            const SizedBox(
              width: ProjectSizes.IconM,
            ),
            buildNavBarItem(Iconsax.user_search, 'Çalışanlar', 2),
            buildNavBarItem(Iconsax.setting_2, 'Ayarlar', 3),
          ],
        ),
      ),
      floatingActionButton: ClipOval(
        child: Material(
          color: const Color.fromRGBO(30, 142, 186, 1),
          elevation: 10,
          child: InkWell(
            onTap: () => Get.toNamed('/add-appointment'),
            child: const SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildNavBarItem(IconData icon, String label, int index) {
    final bool isSelected = _currentIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isSelected ? 28 : 24, // büyüklük farkı
            color: isSelected
                ? const Color.fromRGBO(30, 142, 186, 1)
                : Colors.grey.shade700, // renk farkı
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? const Color.fromRGBO(30, 142, 186, 1)
                      : Colors.grey,
                ),
          )
        ],
      ),
    );
  }
}
