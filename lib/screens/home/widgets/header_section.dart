import 'package:flutter/material.dart';
import 'dart:convert'; // Wajib untuk menerjemahkan teks Base64 jadi gambar
import 'package:shared_preferences/shared_preferences.dart'; // Wajib ditambahkan untuk mengambil email login

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

  // 1. DATA FETCHER (Sinkronisasi Database Berdasarkan Akun)
  Future<void> _loadProfile() async {
    // Ambil email user yang sedang login dari memori lokal
    final prefs = await SharedPreferences.getInstance();
    final currentUserEmail = prefs.getString('userEmail') ?? '';

    // Minta data profil khusus untuk email tersebut (Perbaikan Error ada di sini)
    final data = await DatabaseHelper.instance.getProfile(currentUserEmail);
    
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
            // Ring hijau indikator profil (Pastikan AppColors.primaryGreen ada di file Anda)
            border: Border.all(color: Colors.green, width: 2), 
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.green.withOpacity(0.2),
            // Jika ada foto di database, tampilkan. Jika tidak, tetap null.
            backgroundImage: (_profile?.profilePicture ?? '').isNotEmpty
                ? MemoryImage(base64Decode(_profile!.profilePicture))
                : null,
            // Ikon default muncul jika foto di database kosong
            child: (_profile?.profilePicture ?? '').isEmpty
                ? const Icon(Icons.person, size: 24, color: Colors.green)
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
                style: const TextStyle(color: Colors.grey, fontSize: 14)
              ),
              Text(
                _profile?.nickname ?? 'Memuat...', // Menampilkan nama panggilan
                style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
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
          child: const Icon(Icons.notifications_none, color: Colors.black87),
        ),
      ],
    );
  }
}