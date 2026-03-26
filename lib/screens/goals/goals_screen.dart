import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'widgets/goal_card.dart';
import 'add_goal_screen.dart';
import '../../../models/goal_model.dart';
import '../../../core/database/database_helper.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<GoalModel> _goals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshGoals(); // Muat data dari database saat layar pertama kali dibuka
  }

  // Fungsi untuk mengambil data dari SQLite
  Future<void> _refreshGoals() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllGoals();
    setState(() {
      _goals = data;
      _isLoading = false;
    });
  }

  // Helper untuk mengubah angka menjadi format Rupiah (tanpa package intl)
  String _formatCurrency(double amount) {
    String amountStr = amount.toInt().toString();
    String result = '';
    int count = 0;
    for (int i = amountStr.length - 1; i >= 0; i--) {
      if (count != 0 && count % 3 == 0) {
        result = '.$result';
      }
      result = amountStr[i] + result;
      count++;
    }
    return 'Rp $result';
  }

  // Helper untuk menentukan Ikon berdasarkan Kategori
  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Pembelian Barang':
        return Icons.laptop_mac;
      case 'Dana Darurat':
        return Icons.health_and_safety_outlined;
      case 'Pelunasan Hutang':
        return Icons.credit_card;
      case 'Akumulasi Aset':
        return Icons.trending_up;
      default:
        return Icons.track_changes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tujuan Keuangan', style: TextStyle(color: AppColors.textDark, fontSize: 20, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () async {
                      // Navigasi ke halaman Tambah Tujuan dan tunggu hasilnya
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddGoalScreen()),
                      );
                      
                      // Jika result == true (ada data baru yang disimpan), refresh list
                      if (result == true) {
                        _refreshGoals();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
                      child: const Icon(Icons.add, color: AppColors.textDark, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // AI Financial Advisor Card (Statis)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.primaryGreen, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AI Financial Advisor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 4),
                          Text(
                            'Pengeluaran Anda bulan ini lebih boros di kategori Gaya Hidup. Ada 2 tujuan yang berisiko tertunda jika tren ini berlanjut.',
                            style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bagian Daftar Goals Dinamis
              if (_isLoading)
                const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
              else if (_goals.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.track_changes_outlined, size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text('Belum ada tujuan keuangan.', style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                      ],
                    ),
                  ),
                )
              else
                // Looping data dari SQLite untuk membuat UI Card
                ..._goals.map((goal) {
                  // Logika Warna Status berdasarkan Progress
                  Color progColor = AppColors.primaryGreen;
                  Color statBgColor = AppColors.statusSuccessBg;
                  Color statTextColor = AppColors.statusSuccessText;
                  String statText = 'Sesuai Target';
                  IconData statIcon = Icons.check_circle_outline;

                  if (goal.progress >= 1.0) {
                    statText = 'Tercapai';
                  } else if (goal.progress < 0.3) {
                    progColor = AppColors.progressBrown;
                    statBgColor = AppColors.statusDangerBg;
                    statTextColor = AppColors.statusDangerText;
                    statText = 'Beresiko Gagal';
                    statIcon = Icons.error_outline;
                  } else if (goal.progress < 0.6) {
                    progColor = AppColors.progressBrown;
                    statBgColor = AppColors.statusWarningBg;
                    statTextColor = AppColors.statusWarningText;
                    statText = 'Sedang Berjalan';
                    statIcon = Icons.access_time;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GoalCard(
                      category: goal.category.toUpperCase(),
                      title: goal.title,
                      percentage: '${(goal.progress * 100).toInt()}%',
                      progressValue: goal.progress,
                      progressColor: progColor,
                      currentAmount: _formatCurrency(goal.currentAmount),
                      targetAmount: _formatCurrency(goal.targetAmount),
                      statusText: statText,
                      statusTextColor: statTextColor,
                      statusBgColor: statBgColor,
                      statusIcon: statIcon,
                      iconData: _getIconForCategory(goal.category),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}