import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../home/home_screen.dart';
import '../statistics/statistics_screen.dart';
import '../goals/goals_screen.dart';
import '../record/record_screen.dart';
import '../profile/profile_screen.dart'; // 👈 Import ProfileScreen yang baru dibuat

class MainNavigation extends StatefulWidget {
   MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Menggunakan getter agar setState bisa terpanggil dengan aman dari dalam layar lain
  List<Widget> get _screens => [
  const HomeScreen(),
  const StatisticsScreen(),
  RecordScreen(
    onClose: () {
      setState(() {
        _currentIndex = 0;
      });
    },
  ),
  const GoalsScreen(),
  const ProfileScreen(), // 👈 sekarang boleh const kalau constructor const
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset:  Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: AppColors.textGrey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
             BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
             BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline),
              activeIcon: Icon(Icons.pie_chart),
              label: 'Statistik',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryGreen, width: 2),
                ),
                child:  Icon(
                  Icons.add,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
              ),
              label: 'Catat',
            ),
             BottomNavigationBarItem(
              icon: Icon(Icons.track_changes_outlined),
              activeIcon: Icon(Icons.track_changes),
              label: 'Tujuan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}