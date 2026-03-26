import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class GoalCard extends StatelessWidget {
  final String category, title, percentage, currentAmount, targetAmount, statusText;
  final double progressValue;
  final Color progressColor, statusTextColor, statusBgColor;
  final IconData statusIcon, iconData;

  const GoalCard({
    super.key,
    required this.category,
    required this.title,
    required this.percentage,
    required this.progressValue,
    required this.progressColor,
    required this.currentAmount,
    required this.targetAmount,
    required this.statusText,
    required this.statusTextColor,
    required this.statusBgColor,
    required this.statusIcon,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppColors.lightGreenBg, shape: BoxShape.circle),
                child: Icon(iconData, color: AppColors.primaryGreen, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category, style: const TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    Text(title, style: const TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Text(percentage, style: const TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey.shade200,
            color: progressColor,
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentAmount, style: const TextStyle(color: AppColors.textDark, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('dari $targetAmount', style: const TextStyle(color: AppColors.textGrey, fontSize: 10)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: statusTextColor.withOpacity(0.3))),
                child: Row(
                  children: [
                    Icon(statusIcon, color: statusTextColor, size: 12),
                    const SizedBox(width: 4),
                    Text(statusText, style: TextStyle(color: statusTextColor, fontSize: 10, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}