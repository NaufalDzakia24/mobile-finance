import 'dart:io'; // Untuk membaca file video dari penyimpanan lokal
import 'package:flutter/material.dart';
import 'dart:convert'; // Wajib untuk decode gambar Base64 dari database
import 'package:video_player/video_player.dart'; // Library untuk memutar video

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
  Future<void> _loadProfile() async {
    setState(() => _isLoading = true); 
    
    // Minta data ke "gudang" (DatabaseHelper)
    final data = await DatabaseHelper.instance.getProfile();
    
    setState(() {
      _profile = data; 
      _isLoading = false; 
    });
  }

  // 3. UI BUILDER (Pembangun Tampilan)
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profil Saya', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
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
                  border: Border.all(color: AppColors.primaryGreen, width: 2), 
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
                  backgroundImage: (_profile?.profilePicture ?? '').isNotEmpty 
                      ? MemoryImage(base64Decode(_profile!.profilePicture)) 
                      : null,
                  child: (_profile?.profilePicture ?? '').isEmpty 
                      ? const Icon(Icons.person, size: 50, color: AppColors.primaryGreen) 
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // --- BAGIAN B: HEADER NAMA & BIO ---
            Text(
              _profile?.nickname ?? 'Pengguna', 
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _profile?.bio ?? '-', 
                style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // --- BAGIAN C: VIDEO PROFIL (BARU) ---
            // Hanya tampilkan pemutar video JIKA path videonya tidak kosong
            if ((_profile?.videoPath ?? '').isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Video Profil', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 12),
              // Memanggil Widget Pemutar Video buatan kita sendiri (ada di bawah)
              VideoProfileWidget(videoPath: _profile!.videoPath),
              const SizedBox(height: 24),
            ],

            // --- BAGIAN D: KOTAK INFORMASI DETAIL ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                children: [
                  _buildProfileItem(Icons.favorite_border, 'Hobi', _profile?.hobby ?? '-'),
                  const Divider(height: 24), 
                  
                  _buildProfileItem(Icons.email_outlined, 'Email', _profile?.email ?? '-'),
                  const Divider(height: 24),
                  
                  _buildProfileItem(Icons.phone_outlined, 'Nomor Telepon', _profile?.phoneNumber ?? '-'),
                  const Divider(height: 24),
                  
                  _buildProfileItem(Icons.people_outline, 'Jenis Kelamin', _profile?.gender ?? '-'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- BAGIAN E: TOMBOL EDIT ---
            SizedBox(
              width: double.infinity, 
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfileScreen(profile: _profile!)),
                  );
                  // Refresh data otomatis jika user menekan tombol simpan
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

  // 4. WIDGET HELPER
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
              Text(value, style: const TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// WIDGET KHUSUS: PEMUTAR VIDEO PROFIL
// ============================================================================
// Dipisahkan agar tidak membuat layar utama lag (patah-patah) saat video dimuat.
// ============================================================================
// WIDGET KHUSUS: PEMUTAR VIDEO PROFIL (REVISI: UI FIX & PLAYBACK SPEED)
// ============================================================================
// ============================================================================
// WIDGET KHUSUS: PEMUTAR VIDEO PROFIL (REVISI: FULL COVER TANPA GARIS HITAM)
// ============================================================================
class VideoProfileWidget extends StatefulWidget {
  final String videoPath;
  const VideoProfileWidget({super.key, required this.videoPath});

  @override
  State<VideoProfileWidget> createState() => _VideoProfileWidgetState();
}

class _VideoProfileWidgetState extends State<VideoProfileWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  double _playbackSpeed = 1.0; 

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true; 
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.5;
      } else if (_playbackSpeed == 1.5) {
        _playbackSpeed = 2.0;
      } else {
        _playbackSpeed = 1.0;
      }
      _controller.setPlaybackSpeed(_playbackSpeed);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        height: 250, 
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
        child: const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: Colors.black, // Background hitam tidak akan terlihat lagi karena tertutup full
        height: 250, 
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Layar Video (REVISI UTAMA: Dibuat Full Cover)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover, // Kunci utama agar video Zoom dan memenuhi kotak
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            
            // 2. Bar Progres di bawah video
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: VideoProgressIndicator(_controller, allowScrubbing: true, colors: const VideoProgressColors(playedColor: AppColors.primaryGreen)),
            ),

            // 3. Tombol Play/Pause Overlay di tengah
            GestureDetector(
              onTap: () {
                setState(() {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.1), 
                child: Center(
                  child: Icon(
                    _controller.value.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                    color: Colors.white.withOpacity(0.8),
                    size: 60,
                  ),
                ),
              ),
            ),

            // 4. Tombol Pengatur Kecepatan (Speed)
            Positioned(
              top: 12,
              right: 12,
              child: InkWell(
                onTap: _toggleSpeed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white54, width: 1),
                  ),
                  child: Text(
                    '${_playbackSpeed}x', 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}