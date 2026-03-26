import 'package:flutter/material.dart';
import 'dart:convert'; // Wajib untuk decode gambar Base64 dari database
import '../../core/constants/app_colors.dart';
import '../../../models/profile_model.dart';
import '../../../core/database/database_helper.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// 1. STATE MANAGER (Pengatur Kondisi Layar)
class _ProfileScreenState extends State<ProfileScreen> {
  // Variabel untuk menyimpan data profil dari database.
  // Bisa bernilai null (?) karena kita harus nunggu proses ambil data selesai.
  ProfileModel? _profile;
  
  // Indikator loading. Selama nilainya 'true', layar akan menampilkan animasi muter.
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Saat layar pertama kali dibuka, langsung suruh sistem tarik data.
    _loadProfile();
  }

  // 2. DATA FETCHER (Si Penarik Data)
  // Fungsi asynchronous (berjalan di background) untuk meminta data ke SQLite.
  Future<void> _loadProfile() async {
    setState(() => _isLoading = true); // Nyalakan loading
    
    // Minta data ke "gudang" (DatabaseHelper)
    final data = await DatabaseHelper.instance.getProfile();
    
    setState(() {
      _profile = data; // Simpan datanya ke variabel _profile
      _isLoading = false; // Matikan loading karena data sudah siap
    });
  }

  // 3. UI BUILDER (Pembangun Tampilan)
  @override
  Widget build(BuildContext context) {
    // Kalau masih narik data, cegah UI tampil dan kasih animasi loading
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)));
    }

    // Kalau data sudah siap, bangun struktur layarnya
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profil Saya', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      // SingleChildScrollView bikin layar bisa di-scroll kalau HP-nya kecil
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            
            // --- BAGIAN A: FOTO PROFIL ---
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryGreen, width: 2), // Bingkai hijau estetik
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
                  // Pengecekan aman: Kalau ada teks Base64 di database, terjemahkan jadi gambar. Kalau kosong, beri nilai null.
                  backgroundImage: (_profile?.profilePicture ?? '').isNotEmpty 
                      ? MemoryImage(base64Decode(_profile!.profilePicture)) 
                      : null,
                  // Kalau nilainya null (ga ada foto), tampilkan ikon orang.
                  child: (_profile?.profilePicture ?? '').isEmpty 
                      ? const Icon(Icons.person, size: 50, color: AppColors.primaryGreen) 
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // --- BAGIAN B: HEADER NAMA & BIO ---
            Text(
              _profile?.nickname ?? 'Pengguna', // Ambil nama panggilan
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _profile?.bio ?? '-', // Ambil deskripsi diri
                style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // --- BAGIAN C: KOTAK INFORMASI DETAIL ---
            // Dibungkus Container putih biar mirip "Kartu"
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                children: [
                  // Manggil fungsi bantuan _buildProfileItem biar kode nggak kepanjangan
                  _buildProfileItem(Icons.favorite_border, 'Hobi', _profile?.hobby ?? '-'),
                  const Divider(height: 24), // Garis pemisah abu-abu
                  
                  _buildProfileItem(Icons.email_outlined, 'Email', _profile?.email ?? '-'),
                  const Divider(height: 24),
                  
                  _buildProfileItem(Icons.phone_outlined, 'Nomor Telepon', _profile?.phoneNumber ?? '-'),
                  const Divider(height: 24),
                  
                  _buildProfileItem(Icons.people_outline, 'Jenis Kelamin', _profile?.gender ?? '-'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- BAGIAN D: TOMBOL EDIT ---
            SizedBox(
              width: double.infinity, // Bikin tombol selebar layar
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // Pindah ke layar Edit dan "menunggu" hasilnya (await)
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfileScreen(profile: _profile!)),
                  );
                  // Kalau user menekan "Simpan" (result = true), langsung panggil _loadProfile()
                  // Ini bikin layarnya otomatis update tanpa perlu ditutup dulu.
                  if (result == true) _loadProfile();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Edit Profil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. WIDGET HELPER (Pembuat Komponen Berulang)
  // Fungsi ini bikin kita nggak perlu nulis ulang struktur UI (Icon + Text + Text) berkali-kali.
  // Cukup masukin Icon-nya apa, Judulnya apa, isinya apa.
  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.lightGreenBg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.primaryGreen, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 4),
              // Kasih ketebalan (fontWeight) di bagian value (isi) biar lebih menonjol dari judulnya
              Text(value, style: const TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}