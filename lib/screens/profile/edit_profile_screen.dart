import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
  late TextEditingController _fullNameCtrl;
  late TextEditingController _nicknameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _birthDateCtrl;
  late TextEditingController _bioCtrl;
  late TextEditingController _hobbyCtrl;

  String _selectedGender = 'Laki-laki';
  String _base64Image = '';
  String _currentVideoPath = '';

  // MENGUBAH HOBI MENJADI LIST AGAR BISA DIBUAT CHIP/CARD KECIL
  List<String> _hobbiesList = [];

  @override
  void initState() {
    super.initState();

    _fullNameCtrl = TextEditingController(
      text: widget.profile.fullName == 'Pengguna Baru'
          ? ''
          : widget.profile.fullName,
    );
    _nicknameCtrl = TextEditingController(
      text: widget.profile.nickname == 'Pengguna'
          ? ''
          : widget.profile.nickname,
    );
    _emailCtrl = TextEditingController(text: widget.profile.email);
    _phoneCtrl = TextEditingController(
      text: widget.profile.phoneNumber == '-' ? '' : widget.profile.phoneNumber,
    );
    _birthDateCtrl = TextEditingController(
      text: widget.profile.birthDate == '-' ? '' : widget.profile.birthDate,
    );
    _bioCtrl = TextEditingController(
      text: widget.profile.bio == 'Fokus mendalami Web Development & Flutter'
          ? ''
          : widget.profile.bio,
    );
    _hobbyCtrl = TextEditingController();

    // Logika mengambil hobi awal dari database (dipecah berdasarkan koma)
    String initialHobby = widget.profile.hobby == ' Extension'
        ? ''
        : widget.profile.hobby;
    if (initialHobby.isNotEmpty) {
      _hobbiesList = initialHobby
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    if (['Laki-laki', 'Perempuan'].contains(widget.profile.gender)) {
      _selectedGender = widget.profile.gender;
    }

    _base64Image = widget.profile.profilePicture;
    _currentVideoPath = widget.profile.videoPath;
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
        elevation: 6,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _base64Image = base64Encode(bytes));
    }
  }

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedVideo = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 2),
    );

    if (pickedVideo == null) return;

    final File videoFile = File(pickedVideo.path);
    int sizeInBytes = await videoFile.length();
    const int maxSizeBytes = 10 * 1024 * 1024;

    if (sizeInBytes > maxSizeBytes) {
      _showErrorSnackBar('Ukuran video terlalu besar! Maksimal 10MB.');
      return;
    }

    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      String fileName =
          "vid_${DateTime.now().millisecondsSinceEpoch}${p.extension(pickedVideo.path)}";
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(
        () => _birthDateCtrl.text =
            "${picked.day}-${picked.month}-${picked.year}",
      );
    }
  }

  // FUNGSI UNTUK MENAMBAH HOBI KE DALAM LIST
  void _addHobby(String value) {
    String val = value.trim();
    if (val.isNotEmpty && !_hobbiesList.contains(val)) {
      setState(() {
        _hobbiesList.add(val);
      });
    }
    _hobbyCtrl.clear();
  }

  Future<void> _saveProfile() async {
    final phone = _phoneCtrl.text.trim();

    if (phone.isNotEmpty && (phone.length < 10 || phone.length > 14)) {
      _showErrorSnackBar('Nomor HP harus terdiri dari 10 hingga 14 angka!');
      return;
    }

    // Menggabungkan list hobi menjadi text dipisahkan koma saat mau disimpan ke DB
    String finalHobbies = _hobbiesList.join(', ');

    final updatedProfile = ProfileModel(
      id: widget.profile.id,
      fullName: _fullNameCtrl.text.isEmpty
          ? 'Pengguna Baru'
          : _fullNameCtrl.text,
      nickname: _nicknameCtrl.text.isEmpty ? 'Pengguna' : _nicknameCtrl.text,
      email: widget.profile.email,
      phoneNumber: phone.isEmpty ? '-' : phone,
      birthDate: _birthDateCtrl.text.isEmpty ? '-' : _birthDateCtrl.text,
      gender: _selectedGender,
      profilePicture: _base64Image,
      bio: _bioCtrl.text.isEmpty
          ? 'Fokus mendalami Web Development & Flutter'
          : _bioCtrl.text,
      hobby: finalHobbies.isEmpty ? ' Extension' : finalHobbies,
      videoPath: _currentVideoPath,
    );

    await DatabaseHelper.instance.updateProfile(updatedProfile);

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profil',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green.withOpacity(0.2),
                      backgroundImage: _base64Image.isNotEmpty
                          ? MemoryImage(base64Decode(_base64Image))
                          : null,
                      child: _base64Image.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.green,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            _buildTextField(
              'Nama Lengkap',
              _fullNameCtrl,
              Icons.badge_outlined,
              hintText: 'Masukkan nama lengkap',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Nama Panggilan',
              _nicknameCtrl,
              Icons.person_outline,
              hintText: 'Masukkan nama panggilan',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Bio',
              _bioCtrl,
              Icons.info_outline,
              hintText: 'Ceritakan sedikit tentang dirimu...',
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // MEMANGGIL WIDGET INPUT HOBI CUSTOM
            _buildHobbyInput(),

            const SizedBox(height: 16),

            const Text(
              'Video Profil (Maks 10MB)',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                    _currentVideoPath.isNotEmpty
                        ? Icons.video_library
                        : Icons.video_call_outlined,
                    color: _currentVideoPath.isNotEmpty
                        ? Colors.green
                        : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _currentVideoPath.isNotEmpty
                          ? 'Video telah dipilih'
                          : 'Belum ada video',
                      style: TextStyle(
                        color: _currentVideoPath.isNotEmpty
                            ? Colors.black87
                            : Colors.grey,
                      ),
                    ),
                  ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _currentVideoPath.isNotEmpty ? 'Ganti' : 'Pilih',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              'Email (Terikat dengan Akun)',
              _emailCtrl,
              Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
              hintText: 'contoh@email.com',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'No. HP',
              _phoneCtrl,
              Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              hintText: '081234567890',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Tanggal Lahir',
              _birthDateCtrl,
              Icons.calendar_today_outlined,
              readOnly: true,
              hintText: 'Pilih tanggal lahir',
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),

            const Text(
              'Jenis Kelamin',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.people_outline,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green),
                ),
              ),
              items: ['Laki-laki', 'Perempuan']
                  .map(
                    (String val) =>
                        DropdownMenuItem(value: val, child: Text(val)),
                  )
                  .toList(),
              onChanged: (newValue) =>
                  setState(() => _selectedGender = newValue!),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                    color: Colors.white,
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

  // WIDGET CUSTOM UNTUK INPUT HOBI SEBAGAI CHIPS
  Widget _buildHobbyInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hobi',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tempat Chip / Card Kecil muncul
              if (_hobbiesList.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _hobbiesList.map((hobby) {
                    return InputChip(
                      label: Text(
                        hobby,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                        ),
                      ),
                      backgroundColor: Colors.green.shade50,
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.green,
                      ),
                      onDeleted: () {
                        setState(() {
                          _hobbiesList.remove(hobby);
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide.none,
                    );
                  }).toList(),
                ),
              if (_hobbiesList.isNotEmpty) const SizedBox(height: 8),

              // Input textnya sendiri
              Row(
                children: [
                  const Icon(Icons.favorite_border, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _hobbyCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Ketik hobi, tekan Koma (,) atau Enter',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      // Tambahkan jika user tekan enter di keyboard
                      onSubmitted: (value) {
                        _addHobby(value);
                      },
                      // Menangkap jika user ngetik koma, otomatis jadi tag
                      onChanged: (value) {
                        if (value.endsWith(',')) {
                          _addHobby(value.substring(0, value.length - 1));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    String? hintText,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: maxLines > 1
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Icon(icon, color: Colors.grey),
                  )
                : Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: readOnly && onTap == null
                ? Colors.grey.shade100
                : Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }
}
