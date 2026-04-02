import 'package:flutter/material.dart';
import 'dart:ui';
import 'team_data.dart';

// ═══════════════════════════════════════════
//  PROFILE SCREEN (TEAM LIST)
// ═══════════════════════════════════════════
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key); // ✅ FIX: tambah ( sebelum {

  static const Color _bg = Color(0xFF0A0A12);
  static const Color _accent1 = Color(0xFF7C5CFC);
  static const Color _accent2 = Color(0xFF4F8EF7);
  static const Color _accent3 = Color(0xFFE040FB);
  static const Color _textPrimary = Color(0xFFF0F0FF);
  static const Color _textSecondary = Color(0xFF8888AA);
  static const Color _border = Color(0xFF2A2A45);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          Positioned(top: -80, right: -60, child: _glowOrb(_accent1, 220)),
          Positioned(top: 180, left: -80, child: _glowOrb(_accent2, 180)),
          Positioned(bottom: 200, right: -40, child: _glowOrb(_accent3, 160)),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildStatsRow(),
                const SizedBox(height: 20),
                Expanded(child: _buildList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: size,
            spreadRadius: size * 0.4,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [_accent1, _accent2],
                ).createShader(bounds),
                child: const Text(
                  'TEAM',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Directory',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: _textPrimary,
                  letterSpacing: -1.5,
                  height: 1,
                ),
              ),
              const Text(
                'Class of 2024',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: _textSecondary,
                  letterSpacing: -1.5,
                  height: 1.1,
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _border, width: 1),
                ),
                child: const Icon(Icons.search_rounded, color: _textPrimary, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _statChip('${teamMembers.length}', 'Members', _accent1),
          const SizedBox(width: 10),
          _statChip('4', 'Depts', _accent2),
          const SizedBox(width: 10),
          _statChip('2024', 'Batch', _accent3),
        ],
      ),
    );
  }

  Widget _statChip(String val, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              val,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: _textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: teamMembers.length,
      itemBuilder: (context, i) {
        return _TeamCard(member: teamMembers[i], index: i);
      },
    );
  }
}

// ═══════════════════════════════════════════
//  TEAM CARD WIDGET
// ═══════════════════════════════════════════
class _TeamCard extends StatefulWidget {
  final TeamMember member;
  final int index;
  const _TeamCard({required this.member, required this.index});

