import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CustomBarChart extends StatelessWidget {
  const CustomBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Text('Total Pengeluaran', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
          const SizedBox(height: 4),
          const Text('Rp 4.200.000', style: TextStyle(color: AppColors.textDark, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar('Jun', 0.4, AppColors.primaryGreen, AppColors.lightGreenBg),
              _buildBar('Jul', 0.5, AppColors.primaryGreen, AppColors.lightGreenBg),
              _buildBar('Agu', 0.45, AppColors.primaryGreen, AppColors.lightGreenBg),
              _buildBar('Sep', 0.6, AppColors.primaryGreen, AppColors.lightGreenBg),
              // Bulan Oktober di-highlight warna merah sesuai desain
              _buildBar('Okt', 0.8, AppColors.expenseRed, AppColors.iconBgRed), 
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double fillPercentage, Color color, Color bgColor) {
    return Column(
      children: [
        Container(
          width: 35,
          height: 120, // Tinggi maksimal bar
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 35,
            height: 120 * fillPercentage, // Tinggi sesuai persentase
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }
}