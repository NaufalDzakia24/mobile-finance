import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/database/database_helper.dart';
import '../../models/user_model.dart';

class TeamDetailScreen extends StatefulWidget {
  final int groupId;
  final String teamName;

  const TeamDetailScreen({
    super.key,
    required this.groupId,
    required this.teamName,
  });

  @override
  State<TeamDetailScreen> createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  List<UserModel> _members = [];
  String _myEmail = '';
  bool _isLoading = true;

  // Map untuk menyimpan objek profil agar bisa menampilkan Bio & Hobi
  Map<String, dynamic> _userProfiles = {};

  // Warna dan ikon aksen agar seragam dengan screen lainnya
  final List<Color> _accentColors = [
    const Color(0xFF9333EA), // Ungu
    const Color(0xFF0EA5E9), // Biru
    const Color(0xFFF97316), // Oranye
    const Color(0xFF22C55E), // Hijau
  ];

  final List<IconData> _badgeIcons = [
    Icons.flash_on,
    Icons.local_fire_department,
    Icons.lightbulb_outline,
    Icons.star,
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    _myEmail = prefs.getString('userEmail') ?? '';

    // Ambil list anggotanya
    final members = await DatabaseHelper.instance.getGroupMembers(
      widget.groupId,
    );

    // Ambil data profil untuk setiap anggota
    Map<String, dynamic> profilesData = {};
    for (var user in members) {
      final profile = await DatabaseHelper.instance.getProfile(user.email);
      profilesData[user.email] = profile;
    }

    if (mounted) {
      setState(() {
        _members = members;
        _userProfiles = profilesData;
        _isLoading = false;
      });
    }
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
        title: Text(
          widget.teamName,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daftar Anggota',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_members.length} Anggota',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _members.isEmpty
                      ? const Center(child: Text('Belum ada anggota.'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _members.length,
                          itemBuilder: (context, index) {
                            final user = _members[index];
                            final bool isMe = user.email == _myEmail;

                            // Bangun Card yang konsisten
                            return _buildUserCard(user, index, isMe);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  // WIDGET CARD CUSTOM YANG RAPI DAN KONSISTEN
  Widget _buildUserCard(UserModel user, int index, bool isMe) {
    final profile = _userProfiles[user.email];

    // Ekstrak Data
    String base64Image = profile?.profilePicture ?? '';
    String bio = profile?.bio ?? 'Belum ada bio';
    String hobbyStr = profile?.hobby ?? '';
    String gender = profile?.gender ?? '';

    List<String> hobbies = hobbyStr
        .split(',')
        .where((h) => h.trim().isNotEmpty)
        .toList();
    String initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    // Logika warna: Jika 'Saya', gunakan biru. Jika orang lain, gunakan aksen rotasi.
    Color cardAccent = isMe
        ? Colors.blue
        : _accentColors[index % _accentColors.length];
    IconData badgeIcon = isMe
        ? Icons.verified_user
        : _badgeIcons[index % _badgeIcons.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isMe
            ? Colors.blue.shade50
            : Colors.white, // Highlight kartu sendiri
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isMe ? Colors.blue.shade200 : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BAGIAN AVATAR
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: cardAccent.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: cardAccent.withOpacity(0.1),
                      backgroundImage: base64Image.isNotEmpty
                          ? MemoryImage(base64Decode(base64Image))
                          : null,
                      child: base64Image.isEmpty
                          ? Text(
                              initial,
                              style: TextStyle(
                                color: cardAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                        border: Border.all(color: cardAccent, width: 1.5),
                      ),
                      child: Icon(badgeIcon, size: 10, color: cardAccent),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // 2. BAGIAN TENGAH (NAMA, BIO, CHIPS)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        // Lencana "SAYA"
                        if (isMe)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'SAYA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bio,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // TAGS
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (gender.isNotEmpty)
                          _buildChip(gender, Icons.person_outline, cardAccent),
                        ...hobbies
                            .take(2)
                            .map(
                              (h) => _buildChip(
                                h.trim(),
                                Icons.star_border,
                                cardAccent,
                              ),
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String text, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: iconColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
