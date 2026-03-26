import 'package:flutter/material.dart';
import 'dart:convert'; // Wajib untuk menerjemahkan teks Base64 jadi gambar
import '../../../core/constants/app_colors.dart';
import '../../../models/profile_model.dart';
import '../../../core/database/database_helper.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  // Variabel penampung data profil dari database
  ProfileModel? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile(); // Tarik data saat widget pertama kali muncul
  }

  // 1. DATA FETCHER (Sinkronisasi Database)
  Future<void> _loadProfile() async {
    final data = await DatabaseHelper.instance.getProfile();
    // 'mounted' memastikan kita nggak update tampilan kalau usernya udah pindah halaman
    if (mounted) {
      setState(() {
        _profile = data;
      });
    }
  }

  // 2. TIME-BASED LOGIC (Sapaan Otomatis)
  // Fungsi ini membaca jam internal HP untuk menentukan sapaan yang pas
  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi,';
    if (hour < 15) return 'Selamat Siang,';
    if (hour < 18) return 'Selamat Sore,';
    return 'Selamat Malam,';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // --- BAGIAN 1: FOTO PROFIL KECIL ---
        Container(
          padding: const EdgeInsets.all(2), 
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryGreen, width: 2), // Ring hijau indikator profil
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
            // Jika ada foto di database, tampilkan. Jika tidak, tetap null.
            backgroundImage: (_profile?.profilePicture ?? '').isNotEmpty
                ? MemoryImage(base64Decode(_profile!.profilePicture))
                : null,
            // Ikon default muncul jika foto di database kosong
            child: (_profile?.profilePicture ?? '').isEmpty
                ? const Icon(Icons.person, size: 24, color: AppColors.primaryGreen)
                : null,
          ),
        ),
        const SizedBox(width: 12),
        
        // --- BAGIAN 2: INFORMASI PENGGUNA ---
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(), // Memanggil sapaan dinamis (Pagi/Siang/Sore)
                style: const TextStyle(color: AppColors.textGrey, fontSize: 14)
              ),
              Text(
                _profile?.nickname ?? 'Memuat...', // Menampilkan nama panggilan
                style: const TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1, 
                overflow: TextOverflow.ellipsis, // Jika nama kepanjangan, dipotong dengan titik-titik (...)
              ),
            ],
          ),
        ),
        
        // --- BAGIAN 3: AKSES NOTIFIKASI ---
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white, 
            shape: BoxShape.circle, 
            border: Border.all(color: Colors.grey.shade200)
          ),
          child: const Icon(Icons.notifications_none, color: AppColors.textDark),
        ),
      ],
    );
  }
}