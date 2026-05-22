import 'package:flutter/material.dart';
import 'dart:convert';
import '../../core/database/database_helper.dart';
import '../../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_team_screen.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  List<UserModel> _allUsers = [];
  List<UserModel> _displayedUsers = [];
  Map<String, dynamic> _userProfiles = {};
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  // Warna aksen tetap dipertahankan untuk membedakan tiap kartu
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
    _fetchRealUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRealUsers() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final myEmail = prefs.getString('userEmail') ?? '';

    final users = await DatabaseHelper.instance.getAllUsers(myEmail);

    Map<String, dynamic> profilesData = {};
    for (var user in users) {
      final profile = await DatabaseHelper.instance.getProfile(user.email);
      profilesData[user.email] = profile;
    }

    if (mounted) {
      setState(() {
        _allUsers = users;
        _displayedUsers = users;
        _userProfiles = profilesData;
        _isLoading = false;
      });
    }
  }

  void _runFilter(String enteredKeyword) {
    List<UserModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allUsers;
    } else {
      results = _allUsers
          .where(
            (user) =>
                user.name.toLowerCase().contains(enteredKeyword.toLowerCase()),
          )
          .toList();
    }

    setState(() {
      _displayedUsers = results;
    });
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
          'People',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- HEADER & SEARCH ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => _runFilter(value),
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Cari nama pengguna...',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateTeamScreen(),
                      ),
                    ).then((_) => _fetchRealUsers());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '+ Create Team',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- LIST CARD USERS ---
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    )
                  : _displayedUsers.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _displayedUsers.length,
                      itemBuilder: (context, index) {
                        final user = _displayedUsers[index];
                        final profile = _userProfiles[user.email];

                        String base64Image = profile?.profilePicture ?? '';
                        String bio = profile?.bio ?? 'Belum ada bio';
                        String hobbyStr = profile?.hobby ?? '';
                        String gender = profile?.gender ?? '';

                        // Pisahkan hobi jika dipisahkan dengan koma
                        List<String> hobbies = hobbyStr
                            .split(',')
                            .where((h) => h.trim().isNotEmpty)
                            .toList();
                        String initial = user.name.isNotEmpty
                            ? user.name[0].toUpperCase()
                            : '?';

                        // Ambil warna dan ikon sesuai urutan index
                        Color cardAccent =
                            _accentColors[index % _accentColors.length];
                        IconData badgeIcon =
                            _badgeIcons[index % _badgeIcons.length];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade100,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // AVATAR DENGAN BADGE KECIL
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 32,
                                      backgroundColor: cardAccent.withOpacity(
                                        0.1,
                                      ),
                                      backgroundImage: base64Image.isNotEmpty
                                          ? MemoryImage(
                                              base64Decode(base64Image),
                                            )
                                          : null,
                                      child: base64Image.isEmpty
                                          ? Text(
                                              initial,
                                              style: TextStyle(
                                                color: cardAccent,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                              ),
                                            )
                                          : null,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: cardAccent,
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          badgeIcon,
                                          size: 12,
                                          color: cardAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),

                                // TEKS DETAIL
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // NAMA
                                      Text(
                                        user.name,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),

                                      // BIO
                                      Text(
                                        bio,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),

                                      // TAGS (GENDER & HOBBY)
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          if (gender.isNotEmpty)
                                            _buildChip(
                                              gender,
                                              Icons.person_outline,
                                            ),
                                          ...hobbies.map(
                                            (h) => _buildChip(
                                              h.trim(),
                                              Icons.star_border,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // CHEVRON KANAN
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'Tidak ada pengguna yang ditemukan.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET BANTUAN UNTUK MEMBUAT CHIP/TAG KECIL TEMA TERANG
  Widget _buildChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade500),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
