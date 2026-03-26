import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';


class StatHeader extends StatelessWidget {
  const StatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Statistik',
          style: TextStyle(color: AppColors.textDark, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: const [
              Text('Oktober 2023', style: TextStyle(fontSize: 12, color: AppColors.textDark)),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textDark),
            ],
          ),
        ),
      ],
    );
  }
}