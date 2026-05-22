import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/database/database_helper.dart';
import '../../models/user_model.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final TextEditingController _teamNameCtrl = TextEditingController();
  final TextEditingController _searchCtrl = TextEditingController();
  List<UserModel> _allUsers = [];
  List<String> _selectedEmails = [];
  List<UserModel> _searchResults = [];

  Map<String, dynamic> _userProfiles = {};
  bool _isLoading = true;

  // --- VARIABEL UNTUK MENYIMPAN FOTO TIM ---
  String _teamImageBase64 = '';

  final List<Color> _accentColors = [
    const Color(0xFF9333EA),
    const Color(0xFF0EA5E9),
    const Color(0xFFF97316),
    const Color(0xFF22C55E),
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
    _fetchUsersWithPhotos();
  }

  Future<void> _fetchUsersWithPhotos() async {
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
        _userProfiles = profilesData;
        _isLoading = false;
      });
    }
  }

  List<UserModel> _getSearchResults(String query) {
    if (query.isEmpty) return [];
    return _allUsers
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // --- FUNGSI UNTUK MENGAMBIL GAMBAR DARI GALERI ---
  Future<void> _pickTeamImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Kompres ukuran gambar
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _teamImageBase64 = base64Encode(bytes);
      });
    }
  }

  Future<void> _saveTeam() async {
    final teamName = _teamNameCtrl.text.trim();
    if (teamName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama tim tidak boleh kosong!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedEmails.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu anggota!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final myEmail = prefs.getString('userEmail') ?? '';

    int groupId = await DatabaseHelper.instance.createGroup(
      teamName,
      myEmail,
      groupImage: _teamImageBase64,
    );

    if (myEmail.isNotEmpty) {
      await DatabaseHelper.instance.addMemberToGroup(groupId, myEmail);
    }

    for (String email in _selectedEmails) {
      await DatabaseHelper.instance.addMemberToGroup(groupId, email);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tim berhasil dibuat!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Buat Tim Baru',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- BAGIAN UPLOAD FOTO TIM (Tengah Atas) ---
                  Center(
                    child: GestureDetector(
                      onTap: _pickTeamImage,
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.green.shade200,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: _teamImageBase64.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(_teamImageBase64),
                                      fit: BoxFit.cover,
                                    )
                                  : const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo,
                                          color: Colors.green,
                                          size: 28,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Foto Tim',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          // Ikon kecil pensil edit di pojok
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.green.shade200,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 14,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- INPUT NAMA TIM ---
                  TextField(
                    controller: _teamNameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Nama Tim',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.group_work,
                        color: Colors.green,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Pilih Anggota:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  // --- PENCARIAN ANGGOTA ---
                  TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      labelText: 'Cari Nama Anggota',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchResults = _getSearchResults(value);
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- DAFTAR HASIL PENCARIAN ---
                        if (_searchResults.isNotEmpty) ...[
                          const Text(
                            'Hasil Pencarian:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final user = _searchResults[index];
                                return _buildUserCard(
                                  user: user,
                                  index: index,
                                  isSearchResult: true,
                                );
                              },
                            ),
                          ),
                        ] else if (_searchCtrl.text.isNotEmpty) ...[
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text('Tidak ada hasil pencarian.'),
                            ),
                          ),
                        ],

                        // --- DAFTAR ANGGOTA TERPILIH ---
                        if (_selectedEmails.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Anggota Terpilih:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: _selectedEmails.length,
                              itemBuilder: (context, index) {
                                final email = _selectedEmails[index];
                                final user = _allUsers.firstWhere(
                                  (u) => u.email == email,
                                );
                                return _buildUserCard(
                                  user: user,
                                  index: index,
                                  isSearchResult: false,
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // TOMBOL SIMPAN TIM
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _saveTeam,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Simpan Tim',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // WIDGET CARD CUSTOM
  Widget _buildUserCard({
    required UserModel user,
    required int index,
    required bool isSearchResult,
  }) {
    final profile = _userProfiles[user.email];
    final isSelected = _selectedEmails.contains(user.email);

    String base64Image = profile?.profilePicture ?? '';
    String bio = profile?.bio ?? 'Belum ada bio';
    String hobbyStr = profile?.hobby ?? '';
    String gender = profile?.gender ?? '';

    List<String> hobbies = hobbyStr
        .split(',')
        .where((h) => h.trim().isNotEmpty)
        .toList();
    String initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    Color cardAccent = _accentColors[index % _accentColors.length];
    IconData badgeIcon = _badgeIcons[index % _badgeIcons.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isSearchResult ? Colors.white : Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSearchResult ? Colors.grey.shade100 : Colors.green.shade200,
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

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
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
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (gender.isNotEmpty)
                          _buildChip(gender, Icons.person_outline),
                        ...hobbies
                            .take(2)
                            .map(
                              (h) => _buildChip(h.trim(), Icons.star_border),
                            ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              isSearchResult
                  ? SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: isSelected
                            ? null
                            : () {
                                setState(() {
                                  _selectedEmails.add(user.email);
                                  _searchCtrl.clear();
                                  _searchResults.clear();
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.grey.shade300
                              : Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isSelected ? '✓' : 'Tambah',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: () =>
                          setState(() => _selectedEmails.remove(user.email)),
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.redAccent,
                        size: 24,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String text, IconData icon) {
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
          Icon(icon, size: 10, color: Colors.green),
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
