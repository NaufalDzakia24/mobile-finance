import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class StatToggle extends StatefulWidget {
  const StatToggle({super.key});

  @override
  State<StatToggle> createState() => _StatToggleState();
}

class _StatToggleState extends State<StatToggle> {
  bool isExpenseSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // Menetapkan tinggi tetap agar tap area nyaman
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.lightGreenBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Menghitung lebar setiap tab (dibagi 2)
          final tabWidth = constraints.maxWidth / 2;

          return Stack(
            children: [
              // 1. Animasi Background Putih yang Menggeser (Sliding Effect)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250), // Kecepatan animasi
                curve: Curves.easeInOutCubic, // Gaya animasi yang smooth
                left: isExpenseSelected ? 0 : tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                ),
              ),

              // 2. Teks dan Area Tap (berada di atas background animasi)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque, // Memastikan seluruh area bisa ditap
                      onTap: () => setState(() => isExpenseSelected = true),
                      child: Center(
                        // Animasi transisi warna dan ketebalan teks
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: TextStyle(
                            fontFamily: 'Poppins', // Sesuaikan jika Anda memakai font lain
                            color: isExpenseSelected ? AppColors.textDark : AppColors.textGrey,
                            fontWeight: isExpenseSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 14,
                          ),
                          child: const Text('Pengeluaran'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => isExpenseSelected = false),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: !isExpenseSelected ? AppColors.textDark : AppColors.textGrey,
                            fontWeight: !isExpenseSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 14,
                          ),
                          child: const Text('Pemasukan'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}