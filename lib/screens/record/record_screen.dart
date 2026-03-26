import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'widgets/record_toggle.dart';
import 'widgets/trx_category_grid.dart';

class RecordScreen extends StatelessWidget {
  final VoidCallback onClose; // Fungsi untuk tombol "X" agar kembali ke Beranda

  const RecordScreen({super.key, required this.onClose});

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
              // Header dengan tombol Close (X)
              Row(
                children: [
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
                      child: const Icon(Icons.close, color: AppColors.textDark, size: 16),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text('Tambah Transaksi', style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 34), // Penyeimbang ruang agar judul persis di tengah
                ],
              ),
              const SizedBox(height: 24),

              // Toggle Pengeluaran / Pemasukan
              const RecordToggle(),
              const SizedBox(height: 24),

              // Card Input Nominal Besar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                child: Column(
                  children: [
                    const Text('Nominal', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Rp', style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        // Menggunakan IntrinsicWidth agar TextField ukurannya menyesuaikan teks
                        IntrinsicWidth(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: 1),
                            decoration: const InputDecoration(
                              hintText: '0',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            controller: TextEditingController(text: '500.000'), // Nilai awal sesuai desain
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // AI Warning Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFFEF5E6), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFDE6C8))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.smart_toy_outlined, color: AppColors.warningOrange, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Peringatan AI', style: TextStyle(color: AppColors.statusWarningText, fontWeight: FontWeight.bold, fontSize: 12)),
                          SizedBox(height: 4),
                          Text(
                            'Jika pengeluaran ini dicatat, target Pembelian Barang Anda akan tertunda 1 minggu. Pastikan ini adalah kebutuhan mendesak.',
                            style: TextStyle(color: AppColors.textDark, fontSize: 11, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Kategori
              const Text('Kategori', style: TextStyle(color: AppColors.textDark, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const TrxCategoryGrid(),
              const SizedBox(height: 24),

              // Tanggal
              const Text('Tanggal', style: TextStyle(color: AppColors.textDark, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildTextField(hintText: '15 Oktober 2023', suffixIcon: Icons.calendar_today_outlined, readOnly: true),
              const SizedBox(height: 20),

              // Catatan
              const Text('Catatan (Opsional)', style: TextStyle(color: AppColors.textDark, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildTextField(hintText: 'Tulis detail transaksi...'),
              const SizedBox(height: 32),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Logika simpan transaksi
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Simpan Transaksi', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20), // Spasi bawah agar tidak mentok dengan Navigation Bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hintText, IconData? suffixIcon, bool readOnly = false}) {
    return TextField(
      readOnly: readOnly,
      style: const TextStyle(fontSize: 14, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.normal),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppColors.textGrey, size: 20) : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryGreen)),
      ),
    );
  }
}