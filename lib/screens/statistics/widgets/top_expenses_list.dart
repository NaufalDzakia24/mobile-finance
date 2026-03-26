import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';


class TopExpensesList extends StatelessWidget {
  const TopExpensesList({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk contoh, bisa diganti pakai model nanti
    final items = [
      {'title': 'Gaya Hidup', 'amount': 'Rp 1.680.000', 'progress': 0.6, 'color': AppColors.progressRed, 'bgColor': AppColors.iconBgRed, 'icon': Icons.shopping_bag_outlined},
      {'title': 'Makanan & Minuman', 'amount': 'Rp 1.260.000', 'progress': 0.4, 'color': AppColors.progressOrange, 'bgColor': AppColors.iconBgOrange, 'icon': Icons.local_cafe_outlined},
      {'title': 'Transportasi', 'amount': 'Rp 840.000', 'progress': 0.25, 'color': AppColors.progressBlue, 'bgColor': AppColors.iconBgBlue, 'icon': Icons.directions_car_outlined},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pengeluaran Terbesar', style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: item['bgColor'] as Color, shape: BoxShape.circle),
                        child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark)),
                      const Spacer(),
                      Text(item['amount'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: item['progress'] as double,
                    backgroundColor: AppColors.background,
                    color: item['color'] as Color,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}