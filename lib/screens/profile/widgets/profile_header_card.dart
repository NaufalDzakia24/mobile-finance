import 'package:flutter/material.dart';
import 'dart:convert'; // Wajib buat decode Base64 agar teks bisa jadi gambar
import '../../../core/constants/app_colors.dart';
import '../edit_profile_screen.dart';
import '../../../models/profile_model.dart'; 

class ProfileHeaderCard extends StatelessWidget {
  // Data profil yang diterima dari parent widget
  final ProfileModel? profile; 
  
  // Callback: Fungsi "titipan" yang akan dijalankan ketika data berhasil di-update
  final VoidCallback onEditSuccess; 

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    required this.onEditSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // --- 1. FOTO PROFIL DINAMIS ---
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryGreen, width: 2),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
              // Decode String Base64 dari database kembali menjadi file gambar (MemoryImage)
              backgroundImage: (profile?.profilePicture ?? '').isNotEmpty 
                  ? MemoryImage(base64Decode(profile!.profilePicture)) 
                  : null,
              // Fallback: Jika foto kosong, tampilkan icon user default
              child: (profile?.profilePicture ?? '').isEmpty 
                  ? const Icon(Icons.person, size: 40, color: AppColors.primaryGreen) 
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          
          // --- 2. INFORMASI UTAMA ---
          Text(
            profile?.fullName ?? 'Memuat...', // Tampilkan nama lengkap
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          
          Text(
            profile?.email ?? 'Memuat...', // Tampilkan email
            style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // --- 3. TOMBOL EDIT QUICK-ACTION ---
          SizedBox(
            height: 36,
            child: ElevatedButton.icon(
              // Tombol akan mati (disabled) jika data profil belum berhasil dimuat
              onPressed: profile == null
                  ? null
                  : () async {
                      // Berpindah ke layar edit sambil mengirim data profil saat ini
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(profile: profile!),
                        ),
                      );

                      // Jika dari layar edit mengirim balik nilai 'true' (artinya simpan berhasil)
                      // Maka jalankan fungsi onEditSuccess untuk me-refresh data di layar utama
                      if (result == true) {
                        onEditSuccess(); 
                      }
                    },
              icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.white),
              label: const Text('Edit', style: TextStyle(fontSize: 12, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}