  @override
  State<_TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<_TeamCard> {
  bool _pressed = false;

  static const Color _cardBg = Color(0xFF14142A);
  static const Color _border = Color(0xFF2A2A45);
  static const Color _textPrimary = Color(0xFFF0F0FF);
  static const Color _textSecondary = Color(0xFF8888AA);

  final List<Color> _palette = const [
    Color(0xFF7C5CFC),
    Color(0xFF4F8EF7),
    Color(0xFFE040FB),
    Color(0xFF00D4AA),
    Color(0xFFF7764F),
    Color(0xFF4FF7C8),
  ];

  @override
  Widget build(BuildContext context) {
    final accent = _palette[widget.index % _palette.length];

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, anim, __) =>
                ProfileDetailPage(member: widget.member),
            transitionsBuilder: (_, anim, __, child) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                child: child,
              ),
            ),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _border, width: 1),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Positioned(
                  top: 0, left: 0, right: 0, height: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent.withOpacity(0.8), accent.withOpacity(0)],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2.5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [accent, accent.withOpacity(0.4)],
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xFF0A0A12),
                              child: CircleAvatar(
                                radius: 27,
                                backgroundImage: NetworkImage(widget.member.imageUrl),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              width: 20, height: 20,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0A0A12),
                                shape: BoxShape.circle,
                                border: Border.all(color: _border, width: 1.5),
                              ),
                              child: Center(
                                child: Text(widget.member.emoji,
                                    style: const TextStyle(fontSize: 10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.member.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: _textPrimary,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: accent.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    widget.member.batch,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: accent,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              widget.member.role,
                              style: TextStyle(
                                fontSize: 12,
                                color: accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.member.major,
                              style: const TextStyle(
                                fontSize: 12,
                                color: _textSecondary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: widget.member.hobbies.take(3).map((h) =>
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: _border, width: 1),
                                  ),
                                  child: Text(
                                    h,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: _textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right_rounded, color: accent, size: 22),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  PROFILE DETAIL PAGE
// ═══════════════════════════════════════════
class ProfileDetailPage extends StatefulWidget {
  final TeamMember member;
  const ProfileDetailPage({Key? key, required this.member}) : super(key: key);

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  static const Color _bg = Color(0xFF0A0A12);
  static const Color _border = Color(0xFF2A2A45);
  static const Color _textPrimary = Color(0xFFF0F0FF);
  static const Color _textSecondary = Color(0xFF8888AA);

  final List<List<Color>> _gradients = const [
    [Color(0xFF7C5CFC), Color(0xFF4F8EF7)],
    [Color(0xFFE040FB), Color(0xFF7C5CFC)],
    [Color(0xFF4F8EF7), Color(0xFF00D4AA)],
    [Color(0xFF00D4AA), Color(0xFF4FF7C8)],
    [Color(0xFFF7764F), Color(0xFFE040FB)],
    [Color(0xFF4FF7C8), Color(0xFF4F8EF7)],
  ];

  List<Color> get _gradient =>
      _gradients[widget.member.name.length % _gradients.length];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          Positioned(
            top: -60, left: 0, right: 0,
            child: Center(
              child: Container(
                width: 300, height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _gradient[0].withOpacity(0.2),
                      blurRadius: 120,
                      spreadRadius: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                _buildProfileHeader(),
                const SizedBox(height: 20),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tab,
                    children: [
                      _buildInfoTab(),
                      _buildHobbiesTab(),
                      _buildVideoTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          _circleBtn(Icons.arrow_back_ios_new_rounded, () => Navigator.pop(context)),
          const Spacer(),
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: _textPrimary,
            ),
          ),
          const Spacer(),
          _circleBtn(Icons.ios_share_rounded, () {}),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border, width: 1),
            ),
            child: Icon(icon, color: _textPrimary, size: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: _gradient),
          ),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: _bg),
            child: CircleAvatar(
              radius: 52,
              backgroundImage: NetworkImage(widget.member.imageUrl),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.member.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              widget.member.name,
              style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.w900,
                color: _textPrimary, letterSpacing: -0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ShaderMask(
          shaderCallback: (b) => LinearGradient(colors: _gradient).createShader(b),
          child: Text(
            widget.member.role,
            style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700,
              color: Colors.white, letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(widget.member.major,
            style: const TextStyle(fontSize: 13, color: _textSecondary)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _actionBtn(Icons.email_outlined, 'Email', _gradient[0]),
            const SizedBox(width: 10),
            _actionBtn(Icons.chat_bubble_outline_rounded, 'Chat', _gradient[1]),
            const SizedBox(width: 10),
            _actionBtn(Icons.phone_outlined, 'Call', const Color(0xFF00D4AA)),
          ],
        ),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      color: color, fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border, width: 1),
            ),
            child: TabBar(
              controller: _tab,
              indicator: BoxDecoration(
                gradient: LinearGradient(colors: _gradient),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _gradient[0].withOpacity(0.4),
                    blurRadius: 12, offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: _textSecondary,
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: const [
                Tab(text: 'Info'),
                Tab(text: 'Hobbies'),
                Tab(text: 'Video'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    const Color cardBg = Color(0xFF14142A);
    const Color border = Color(0xFF2A2A45);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (b) =>
                      LinearGradient(colors: _gradient).createShader(b),
                  child: const Text(
                    'ABOUT',
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w800,
                      color: Colors.white, letterSpacing: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.member.bio,
                  style: const TextStyle(
                    fontSize: 14, color: _textSecondary, height: 1.7,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.email_outlined, 'Email', widget.member.email),
          const SizedBox(height: 10),
          _infoRow(Icons.school_outlined, 'Major', widget.member.major),
          const SizedBox(height: 10),
          _infoRow(Icons.badge_outlined, 'Batch', widget.member.batch),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    const Color cardBg = Color(0xFF14142A);
    const Color border = Color(0xFF2A2A45);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                _gradient[0].withOpacity(0.2),
                _gradient[1].withOpacity(0.1),
              ]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _gradient[0], size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: _textSecondary,
                        fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, color: _textPrimary,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHobbiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (b) =>
                LinearGradient(colors: _gradient).createShader(b),
            child: const Text(
              'INTERESTS',
              style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w800,
                color: Colors.white, letterSpacing: 3,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.member.hobbies.asMap().entries.map((e) {
              final color = e.key % 2 == 0 ? _gradient[0] : _gradient[1];
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: color.withOpacity(0.3), width: 1),
                    ),
                    child: Text(
                      e.value,
                      style: TextStyle(
                        fontSize: 14, color: color, fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _gradient[0].withOpacity(0.12),
                      _gradient[1].withOpacity(0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: _gradient[0].withOpacity(0.25), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(widget.member.emoji,
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        const Text(
                          'Fun Fact',
                          style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900,
                            color: _textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Passionate about ${widget.member.hobbies.first.toLowerCase()} and always looking for exciting collaborations!',
                      style: const TextStyle(
                        fontSize: 14, color: _textSecondary, height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoTab() {
    const Color cardBg = Color(0xFF14142A);
    const Color border = Color(0xFF2A2A45);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (b) =>
                LinearGradient(colors: _gradient).createShader(b),
            child: const Text(
              'INTRO VIDEO',
              style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w800,
                color: Colors.white, letterSpacing: 3,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Image.network(
                  widget.member.imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _gradient[0].withOpacity(0.3),
                          Colors.black.withOpacity(0.65),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: _gradient),
                        boxShadow: [
                          BoxShadow(
                            color: _gradient[0].withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white, size: 36,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 14, left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.member.name,
                        style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w900,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 8)],
                        ),
                      ),
                      Text(
                        widget.member.role,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: _gradient[0], size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Video introduction coming soon!',
                    style: TextStyle(
                      fontSize: 13, color: _textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}