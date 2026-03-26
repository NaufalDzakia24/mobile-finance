import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'widgets/category_selector.dart';
import '../../../models/goal_model.dart';
import '../../../core/database/database_helper.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  // 1. Inisialisasi Controller untuk menangkap teks yang diinput user
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Kategori default saat layar pertama kali dibuka
  String _selectedCategory = 'Pembelian Barang';

  @override
  void dispose() {
    // Pastikan controller dibuang saat layar ditutup agar tidak bocor memori
    _titleController.dispose();
    _targetController.dispose();
    _currentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // 2. Fungsi untuk menampilkan Kalender (DatePicker)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Tidak bisa pilih tanggal di masa lalu
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Format simpel: DD-MM-YYYY
        _dateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  // 3. Fungsi untuk menyimpan data ke SQLite
  Future<void> _saveGoal() async {
    // Validasi sederhana agar nama dan target tidak kosong
    if (_titleController.text.isEmpty || _targetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama dan Target Nominal tidak boleh kosong!'),
          backgroundColor: AppColors.expenseRed,
        ),
      );
      return;
    }

    // Membersihkan format Rp dan titik agar menjadi angka murni
    final targetValue =
        double.tryParse(
          _targetController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
    final currentValue =
        double.tryParse(
          _currentController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;

    // Membuat objek GoalModel baru
    final newGoal = GoalModel(
      category: _selectedCategory,
      title: _titleController.text,
      targetAmount: targetValue,
      currentAmount: currentValue,
    );

    // Menyimpan ke Database SQLite
    await DatabaseHelper.instance.insertGoal(newGoal);

    if (mounted) {
      // Kembali ke halaman sebelumnya dan kirim nilai 'true'
      // 'true' ini akan memicu halaman daftar tujuan untuk me-refresh data
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Tujuan',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Kategori',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Catatan: Jika CategorySelector Anda belum mendukung parameter onCategorySelected,
            // sementara ini biarkan `const CategorySelector()`
            // Namun idealnya, Anda menambahkan callback agar kategori yang dipilih masuk ke `_selectedCategory`
            // Ganti baris CategorySelector() lo jadi ini:
            CategorySelector(
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory =
                      category; // Sekarang variabel ini bakal berubah beneran
                });
              },
            ),
            const SizedBox(height: 24),

            _buildInputLabel('Nama Tujuan'),
            _buildTextField(
              controller: _titleController,
              hintText: 'Contoh: Macbook Pro M3',
            ),
            const SizedBox(height: 20),

            _buildInputLabel('Target Nominal'),
            _buildTextField(
              controller: _targetController,
              prefixText: 'Rp\t',
              hintText: '0',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            _buildInputLabel('Sudah Terkumpul (Opsional)'),
            _buildTextField(
              controller: _currentController,
              prefixText: 'Rp\t',
              hintText: '0',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            _buildInputLabel('Target Tanggal'),
            _buildTextField(
              controller: _dateController,
              hintText: 'Pilih Tanggal',
              prefixIcon: Icons.calendar_today_outlined,
              readOnly: true,
              onTap: () => _selectDate(context), // Panggil fungsi DatePicker
            ),
            const SizedBox(height: 40),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveGoal, // Panggil fungsi simpan ke SQLite
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Simpan Tujuan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Tambahkan parameter `TextEditingController? controller` di sini
  Widget _buildTextField({
    TextEditingController? controller,
    String? hintText,
    String? prefixText,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller, // Hubungkan controller ke TextField
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textDark,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.textGrey,
          fontWeight: FontWeight.normal,
        ),
        prefixText: prefixText,
        prefixStyle: const TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.textGrey, size: 20)
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
      ),
    );
  }
}
