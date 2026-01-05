import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_aplikasi_mobile/services/auth_preferences.dart';
import 'package:project_aplikasi_mobile/services/database_helper.dart';
import 'package:project_aplikasi_mobile/features/auth/presentaion/screens/login_screen_comic.dart';
import 'package:project_aplikasi_mobile/models/history_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // User data
  String _username = 'User';
  String _email = '';

  // Recent history for grid
  List<HistoryModel> _recentHistory = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      // Load user data
      final userData = await AuthPreferences.getUserData();

      // Load history only if not on web
      List<HistoryModel> history = [];
      if (!kIsWeb) {
        try {
          final dbHelper = DatabaseHelper.instance;
          history = await dbHelper.getAllHistory();
        } catch (e) {
          debugPrint('Database error: $e');
        }
      }

      if (mounted) {
        setState(() {
          _username = userData['username'] ?? 'User';
          _email = userData['email'] ?? '';
          _recentHistory = history.take(3).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthPreferences.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _clearHistory() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur tidak tersedia di web')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus History'),
        content: const Text(
          'Hapus semua riwayat baca? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final dbHelper = DatabaseHelper.instance;
        await dbHelper.clearAllHistory();
        await _loadAllData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('History berhasil dihapus')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus history')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFF4A7CFF),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : RefreshIndicator(
              onRefresh: _loadAllData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Stack(
                  children: [
                    // Background layers
                    Column(
                      children: [
                        // Blue header area
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: topPadding + 16),
                          child: Column(
                            children: [
                              // Header Text
                              Text(
                                'Hai, $_username 👋',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Selamat datang di Comic!',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 70),
                            ],
                          ),
                        ),

                        // White Content Section
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height - 200,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 65),

                              // Username
                              Text(
                                _username,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Recent History Grid
                              _buildRecentHistoryGrid(),

                              const SizedBox(height: 24),

                              // Settings Menu
                              _buildSettingsMenu(),

                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Avatar on top layer
                    Positioned(
                      top: topPadding + 75,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(child: _buildAvatarPlaceholder()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Text(
          _username.isNotEmpty ? _username[0].toUpperCase() : 'U',
          style: TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4A7CFF).withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentHistoryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildHistoryGridItem(0)),
          const SizedBox(width: 10),
          Expanded(child: _buildHistoryGridItem(1)),
          const SizedBox(width: 10),
          Expanded(child: _buildHistoryGridItem(2)),
        ],
      ),
    );
  }

  Widget _buildHistoryGridItem(int index) {
    final bool hasData = index < _recentHistory.length;
    final history = hasData ? _recentHistory[index] : null;

    return AspectRatio(
      aspectRatio: 1.2,
      child: Container(
        decoration: BoxDecoration(
          color: hasData ? Colors.white : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: hasData
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: hasData
              ? CachedNetworkImage(
                  imageUrl: history!.coverUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.book, color: Colors.grey, size: 32),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSettingsMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildMenuItem(
              icon: Icons.settings_outlined,
              title: 'Pengaturan akun',
              onTap: _showAccountSettings,
            ),
            Divider(height: 1, color: Colors.grey[200], indent: 52),
            _buildMenuItem(
              icon: Icons.logout_outlined,
              title: 'Logout',
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  void _showAccountSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pengaturan Akun',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSettingsOption(
              icon: Icons.history,
              title: 'Hapus History',
              subtitle: kIsWeb
                  ? 'Tidak tersedia di web'
                  : 'Hapus semua riwayat baca',
              onTap: () {
                Navigator.pop(context);
                _clearHistory();
              },
            ),
            _buildSettingsOption(
              icon: Icons.help_outline,
              title: 'Bantuan',
              subtitle: 'Pusat bantuan & FAQ',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur dalam pengembangan')),
                );
              },
            ),
            _buildSettingsOption(
              icon: Icons.info_outline,
              title: 'Tentang Aplikasi',
              subtitle: 'COMICU v1.0.0',
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'COMICU',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(
                    Icons.menu_book,
                    size: 48,
                    color: Color(0xFF4A7CFF),
                  ),
                  children: [const Text('Platform Pembaca Komik Digital')],
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF4A7CFF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF4A7CFF)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[700], size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 22),
          ],
        ),
      ),
    );
  }
}
