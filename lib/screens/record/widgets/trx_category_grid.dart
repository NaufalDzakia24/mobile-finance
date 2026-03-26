import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TrxCategoryGrid extends StatefulWidget {
  const TrxCategoryGrid({super.key});

  @override
  State<TrxCategoryGrid> createState() => _TrxCategoryGridState();
}

class _TrxCategoryGridState extends State<TrxCategoryGrid> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {'title': 'Gaya Hidup', 'icon': Icons.shopping_bag_outlined},
    {'title': 'Makanan', 'icon': Icons.local_cafe_outlined},
    {'title': 'Transport', 'icon': Icons.directions_car_outlined},
    {'title': 'Lainnya', 'icon': Icons.more_horiz},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_categories.length, (index) {
        final isSelected = _selectedIndex == index;
        final item = _categories[index];

        return GestureDetector(
          onTap: () => setState(() => _selectedIndex = index),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.expenseRed.withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSelected ? AppColors.expenseRed : Colors.grey.shade200, width: isSelected ? 1.5 : 1),
                ),
                child: Icon(item['icon'] as IconData, color: isSelected ? AppColors.expenseRed : AppColors.textGrey, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                item['title'] as String,
                style: TextStyle(color: isSelected ? AppColors.textDark : AppColors.textGrey, fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500),
              ),
            ],
          ),
        );
      }),
    );
  }
}