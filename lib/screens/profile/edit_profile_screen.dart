import 'dart:io'; // Tambahan untuk File
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // Tambahan untuk direktori permanen
import 'package:path/path.dart' as p; // Tambahan untuk manipulasi nama file

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
  late TextEditingController _fullNameCtrl;
  late TextEditingController _nicknameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _birthDateCtrl;
  late TextEditingController _bioCtrl;   
  late TextEditingController _hobbyCtrl; 

  String _selectedGender = 'Laki-laki';
  String _base64Image = '';
  String _currentVideoPath = ''; // Variabel untuk menyimpan path video

  @override
  void initState() {
    super.initState();
    
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
    _currentVideoPath = widget.profile.videoPath; // Load video lama jika ada
  }

  @override
  void dispose() {
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
        backgroundColor: Colors.red, // Menggunakan warna merah default jika AppColors.expenseRed tidak ada
        behavior: SnackBarBehavior.floating, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
        margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24), 
        elevation: 6, duration: const Duration(seconds: 3), 
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green, // Gunakan AppColors.primaryGreen jika ada
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      ),
    );
  }

  // 3. IMAGE PICKER
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _base64Image = base64Encode(bytes));
    }
  }

  // 4. VIDEO PICKER (Logika Baru Maks 10MB)
  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedVideo = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 2) 
    );

    if (pickedVideo == null) return; // Batal memilih

    final File videoFile = File(pickedVideo.path);
    int sizeInBytes = await videoFile.length();
    const int maxSizeBytes = 10 * 1024 * 1024; // 10MB

    if (sizeInBytes > maxSizeBytes) {
      _showErrorSnackBar('Ukuran video terlalu besar! Maksimal 10MB.');
      return; 
    }

    try {
      // Salin ke direktori permanen aplikasi
      final Directory appDir = await getApplicationDocumentsDirectory();
      String fileName = "vid_${DateTime.now().millisecondsSinceEpoch}${p.extension(pickedVideo.path)}";
      final String permanentPath = p.join(appDir.path, fileName);

      await videoFile.copy(permanentPath);

      setState(() {
        _currentVideoPath = permanentPath;
      });

      _showSuccessSnackBar("Video berhasil dipilih dan disiapkan.");
    } catch (e) {
      _showErrorSnackBar("Gagal memproses video: $e");
    }
  }

  // 5. DATE PICKER
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, initialDate: DateTime.now(),
      firstDate: DateTime(1950), lastDate: DateTime.now(), 
    );
    if (picked != null) {
      setState(() => _birthDateCtrl.text = "${picked.day}-${picked.month}-${picked.year}");
    }
  }

  // 6. SAVE ACTION
  Future<void> _saveProfile() async {
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();

    if (email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        _showErrorSnackBar('Format email tidak valid! (Contoh: budi@email.com)');
        return; 
      }
    }

    if (phone.isNotEmpty && (phone.length < 10 || phone.length > 14)) {
      _showErrorSnackBar('Nomor HP harus terdiri dari 10 hingga 14 angka!');
      return; 
    }

    final updatedProfile = ProfileModel(
      id: 1, 
      fullName: _fullNameCtrl.text.isEmpty ? 'Pengguna Baru' : _fullNameCtrl.text,
      nickname: _nicknameCtrl.text.isEmpty ? 'Pengguna' : _nicknameCtrl.text,
      email: email.isEmpty ? 'user@email.com' : email,
      phoneNumber: phone.isEmpty ? '-' : phone,
      birthDate: _birthDateCtrl.text.isEmpty ? '-' : _birthDateCtrl.text,
      gender: _selectedGender,
      profilePicture: _base64Image,
      bio: _bioCtrl.text.isEmpty ? 'Fokus mendalami Web Development & Flutter' : _bioCtrl.text, 
      hobby: _hobbyCtrl.text.isEmpty ? 'Membuat Chrome Extension' : _hobbyCtrl.text, 
      videoPath: _currentVideoPath, // Simpan path video ke objek model
    );

    await DatabaseHelper.instance.updateProfile(updatedProfile);
    
    if (mounted) Navigator.pop(context, true); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Sesuaikan dengan AppColors.background Anda
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        title: const Text('Edit Profil', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN FOTO PROFIL ---
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50, backgroundColor: Colors.green.withOpacity(0.2),
                      backgroundImage: _base64Image.isNotEmpty ? MemoryImage(base64Decode(_base64Image)) : null,
                      child: _base64Image.isEmpty ? const Icon(Icons.person, size: 50, color: Colors.green) : null,
                    ),
                    Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, color: Colors.white, size: 16)))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- FORM INPUT TEKS ---
            _buildTextField('Nama Lengkap', _fullNameCtrl, Icons.badge_outlined, hintText: 'Masukkan nama lengkap'),
            const SizedBox(height: 16),
            _buildTextField('Nama Panggilan', _nicknameCtrl, Icons.person_outline, hintText: 'Masukkan nama panggilan'),
            const SizedBox(height: 16),
            _buildTextField('Bio', _bioCtrl, Icons.info_outline, hintText: 'Ceritakan sedikit tentang dirimu...', maxLines: 3),
            const SizedBox(height: 16),
            _buildTextField('Hobi', _hobbyCtrl, Icons.favorite_border, hintText: 'Misal: Membaca, Olahraga, dll'),
            const SizedBox(height: 16),

            // --- BAGIAN VIDEO PROFIL (BARU) ---
            const Text('Video Profil (Maks 10MB)', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _currentVideoPath.isNotEmpty ? Icons.video_library : Icons.video_call_outlined,
                    color: _currentVideoPath.isNotEmpty ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _currentVideoPath.isNotEmpty ? 'Video telah dipilih' : 'Belum ada video',
                      style: TextStyle(color: _currentVideoPath.isNotEmpty ? Colors.black87 : Colors.grey),
                    ),
                  ),
                  // Tombol hapus video jika sudah ada isinya
                  if (_currentVideoPath.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => setState(() => _currentVideoPath = ''),
                    ),
                  ElevatedButton(
                    onPressed: _pickVideo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(_currentVideoPath.isNotEmpty ? 'Ganti' : 'Pilih', style: const TextStyle(color: Colors.green)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- LANJUTAN FORM INPUT ---
            _buildTextField('Email', _emailCtrl, Icons.email_outlined, keyboardType: TextInputType.emailAddress, hintText: 'contoh@email.com'),
            const SizedBox(height: 16),
            _buildTextField('No. HP', _phoneCtrl, Icons.phone_outlined, keyboardType: TextInputType.phone, hintText: '081234567890', inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            const SizedBox(height: 16),
            _buildTextField('Tanggal Lahir', _birthDateCtrl, Icons.calendar_today_outlined, readOnly: true, hintText: 'Pilih tanggal lahir', onTap: () => _selectDate(context)),
            const SizedBox(height: 16),

            const Text('Jenis Kelamin', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.people_outline, color: Colors.grey), filled: true, fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.green)),
              ),
              items: ['Laki-laki', 'Perempuan'].map((String val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
              onChanged: (newValue) => setState(() => _selectedGender = newValue!),
            ),
            const SizedBox(height: 40),

            // --- TOMBOL SIMPAN ---
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 7. REUSABLE INPUT WIDGET
  Widget _buildTextField(
    String label, TextEditingController controller, IconData icon, {
    TextInputType? keyboardType, bool readOnly = false, VoidCallback? onTap,
    String? hintText, List<TextInputFormatter>? inputFormatters, int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller, keyboardType: keyboardType, inputFormatters: inputFormatters, 
          readOnly: readOnly, onTap: onTap, maxLines: maxLines, 
          decoration: InputDecoration(
            hintText: hintText, hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: maxLines > 1 ? Padding(padding: const EdgeInsets.only(bottom: 40), child: Icon(icon, color: Colors.grey)) : Icon(icon, color: Colors.grey),
            filled: true, fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.green)),
          ),
        ),
      ],
    );
  }
}