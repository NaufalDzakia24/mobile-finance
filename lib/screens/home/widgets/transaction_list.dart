import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/transaction_model.dart';
import '../../../core/database/database_helper.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Transaksi Terakhir', 
          style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        
        // Gunakan FutureBuilder untuk mengambil data dari SQLite
        FutureBuilder<List<TransactionModel>>(
          future: DatabaseHelper.instance.getTransactions(limit: 5), // Ambil 5 transaksi terakhir
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Belum ada transaksi.', style: TextStyle(color: AppColors.textGrey)),
                ),
              );
            }

            final transactions = snapshot.data!;

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final trx = transactions[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(12), 
                    border: Border.all(color: Colors.grey.shade200)
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                        child: Icon(trx.icon, color: AppColors.textDark, size: 24), // Menggunakan getter icon dari model
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(trx.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark)),
                            const SizedBox(height: 4),
                            Text(trx.date, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(
                        // Format tampilan: +Rp atau -Rp
                        "${trx.isExpense ? '-' : '+'} Rp ${trx.amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 14, 
                          color: trx.isExpense ? AppColors.expenseRed : AppColors.primaryGreen
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}