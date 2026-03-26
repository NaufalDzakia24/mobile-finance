import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert'; 
import 'package:image_picker/image_picker.dart'; 
import '../../core/constants/app_colors.dart';
import '../../../models/profile_model.dart';
import '../../../core/database/database_helper.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileModel profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // 1. INPUT CONTROLLERS
  // Variabel untuk menangkap teks yang diketik user di layar.
  late TextEditingController _fullNameCtrl;
  late TextEditingController _nicknameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _birthDateCtrl;
  late TextEditingController _bioCtrl;   
  late TextEditingController _hobbyCtrl; 

  String _selectedGender = 'Laki-laki';
  String _base64Image = '';

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi: Mengisi form dengan data yang sudah ada di database.
    // Jika datanya masih bawaan sistem (default), kita kosongkan biar user gak capek hapus manual.
    _fullNameCtrl = TextEditingController(text: widget.profile.fullName == 'Pengguna Baru' ? '' : widget.profile.fullName);
    _nicknameCtrl = TextEditingController(text: widget.profile.nickname == 'Pengguna' ? '' : widget.profile.nickname);
    _emailCtrl = TextEditingController(text: widget.profile.email == 'user@email.com' ? '' : widget.profile.email);
    _phoneCtrl = TextEditingController(text: widget.profile.phoneNumber == '-' ? '' : widget.profile.phoneNumber);
    _birthDateCtrl = TextEditingController(text: widget.profile.birthDate == '-' ? '' : widget.profile.birthDate);
    _bioCtrl = TextEditingController(text: widget.profile.bio == 'Fokus mendalami Web Development & Flutter' ? '' : widget.profile.bio);
    _hobbyCtrl = TextEditingController(text: widget.profile.hobby == 'Membuat Chrome Extension' ? '' : widget.profile.hobby);
    
    if (['Laki-laki', 'Perempuan'].contains(widget.profile.gender)) {
      _selectedGender = widget.profile.gender;
    }

    _base64Image = widget.profile.profilePicture;
  }

  @override
  void dispose() {
    // Penting: Menghapus controller dari memori saat layar ditutup agar aplikasi tidak boros RAM (Memory Leak).
    _fullNameCtrl.dispose();
    _nicknameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _birthDateCtrl.dispose();
    _bioCtrl.dispose();
    _hobbyCtrl.dispose();
    super.dispose();
  }

  // 2. VALIDATION HELPERS
  // Fungsi untuk memunculkan pesan error berwarna merah di bawah layar.
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13))),
          ],
        ),
        backgroundColor: AppColors.expenseRed, 
        behavior: SnackBarBehavior.floating, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
        margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24), 
        elevation: 6, duration: const Duration(seconds: 3), 
      ),
    );
  }

  // 3. IMAGE PICKER (Fitur Kamera/Galeri)
  // Mengambil gambar dari galeri HP, lalu mengubahnya menjadi kode Base64 (String) 
  // agar bisa disimpan ke dalam database SQLite yang kaku.
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Kompres gambar ke kualitas 50% biar ukuran database nggak bengkak.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _base64Image = base64Encode(bytes));
    }
  }

  // 4. DATE PICKER (Kalender)
  // Memunculkan kalender bawaan Android/iOS untuk memilih tanggal lahir.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, initialDate: DateTime.now(),
      firstDate: DateTime(1950), lastDate: DateTime.now(), 
    );
    if (picked != null) {
      setState(() => _birthDateCtrl.text = "${picked.day}-${picked.month}-${picked.year}");
    }
  }

  // 5. SAVE ACTION (Penyimpanan Utama)
  // Mengumpulkan semua inputan, memvalidasi formatnya, lalu mengirimnya ke database.
  Future<void> _saveProfile() async {
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();

    // Validasi Email: Menggunakan Regex (Pattern) untuk cek apakah email valid atau asal ketik.
    if (email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        _showErrorSnackBar('Format email tidak valid! (Contoh: budi@email.com)');
        return; 
      }
    }

    // Validasi Nomor HP: Cek panjang angka (standar Indonesia 10-14 angka).
    if (phone.isNotEmpty && (phone.length < 10 || phone.length > 14)) {
      _showErrorSnackBar('Nomor HP harus terdiri dari 10 hingga 14 angka!');
      return; 
    }

    // Merakit objek baru berdasarkan inputan user.
    final updatedProfile = ProfileModel(
      id: 1, // Kita kunci di ID 1 karena aplikasi ini cuma punya 1 user utama.
      fullName: _fullNameCtrl.text.isEmpty ? 'Pengguna Baru' : _fullNameCtrl.text,
      nickname: _nicknameCtrl.text.isEmpty ? 'Pengguna' : _nicknameCtrl.text,
      email: email.isEmpty ? 'user@email.com' : email,
      phoneNumber: phone.isEmpty ? '-' : phone,
      birthDate: _birthDateCtrl.text.isEmpty ? '-' : _birthDateCtrl.text,
      gender: _selectedGender,
      profilePicture: _base64Image,
      bio: _bioCtrl.text.isEmpty ? 'Fokus mendalami Web Development & Flutter' : _bioCtrl.text, 
      hobby: _hobbyCtrl.text.isEmpty ? 'Membuat Chrome Extension' : _hobbyCtrl.text, 
    );

    // Kirim data ke SQLite.
    await DatabaseHelper.instance.updateProfile(updatedProfile);
    
    // Kembali ke layar sebelumnya dengan membawa status 'true' (berhasil simpan).
    if (mounted) Navigator.pop(context, true); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textDark), onPressed: () => Navigator.pop(context)),
        title: const Text('Edit Profil', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Foto dengan Kamera overlay (Gampang buat ganti foto).
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50, backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
                      backgroundImage: _base64Image.isNotEmpty ? MemoryImage(base64Decode(_base64Image)) : null,
                      child: _base64Image.isEmpty ? const Icon(Icons.person, size: 50, color: AppColors.primaryGreen) : null,
                    ),
                    Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, color: Colors.white, size: 16)))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Form-form input dengan icon navigasi yang intuitif.
            _buildTextField('Nama Lengkap', _fullNameCtrl, Icons.badge_outlined, hintText: 'Masukkan nama lengkap'),
            const SizedBox(height: 16),
            _buildTextField('Nama Panggilan', _nicknameCtrl, Icons.person_outline, hintText: 'Masukkan nama panggilan'),
            const SizedBox(height: 16),
            
            // Input Bio dibuat lebih tinggi (maxLines: 3) agar user bisa menulis panjang.
            _buildTextField('Bio', _bioCtrl, Icons.info_outline, hintText: 'Ceritakan sedikit tentang dirimu...', maxLines: 3),
            const SizedBox(height: 16),
            
            _buildTextField('Hobi', _hobbyCtrl, Icons.favorite_border, hintText: 'Misal: Membaca, Olahraga, dll'),
            const SizedBox(height: 16),

            _buildTextField('Email', _emailCtrl, Icons.email_outlined, keyboardType: TextInputType.emailAddress, hintText: 'contoh@email.com'),
            const SizedBox(height: 16),
            
            // Input No HP hanya menerima angka (digitsOnly).
            _buildTextField('No. HP', _phoneCtrl, Icons.phone_outlined, keyboardType: TextInputType.phone, hintText: '081234567890', inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            const SizedBox(height: 16),
            
            // Tanggal lahir ReadOnly (tidak bisa diketik) karena inputnya lewat kalender pop-up.
            _buildTextField('Tanggal Lahir', _birthDateCtrl, Icons.calendar_today_outlined, readOnly: true, hintText: 'Pilih tanggal lahir', onTap: () => _selectDate(context)),
            const SizedBox(height: 16),

            const Text('Jenis Kelamin', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.people_outline, color: AppColors.textGrey), filled: true, fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryGreen)),
              ),
              items: ['Laki-laki', 'Perempuan'].map((String val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
              onChanged: (newValue) => setState(() => _selectedGender = newValue!),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 6. REUSABLE INPUT WIDGET
  // Widget sakti untuk membuat TextField dengan gaya yang seragam.
  Widget _buildTextField(
    String label, TextEditingController controller, IconData icon, {
    TextInputType? keyboardType, bool readOnly = false, VoidCallback? onTap,
    String? hintText, List<TextInputFormatter>? inputFormatters, int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller, keyboardType: keyboardType, inputFormatters: inputFormatters, 
          readOnly: readOnly, onTap: onTap, maxLines: maxLines, 
          decoration: InputDecoration(
            hintText: hintText, hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
            // Jika maxLines > 1 (seperti Bio), ikon dipindah ke atas biar nggak aneh di tengah-tengah.
            prefixIcon: maxLines > 1 ? Padding(padding: const EdgeInsets.only(bottom: 40), child: Icon(icon, color: AppColors.textGrey)) : Icon(icon, color: AppColors.textGrey),
            filled: true, fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryGreen)),
          ),
        ),
      ],
    );
  }
}