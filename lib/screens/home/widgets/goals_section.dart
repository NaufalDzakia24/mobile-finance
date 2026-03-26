import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/goal_model.dart';
import '../../../core/database/database_helper.dart';

class GoalsSection extends StatefulWidget {
  const GoalsSection({super.key});

  @override
  State<GoalsSection> createState() => _GoalsSectionState();
}

class _GoalsSectionState extends State<GoalsSection> {
  List<GoalModel> _goals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGoals(); // Mengambil data dari SQLite saat Beranda dimuat
  }

  Future<void> _fetchGoals() async {
    final data = await DatabaseHelper.instance.getAllGoals();
    
    // Jika komponen masih aktif (mounted), perbarui UI
    if (mounted) {
      setState(() {
        _goals = data;
        _isLoading = false;
      });
    }
  }

  // Fungsi mengubah format angka jadi Rupiah (Misal: 5000000 -> 5M atau 5.000.000)
  // Untuk desain kartu kecil ini, kita persingkat jadi juta (Jt) / miliar (M) agar rapi
  String _formatShortCurrency(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1).replaceAll('.0', '')}M';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1).replaceAll('.0', '')} Jt';
    } else {
      return (amount / 1000).toStringAsFixed(0) + ' Rb'; // Format ribuan
    }
  }

  // Fungsi untuk mendapatkan ikon berdasarkan kategori
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tujuan Keuangan', style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        
        // Menampilkan loading, status kosong, atau list data
        if (_isLoading)
          const SizedBox(height: 140, child: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)))
        else if (_goals.isEmpty)
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
            child: const Center(child: Text('Belum ada tujuan.\nTambahkan di menu Tujuan.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textGrey, fontSize: 12))),
          )
        else
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _goals.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final goal = _goals[index];
                
                // Menentukan warna progress bar
                Color progressColor = goal.progress >= 1.0 ? AppColors.primaryGreen : AppColors.progressBrown;

                return Container(
                  width: 160,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(color: AppColors.lightGreenBg, shape: BoxShape.circle),
                            child: Icon(_getIconForCategory(goal.category), color: AppColors.primaryGreen, size: 20),
                          ),
                          const Icon(Icons.more_vert, color: AppColors.textGrey, size: 20),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title, 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis, // Agar teks tidak melebar jika kepanjangan
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark)
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${_formatShortCurrency(goal.currentAmount)} / ${_formatShortCurrency(goal.targetAmount)}', 
                            style: const TextStyle(color: AppColors.textGrey, fontSize: 12)
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: goal.progress,
                            backgroundColor: AppColors.lightGreenBg,
                            color: progressColor,
                            minHeight: 4,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text('${(goal.progress * 100).toInt()}%', style: const TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}