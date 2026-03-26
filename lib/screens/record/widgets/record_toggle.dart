import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class RecordToggle extends StatefulWidget {
  const RecordToggle({super.key});

  @override
  State<RecordToggle> createState() => _RecordToggleState();
}

class _RecordToggleState extends State<RecordToggle> {
  bool isExpense = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.lightGreenBg, borderRadius: BorderRadius.circular(12)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;
          return Stack(
            children: [
              // Animasi Background Putih
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                left: isExpense ? 0 : tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => isExpense = true),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: isExpense ? AppColors.expenseRed : AppColors.textGrey, // Warna merah jika pengeluaran
                            fontWeight: isExpense ? FontWeight.bold : FontWeight.w500,
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
                      onTap: () => setState(() => isExpense = false),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: !isExpense ? AppColors.primaryGreen : AppColors.textGrey, // Warna hijau jika pemasukan
                            fontWeight: !isExpense ? FontWeight.bold : FontWeight.w500,
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