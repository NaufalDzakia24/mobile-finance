import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard(Icons.track_changes, '4', 'Tujuan Aktif')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(Icons.calendar_today_outlined, '85', 'Hari\nBergabung')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(Icons.emoji_events_outlined, '2', 'Tujuan\nTercapai')),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: AppColors.lightGreenBg, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.primaryGreen, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textGrey, fontSize: 10, height: 1.2)),
        ],
      ),
    );
  }
}