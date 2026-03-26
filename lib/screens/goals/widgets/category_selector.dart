import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CategorySelector extends StatefulWidget {
  // 1. Tambahin parameter onChanged
  final Function(String) onCategorySelected;

  const CategorySelector({super.key, required this.onCategorySelected});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int _selectedIndex = 0; 

  final List<Map<String, dynamic>> _categories = [
    {'title': 'Pembelian Barang', 'icon': Icons.laptop_mac},
    {'title': 'Dana Darurat', 'icon': Icons.health_and_safety_outlined},
    {'title': 'Pelunasan Hutang', 'icon': Icons.credit_card},
    {'title': 'Akumulasi Aset', 'icon': Icons.trending_up},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final isSelected = _selectedIndex == index;
        final item = _categories[index];

        return GestureDetector(
          onTap: () {
            setState(() => _selectedIndex = index);
            // 2. Kirim judul kategori ke AddGoalScreen lewat callback
            widget.onCategorySelected(item['title'] as String);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.lightGreenBg : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? AppColors.primaryGreen : Colors.grey.shade200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'] as IconData, color: isSelected ? AppColors.primaryGreen : AppColors.primaryGreen.withOpacity(0.5), size: 24),
                const SizedBox(height: 8),
                Text(item['title'] as String, style: TextStyle(color: isSelected ? AppColors.primaryGreen : AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}