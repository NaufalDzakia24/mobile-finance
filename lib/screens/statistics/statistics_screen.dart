import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../home/widgets/insight_card.dart'; // Reusable dari Home!
import 'widgets/stat_header.dart';
import 'widgets/stat_toggle.dart';
import 'widgets/custom_bar_chart.dart';
import 'widgets/top_expenses_list.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              StatHeader(),
              SizedBox(height: 20),
              
              // Gunakan InsightCard yang sudah dibuat sebelumnya, 
              // tapi di project nyata Anda bisa buat agar teksnya dinamis.
              // Untuk sekarang kita pakai UI yang mirip.
              _StatInsightCard(), 
              SizedBox(height: 24),

              StatToggle(),
              SizedBox(height: 24),

              CustomBarChart(),
              SizedBox(height: 24),

              TopExpensesList(),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget khusus untuk insight di halaman statistik
class _StatInsightCard extends StatelessWidget {
  const _StatInsightCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.warningOrange, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.smart_toy_outlined, color: AppColors.warningOrange),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Insight AI: Ringkasan 3 Bulan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 4),
                Text(
                  'Pengeluaran untuk Gaya Hidup mendominasi 40% dari total pengeluaran Anda. Kurangi pengeluaran ini agar target Dana Darurat Anda tidak tertunda lebih lama.',
                  style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}